//
//  Dictionary+Extension.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 29.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


extension Dictionary {
    
    static func += (left: inout [Key: Value], right: [Key: Value]) {
        for (key, value) in right {
            left[key] = value
        }
    }
}
