//
//  ShotLikesDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper


//MARK: ShotLikes
class ShotLikesDS: Mappable {
    open var id: Int!
    open var created_at: String!
    open var user: UserDS!
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        created_at <- map["created_at"]
        user <- map["user"]
    }
    
}
