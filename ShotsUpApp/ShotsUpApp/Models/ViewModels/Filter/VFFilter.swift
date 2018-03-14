//
//  VFFilter.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


struct VFFilter {
    
    var selected: Array<Int>
    
    init(with selected: Array<Int>) {
        self.selected = selected
    }
    
  
    
    var count: Int {
        get {
            return selected.count
        }
    }
    
    func selectedIndex(by component: Int) -> Int {
        
      
        return selected[component]
    }
    
    mutating func update(value: Int, by component: Int) {
        selected[component] = value
    }
}





extension VFFilter: Equatable {}

// MARK: Equatable

func ==(lhs: VFFilter, rhs: VFFilter) -> Bool {
    return lhs.selected == rhs.selected
}

