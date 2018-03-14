//
//  GMSegmentAppearance.swift
//  GMSegmentView
//
//  Created by Maxim Lyashenko on 12.10.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit



public class GMSegmentAppearance {
    
    public var segmentOnSelectionColour: UIColor
    public var segmentOffSelectionColour: UIColor
   
    public var contentVerticalMargin: CGFloat
    public var contentBottomMargin: CGFloat
    
    // init
    public init() {
        
        self.segmentOnSelectionColour = UIColor.darkGray
        self.segmentOffSelectionColour = UIColor.gray
        
        self.contentVerticalMargin = 5.0
        self.contentBottomMargin = 0.0
    }
    
    public init(contentBottomMargin: CGFloat, contentVerticalMargin: CGFloat, segmentOnSelectionColour: UIColor, segmentOffSelectionColour: UIColor) {
        self.contentVerticalMargin = contentVerticalMargin
        self.contentBottomMargin = contentBottomMargin
        
        self.segmentOnSelectionColour = segmentOnSelectionColour
        self.segmentOffSelectionColour = segmentOffSelectionColour
    }
}
