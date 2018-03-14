//
//  TabInfo.swift
//  PTSController
//
//  Created by Maxim Lyashenko on 17.10.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


public struct GMPageInfo {
    
    public var obgect: Any?
    public var normalImage: UIImage?
    public var highlightedImage: UIImage?
    
    public init(obgect: Any?) {
        self.obgect = obgect
    }
    
    public init(normalImage: UIImage?) {
        self.normalImage = normalImage
    }
    
    public init(normalImage: UIImage?, obgect: Any?) {
        self.init(normalImage: normalImage)
        self.obgect = obgect
    }
    
    public init(normalImage: UIImage?, highlightedImage: UIImage?) {
        self.init(normalImage: normalImage, obgect: nil)
        self.highlightedImage = highlightedImage
    }
    
    public init(normalImage: UIImage?, highlightedImage: UIImage?, obgect: Any?) {
        self.init(normalImage: normalImage, highlightedImage: highlightedImage)
        self.obgect = obgect
    }
}
