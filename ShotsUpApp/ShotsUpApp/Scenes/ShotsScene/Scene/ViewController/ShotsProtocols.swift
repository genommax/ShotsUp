//
//  ShotsProtocols.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 03.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


enum ShotsRequestType {
    case Home
    case Rebounds
    case UserLikes
    case UserShots
    case Filtered
}

protocol ShotsPresenterProtocol {
    
    func fetchedShots(shots: [ShotsDS])
    func fetchedShots()
    
}

protocol ShotsRouterProtocol {
    
}

protocol ShotsInteractorProtocol {
    
    var perPage: Int { get set }
    var page: Int { get set }
    
    func fetchShots()
}
