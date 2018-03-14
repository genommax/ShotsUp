//
//  RFType.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 12.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import RealmSwift


final class RFType: Object {
    
    @objc dynamic var id = NSUUID().uuidString // swiftlint:disable:this variable_name
    @objc dynamic var name = ""
    @objc dynamic var value = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
