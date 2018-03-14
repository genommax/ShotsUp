//
//  APIManager.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 28.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation
import Alamofire
import Moya
//import RxSwift
import ObjectMapper
import Moya_ObjectMapper
import SystemConfiguration


enum ReachabilityError: Swift.Error {
    case NotReachability
}


class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 5 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 5 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}


class APIManager {
    
    let provider: MoyaProvider<DribbbleAPI> = MoyaProvider<DribbbleAPI>(manager: DefaultAlamofireManager.sharedManager)
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    typealias AdditionalStepsAction = (() -> ())

    public func getFilteredShots(perPage: Int, page: Int, params: [String: Any], successCallback: @escaping ([ShotsDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        var token: DribbbleAPI

        token = DribbbleAPI.shots(perPage: perPage, page: page, params: params)
        getShots(token, successCallback: successCallback, error: errorCallback, failure: failureCallback)
    }
    
    //
    public func getShots(perPage: Int, page: Int, id: Int, requestType: ShotsRequestType, successCallback: @escaping ([ShotsDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        var token: DribbbleAPI
        
        switch(requestType) {
        case .Home:
            token = DribbbleAPI.home(perPage: perPage, page: page, date: nil)
            
        case .Rebounds:
            token = DribbbleAPI.rebounds(id: id, perPage: perPage, page: page, date: nil)
            
        default:
            token = DribbbleAPI.home(perPage: perPage, page: page, date: nil)
        }
        
        getShots(token, successCallback: successCallback, error: errorCallback, failure: failureCallback)
    }
    
    
    fileprivate func getShots(_ token: DribbbleAPI, successCallback: @escaping ([ShotsDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    
                    do {
                        
                        
                        let shots: [ShotsDS] = try response.mapArray(ShotsDS.self) as [ShotsDS]
                        successCallback(shots)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                    
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
            
        }
        
        manager?.startListening()
    }

    
    // MARK: - SHOT
    
     func getShot(_ id: Int, successCallback: @escaping (ShotsDS)->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        
        let token = DribbbleAPI.shot(id: id)

        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    
                    do {
                        
                        let shot: ShotsDS = try response.mapObject(ShotsDS.self) as ShotsDS
                        successCallback(shot)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                    
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
            
        }
        
        manager?.startListening()
    }
    
    
    // MARK: - ATTACHMENTS
    
     func getAttachments(_ id: Int, successCallback: @escaping ([AttachmentDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        let token = DribbbleAPI.attachments(id: id)
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    
                    do {
                        
                        let attachments: [AttachmentDS] = try response.mapArray(AttachmentDS.self) as [AttachmentDS]
                        successCallback(attachments)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                    
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
            
        }
        
        manager?.startListening()
    }
    
    
    // MARK: - USER
    
    func getUser(_ id: Int? = nil, successCallback: @escaping (UserDS)->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        let token: DribbbleAPI
        
        if id == nil {
            token = DribbbleAPI.ownUser()
        } else {
            token = DribbbleAPI.user(id: id!)
        }
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    do {
                        let user: UserDS = try response.mapObject(UserDS.self) as UserDS
                        successCallback(user)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
        }
        
        manager?.startListening()
    }
    
    // MARK: - User Shots
    
    func getUserShots(_ id: Int? = nil, successCallback: @escaping ([ShotsDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        let token: DribbbleAPI
        
        if id == nil {
            token = DribbbleAPI.userOwnShots()
        } else {
            token = DribbbleAPI.userShots(id: id!)
        }
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    
                    do {
                        
                        let shots: [ShotsDS] = try response.mapArray(ShotsDS.self) as [ShotsDS]
                        successCallback(shots)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                    
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
            
        }
        
        manager?.startListening()
    }
    
    
    // MARK: - User Likes
    
    func getUserLikes(_ id: Int? = nil, successCallback: @escaping ([ShotsDS])->Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
        
        let token: DribbbleAPI
        
        if id == nil {
            token = DribbbleAPI.userOwnLikes()
        } else {
            token = DribbbleAPI.userLikes(id: id!)
        }
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            self.manager?.stopListening()
            
            guard status != .notReachable else {
                
                let err = ReachabilityError.NotReachability
                errorCallback(err)
                return
            }
            
            self.provider.request(token) { result in
                switch result {
                case let .success(response):
                    
                    do {
                        
                        let shotsLikes: [UserLikesDS] = try response.mapArray(UserLikesDS.self) as [UserLikesDS]
                        var shots: [ShotsDS] = [ShotsDS]()
                        
                        for like in shotsLikes {
                            shots.append(like.shot)
                        }
                        
                        successCallback(shots)
                    } catch let err {
                        print(err)
                        errorCallback(err)
                    }
                    
                case let .failure(error):
                    print(error)
                    failureCallback(error)
                }
            }
            
        }
        
        manager?.startListening()
    }
    
    
}
