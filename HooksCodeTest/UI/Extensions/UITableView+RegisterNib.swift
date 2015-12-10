//
//  UITableView+RegisterNib.swift
//  HooksCodeTest
//
//  Created by ANTONIO JIMÉNEZ MARTÍNEZ on 10/12/15.
//  Copyright © 2015 Antonio. All rights reserved.
//

import UIKit

protocol UITableViewCellStaticProtocol {
    static func cellIdentifier() -> String
    static func cellHeight() -> CGFloat
    
}

extension UITableViewCellStaticProtocol {
    static func cellIdentifier() -> String {
        return String(self.dynamicType)
    }
}

extension UITableView {
    func registerNib<T:UITableViewCell where T:UITableViewCellStaticProtocol>(classValue: T.Type) {
        registerNib(UINib(nibName: String(classValue), bundle: nil), forCellReuseIdentifier: classValue.cellIdentifier())
    }
    
}