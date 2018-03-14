//
//  TeamDS.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 01.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper


class TeamDS: Mappable {
    
    open var id: Int!
    open var name: String!
    open var username: String!
    open var html_url: String!
    open var avatar_url: String!
    open var bio: String!
    open var location: String!
    open var links: [String: String]?
    open var buckets_count: Int!
    open var comments_received_count: Int!
    open var followers_count: Int!
    open var followings_count: Int!
    open var likes_count: Int!
    open var likes_received_count: Int!
    open var members_count: Int!
    open var projects_count: Int!
    open var rebounds_received_count: Int!
    open var shots_count: Int!
    open var can_upload_shot: Bool!
    open var type: String!
    open var pro: Bool!
    open var buckets_url: String!
    open var followers_url: String!
    open var following_url: String!
    open var likes_url: String!
    open var members_url: String!
    open var shots_url: String!
    open var team_shots_url: String!
    open var created_at: String!
    open var updated_at: String!
    
    open var teams_count: Int!
    open var teams_url: String!
    open var projects_url: String!

    
    required init?(map: Map) {

    }
    
    func mapping(map: Map) {
       
        id <- map["id"]
        name <- map["name"]
        username <- map["username"]
        html_url <- map["html_url"]
        avatar_url <- map["avatar_url"]
        bio <- map["bio"]
        location <- map["location"]
        links <- map["links"]
        buckets_count <- map["buckets_count"]
        comments_received_count <- map["comments_received_count"]
        followers_count <- map["followers_count"]
        followings_count <- map["followings_count"]
        likes_count <- map["likes_count"]
        likes_received_count <- map["likes_received_count"]
        projects_count <- map["projects_count"]
        rebounds_received_count <- map["rebounds_received_count"]
        shots_count <- map["shots_count"]
        can_upload_shot <- map["can_upload_shot"]
        type <- map["type"]
        pro <- map["pro"]
        buckets_url <- map["buckets_url"]
        followers_url <- map["followers_url"]
        likes_url <- map["likes_url"]
        projects_url <- map["projects_url"]
        shots_url <- map["shots_url"]
        teams_url <- map["teams_url"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        teams_count <- map["teams_count"]
        members_count <- map["members_count"]
        members_url <- map["members_url"]
        team_shots_url <- map["team_shots_url"]
    }
    
    
}
