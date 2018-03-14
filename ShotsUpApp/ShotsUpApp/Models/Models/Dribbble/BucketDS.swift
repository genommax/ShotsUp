//
//  BucketDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper

// Mark: Buckets

class BucketDS: Mappable {
    
    open var id: Int!
    open var name: String!
    open var description: String?
    open var shots_count: Int!
    open var created_at: String!
    open var updated_at: String!
    open var user: UserDS!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        description <- map["description"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
    }
}
