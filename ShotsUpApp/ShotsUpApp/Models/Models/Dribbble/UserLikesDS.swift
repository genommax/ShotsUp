//
//  UserLikesDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 02.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper


//MARK: UserLikes
class UserLikesDS: Mappable {
    open var id: Int!
    open var created_at: String!
    open var shot: ShotsDS!
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        created_at <- map["created_at"]
        shot <- map["shot"]
    }
}
