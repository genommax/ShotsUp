//
//  DribbbleAPI.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import Moya
import Keys


fileprivate struct DribbbleAPIConfig {
    fileprivate static let keys = ShotsUpKeys()
    
    static let clientID = keys.dribbbleClientID
    static let clientSecret = keys.dribbbleClientSecret
    static let clientAccessToken = keys.dribbbleClientAccessToken
    
    static let ts = Date().timeIntervalSince1970.description
}

enum DribbbleAPI {
    case shots(perPage: Int, page: Int, params: [String: Any])
    case rebounds(id: Int, perPage: Int, page: Int, date: String?)
    case home(perPage: Int, page: Int, date: String?)
    
    case shot(id: Int)
    case attachments(id: Int)
    
    //
    case user(id: Int)
    case ownUser()
    case userShots(id: Int)
    case userOwnShots()
    case userLikes(id: Int)
    case userOwnLikes()
}

extension DribbbleAPI: TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    
    var baseURL: URL {
        guard let url = URL(string: "https://api.dribbble.com/v1/") else {
            fatalError()
        }
        return url
    }
    
    var path: String {
        switch self {
        case .shots:
            return "shots"
        case .rebounds(let id,_,_,_):
            return "shots/\(id)/rebounds"
        case .home:
            return "user/following/shots"
            
        case .shot(let id):
            return "shots/\(id)"
            
        case .attachments(let id):
            return "/shots/\(id)/attachments"
       
        // user
        case .user(let id):
            return "/users/\(id)"
        case .ownUser:
            return "/user"
        case .userShots(let id):
            return "users/\(id)/shots"
        case .userOwnShots():
            return "/user/shots"
        case .userLikes(let id):
            return "/users/\(id)/likes"
        case .userOwnLikes():
            return "/user/likes"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .shots, .rebounds, .home, .shot, .attachments:
            return .get
        case .user, .ownUser:
            return .get
        case .userShots, .userOwnShots, .userLikes, .userOwnLikes:
            return .get
        default:
            return .post
        }
    }
    
    fileprivate func authParameters() -> [String: String] {
        return ["apikey": DribbbleAPIConfig.clientAccessToken,
                "ts": DribbbleAPIConfig.ts]
    }
    
    var parameters: [String: Any]? {
        
        switch self {
            
        case .shots(let perPage, let page, var dict):
            var params: [String: Any] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            params["per_page"] = perPage as AnyObject?
            params["page"] = page as AnyObject?
            params += dict
            
            return params
            
        case .rebounds(_, let perPage, let page, let date):
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            params["per_page"] = perPage as AnyObject?
            params["page"] = page as AnyObject?
            
            if(date != nil){
                params["date"] = date as AnyObject?
            }
            
            return params
            
        case .home(let perPage, let page, let date):
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            params["per_page"] = perPage as AnyObject?
            params["page"] = page as AnyObject?
            
            if(date != nil){
                params["date"] = date as AnyObject?
            }
            
            return params
        
        case .shot:
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            
            return params
        
        case .attachments:
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            
            return params
        
        case .user, .ownUser():
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            
            return params
        
        case .userShots, .userOwnShots, .userLikes, .userOwnLikes:
            var params: [String: AnyObject] = [:]
            params["access_token"] = DribbbleAPIConfig.clientAccessToken as AnyObject?
            params["per_page"] = 30 as AnyObject?
            params["page"] = 1 as AnyObject?
            
            return params
        }

    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.queryString
    }
    
    var task: Task {
        return Task.requestParameters(parameters: parameters!, encoding: URLEncoding.default)
    }
    
    var sampleData: Data {
        switch self {
        default:
            return Data()
        }
    }
}
