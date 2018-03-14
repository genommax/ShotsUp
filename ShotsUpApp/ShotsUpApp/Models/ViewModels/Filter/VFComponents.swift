//
//  VFComponents.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


struct VFComponents {
    private let components: [[String]]
    
    init(with components: [[String]]) {
        self.components = components
    }
    
    var count: Int {
        get {
            return components.count
        }
    }
    
    func countItems(by component: Int) -> Int {
        return components[component].count
    }
    
    func item(by component: Int, and row: Int) -> String {
        
    
        
        guard let value = components[component][row] as? String else {
            return ""
        }
        
        return value
    }
}
