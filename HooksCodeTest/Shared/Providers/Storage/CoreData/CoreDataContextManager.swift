//
//  CoreDataContextManager.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import CoreData

class CoreDataContextManager: NSObject {
    
    private struct CoreDataConstants {
        static let dataStoreFilename = "AppStorage.sqlite"
        static let dataModelFilename = "DataModel"
    }
    
    static let sharedInstance = CoreDataContextManager()
    
    lazy var writeManagedObjectContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.managedObjectContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        context.parentContext = self.writeToDiskManagedObjectContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        return context
    }()
    
    private lazy var writeToDiskManagedObjectContext: NSManagedObjectContext? = {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
        context.persistentStoreCoordinator = self.persistentStorage
        return context
    }()
    
    private lazy var persistentStorage: NSPersistentStoreCoordinator = { [weak self] in
        let filename = CoreDataConstants.dataStoreFilename
        let storeURL = self!.applicationDocumentsDirectory()?.URLByAppendingPathComponent(filename)
        var persistentStore = NSPersistentStoreCoordinator(managedObjectModel: self!.managedObjectModel)
        let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        do {
            try persistentStore.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
        } catch let error as NSError {
            print(error)
            do {
                try NSFileManager.defaultManager().removeItemAtURL(storeURL!)
            }
            catch let error as NSError {
                print(error)
            }
            persistentStore = NSPersistentStoreCoordinator(managedObjectModel: self!.managedObjectModel)
            do {
                try persistentStore.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
            }
            catch let error as NSError {
                print(error)
            }
        }
        return persistentStore
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource(CoreDataConstants.dataModelFilename, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var notificationCenter = {
        return NSNotificationCenter.defaultCenter()
    }()
    
    private override init() {
        super.init()
        registerForManagedObjectContextSaveNotifications()
    }
    
    deinit {
        unregisterForManagedObjectContextSaveNotifications()
    }
    
    
    //MARK: - Notifications
    private func registerForManagedObjectContextSaveNotifications() {
        notificationCenter.addObserver(self, selector: "managedObjectContextSavedChanges:", name:NSManagedObjectContextDidSaveNotification, object:managedObjectContext)
        notificationCenter.addObserver(self, selector: "managedObjectContextSavedChanges:", name:NSManagedObjectContextDidSaveNotification, object:writeManagedObjectContext)
    }
    
    private func unregisterForManagedObjectContextSaveNotifications() {
        notificationCenter.removeObserver(self)
    }
    
    //MARK: - Utils
    func managedObjectContextSavedChanges(notification:NSNotification) {
        if let notificationContext = notification.object as! NSManagedObjectContext? {
            let updateContext = notificationContext == managedObjectContext ? writeToDiskManagedObjectContext! : managedObjectContext!
            if updateContext.hasChanges {
                updateContext.performBlock({
                    do {
                        try updateContext.save()
                    } catch let error as NSError {
                        print(error)
                    }
                })
            }
        } else { // if we dont have the notification object, try to trigger root of all context
            if writeManagedObjectContext!.hasChanges {
                writeManagedObjectContext!.performBlock({ [weak self] in
                    do {
                        try self!.writeManagedObjectContext!.save()
                    } catch let error as NSError {
                        print(error)
                    }
                    })
            }
        }
    }
    
    private func applicationDocumentsDirectory() -> NSURL? {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last
    }
    
}
