//
//  NSManagedObjectContext+ChangeContext.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 09/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func objectInManagedObjectContext<T>(object : T) -> T {
        let managedObject = object as! NSManagedObject
        if managedObject.managedObjectContext == self {
            return object
        }
        var newObject : NSManagedObject?
        let objectId = managedObject.objectID
        self.performBlockAndWait {
            let newManagedObject = self.objectWithID(objectId)
            newObject = newManagedObject
        }
        return newObject as! T
    }
}