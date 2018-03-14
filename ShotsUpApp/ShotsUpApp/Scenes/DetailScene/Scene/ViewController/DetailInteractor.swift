//
//  DetailInteractor.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation



class DetailInteractor {
    
    var presenter: DetailPresenter?
    
    // MARK: - managers
    let filterDbManager: FilterDBManager
    let apiManager: APIManager
    
    
    
    let id: Int
    var shot: ShotsDS?
    
    
    // MARK: - initializer
    
    init(with filterDbManager: FilterDBManager, apiManager: APIManager, id: Int, shot: ShotsDS? = nil) {
        self.filterDbManager = filterDbManager
        self.apiManager = apiManager
        
        self.id = id
        self.shot = shot
    }
    
    
    func fetchShot(reload: Bool) {
        
        guard let shot = shot else {
            return
        }
        
        if reload == false {
            fetchStoredShot(shot: shot)
            fetchAttachments()
            return
        }
        
        fetchShot(with: shot.id)
    }
    
    private func fetchStoredShot(shot: ShotsDS) {
        presenter?.requestedDetails(shot: shot)
        
        
    }
    
    private func fetchShot(with id: Int) {
        apiManager.getShot(id, successCallback: { (resultShot) in
            self.shot = resultShot
            self.presenter?.requestedDetails(shot: resultShot)
            self.fetchAttachments()
        }, error: { (error) in
            self.presenter?.fetchedError(error: error)
        }) { (moyaError) in
            self.presenter?.fetchedFailure(error: moyaError)
        }
    }
    
    // MRK: attachments
    
    func fetchAttachments() {
        guard let shot = shot else {
            return
        }
        
        apiManager.getAttachments(shot.id, successCallback: { (attachemts) in
            self.presenter?.requestedAttachments(attachments: attachemts)
        }, error: { (error) in
            self.presenter?.fetchedError(error: error)
        }) { (moyaError) in
            self.presenter?.fetchedFailure(error: moyaError)
        }
    }
}
