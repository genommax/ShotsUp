//
//  RFController.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 20.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import RealmSwift


class RFController: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    
    @objc dynamic var name = ""
    @objc dynamic var displayName = ""

    
    @objc dynamic var num = 0
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

