//
//  GMSegmentAction+Title.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


extension GMSegmentAction {
    
    var title: String {
        
        var titleString = ""
        
        switch (self) {
        case .selectItem:
            titleString    = "Select Item"
        case .longTapItem:
            titleString   = "Long press Item"
        case .secondTapItem:
            titleString = "Scroll to Top"
        }
        
        return titleString
    }
    
}
