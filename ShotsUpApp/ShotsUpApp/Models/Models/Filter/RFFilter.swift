//
//  RFFilters.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 12.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import RealmSwift


class RFFilter: Object {
    
    @objc dynamic var id = NSUUID().uuidString

    @objc dynamic var controller: RFController?
   
    let defaultFilter = List<RFItem>()
    let customFilter = List<RFItem>()
    
    
    var name: String {
        get {
            guard let controller = controller else {
                return ""
            }
            return controller.name
        }
    }
    
    var displayName: String {
        get {
            guard let controller = controller else {
                return ""
            }
            return controller.displayName
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var isCustom: Bool {
        get {
            if customFilter.count != 0 {
                return true
            }
            return false
        }
    }
    
    var filter: List<RFItem> {
        get {
            if customFilter.count != 0 {
                return customFilter
            }
            return defaultFilter
        }
    }

}
