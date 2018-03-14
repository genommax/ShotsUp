//
//  ShotsRealm.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation
import RealmSwift


class ShotsRealm: Object {
    
    @objc dynamic var id : Int = 0
    @objc dynamic var title : String = ""
    @objc dynamic var descriptionShot : String? = nil
  
    @objc dynamic var images: ImagesRealm?
    
    @objc dynamic var views_count : Int = 0
    @objc dynamic var likes_count :  Int = 0
    @objc dynamic var comments_count : Int = 0
    @objc dynamic var attachments_count: Int = 0
    @objc dynamic var rebounds_count: Int = 0
    @objc dynamic var buckets_count: Int = 0
    
    /*@objc dynamic var created_at: Date = Date(timeIntervalSince1970: 1)
    @objc dynamic var updated_at: Date = Date(timeIntervalSince1970: 1)*/
    
    @objc dynamic var created_at: String = ""
    @objc dynamic var updated_at: String = ""
    
    @objc dynamic var html_url: String = ""
    @objc dynamic var animated: Bool = false
    
    //@objc dynamic var user: UserDS!
    //@objc dynamic var team: TeamDS?
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
  
    func setup(shot: ShotsDS) {
        self.id = shot.id
        self.title = shot.title
        self.descriptionShot = shot.description
        
        self.images?.setup(images: shot.images)

        self.views_count = shot.views_count
        self.likes_count = shot.likes_count
        self.comments_count = shot.comments_count
        self.attachments_count = shot.attachments_count
        self.rebounds_count = shot.rebounds_count
        self.buckets_count = shot.buckets_count
        
        self.created_at = shot.created_at
        self.updated_at = shot.updated_at
        
        self.html_url = shot.html_url
        self.animated = shot.animated
    }
    
}
