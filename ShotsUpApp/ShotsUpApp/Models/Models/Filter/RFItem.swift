//
//  RFItem.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 14.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import RealmSwift


class RFItem: Object {

    @objc dynamic var id = NSUUID().uuidString

    @objc dynamic var name = ""
    @objc dynamic var value = ""
    @objc dynamic var num = 0

    @objc dynamic var type: RFType?

    
    override static func primaryKey() -> String? {
        return "id"
    }
        
}


