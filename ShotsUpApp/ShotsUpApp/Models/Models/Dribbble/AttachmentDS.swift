//
//  AttachmentDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper
import IGListKit

//Mark: Attachment

class AttachmentDS: Mappable {
    
    open var id: Int!
    open var url: String!
    open var thumbnail_url: String!
    open var size: Int!
    open var content_type: String!
    open var views_count: Int!
    open var created_at: String!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        thumbnail_url <- map["thumbnail_url"]
        size <- map["size"]
        content_type <- map["content_type"]
        views_count <- map["views_count"]
        created_at <- map["created_at"]
    }
}


extension AttachmentDS: ListDiffable {
    // MARK: ListDiffable
    
    func diffIdentifier() -> NSObjectProtocol {
        return id as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ShotsDS else { return false }
        return id == object.id
    }
}
