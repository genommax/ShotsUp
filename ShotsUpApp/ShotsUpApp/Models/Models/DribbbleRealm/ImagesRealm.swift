//
//  ImagesRealm.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation
import RealmSwift

class ImagesRealm: Object {
    
    @objc dynamic var hidpi: String? = nil
    @objc dynamic var normal: String = ""
    @objc dynamic var teaser: String = ""
    
    func setup(images: ImagesDS) {
        self.hidpi = images.hidpi
        self.normal = images.normal
        self.teaser = images.teaser
    }
}
