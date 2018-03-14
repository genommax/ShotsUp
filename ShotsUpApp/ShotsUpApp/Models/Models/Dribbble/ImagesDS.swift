//
//  ImagesDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 01.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper
import IGListKit

class ImagesDS: Mappable {
    open var hidpi: String?
    open var normal: String!
    open var teaser: String!
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        hidpi <- map["hidpi"]
        normal <- map["normal"]
        teaser <- map["teaser"]
    }
}


extension ImagesDS: ListDiffable {
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return normal as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ImagesDS else { return false }
        return normal == object.normal
    }
}

