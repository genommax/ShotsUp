//
//  ProfileInteractor.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation



class ProfileInteractor {

    var presenter: ProfilePresenter?

    // MARK: - managers
    let filterDbManager: FilterDBManager
    let apiManager: APIManager
    let id: Int

    let user: UserDS?
    // MARK: - initializer

    init(with filterDbManager: FilterDBManager, apiManager: APIManager, id: Int, user: UserDS? = nil) {
        self.filterDbManager = filterDbManager
        self.apiManager = apiManager

        self.id = id
        self.user = user
    }
    
    func fetchUser(reload: Bool) {
        
        guard let user = self.user else {
            fetchUser(with: id)
            return
        }
        
        fetchStoredUser(with: user)
        
    }
    
    private func fetchStoredUser(with user: UserDS) {
         presenter?.fetched(user: user)
        
       
         fetchLikes(with: user.id)
         fetchShots(with: user.id)
    }
    
    private func fetchUser(with id: Int) {
        
    }
    
    
    func fetchShots(with id: Int) {
        apiManager.getUserShots(id, successCallback: { (resultShot) in
            //self.shot = resultShot
            self.presenter?.fetchedUserShots(shots: resultShot)
            
            //self.fetchAttachments()
        }, error: { (error) in
            self.presenter?.fetchedError(error: error)
        }) { (moyaError) in
            self.presenter?.fetchedFailure(error: moyaError)
        }
    }
    
    func fetchLikes(with id: Int) {
        apiManager.getUserLikes(id, successCallback: { (resultShot) in
            self.presenter?.fetchedUserLikes(shots: resultShot)
        }, error: { (error) in
            self.presenter?.fetchedError(error: error)
        }) { (moyaError) in
            self.presenter?.fetchedFailure(error: moyaError)
        }
    }
    
    func fetchProjects(with id: Int) {
        
    }
    
    func fetchBuckets(with id: Int) {
        
    }
    
}
