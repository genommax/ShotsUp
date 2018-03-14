//
//  ShotModel.swift
//  ShotsList
//
//  Created by Maxim Lyashenko on 01.08.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import ObjectMapper

import IGListKit

import RealmSwift
import ObjectMapper_Realm

//Mark: Shots

/**
 Limit the results to a specific type with the following possible values
 */
public enum ShotListDS: String{
    case animated, attachments, debuts, playoffs, rebounds, teams, any
}

/**
 A period of time to limit the results to with the following possible values
 */
public enum ShotTimeFrameDS: String{
    case week, month, year, ever
}

/**
 The sort field with the following possible values.
 */
public enum ShotSortDS: String{
    case comments, recent, views
}


final class ShotsDS:  Mappable {
    open var id : Int!
    open var title : String!
    open var description : String?
    open var width: Int!
    open var height: Int!
    open var images: ImagesDS!
    open var views_count : Int!
    open var likes_count :  Int!
    open var comments_count : Int!
    open var attachments_count: Int!
    open var rebounds_count: Int!
    open var buckets_count: Int!
    open var created_at: String!
    open var updated_at: String!
    open var html_url: String!
    open var attachments_url: String!
    open var buckets_url: String!
    open var comments_url: String!
    open var likes_url: String!
    open var projects_url: String!
    open var rebounds_url: String!
    open var animated: Bool!
    open var tags: [String]?
    
    open var user: UserDS!
    open var team: TeamDS?
    
    required init?(map: Map) {
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        id <- map["id"]
        title <- map["title"]
        description <- map["description"]
        width <- map["width"]
        height <- map["height"]
        images <- map["images"]
        views_count <- map["views_count"]
        likes_count <- map["likes_count"]
        comments_count <- map["comments_count"]
        attachments_count <- map["attachments_count"]
        rebounds_count <- map["rebounds_count"]
        buckets_count <- map["buckets_count"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        html_url <- map["html_url"]
        attachments_url <- map["attachments_url"]
        buckets_url <- map["buckets_url"]
        comments_url <- map["comments_url"]
        likes_url <- map["likes_url"]
        projects_url <- map["projects_url"]
        rebounds_url <- map["rebounds_url"]
        animated <- map["animated"]
        tags <- map["tags"]
        
        user <- map["user"]
        team <- map["team"]

        
    }
}

extension ShotsDS: ListDiffable {
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
