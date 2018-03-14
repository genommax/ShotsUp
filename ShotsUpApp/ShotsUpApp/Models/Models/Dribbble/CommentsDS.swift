//
//  CommentsDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper


//Mark: Comments

class CommentDS: Mappable{
    
    open var id: Int!
    open var body: String!
    open var likes_count: Int!
    open var likes_url: String!
    open var created_at: String!
    open var updated_at: String!
    open var user: UserDS!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        body <- map["body_text"]
        likes_count <- map["likes_count"]
        likes_url <- map["likes_url"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        user <- map["user"]
    }
}
