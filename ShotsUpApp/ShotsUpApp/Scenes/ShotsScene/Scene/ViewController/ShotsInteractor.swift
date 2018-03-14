//
//  ShotsInteractor.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 03.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


class ShotsInteractor: ShotsInteractorProtocol {

    // MARK: - output
    var presenter: ShotsPresenter?
    
    // MARK: - managers
    let filterDbManager: FilterDBManager
    let apiManager: APIManager
    
    // MARK: - request params
    var perPage: Int = 30
    var page: Int = 1
    
    let reqestType: ShotsRequestType
    let id: Int
    
    // MARK: - initializer
    
    init(with filterDbManager: FilterDBManager, apiManager: APIManager, reqestType: ShotsRequestType, id: Int) {
        self.filterDbManager = filterDbManager
        self.apiManager = apiManager
        
        self.reqestType = reqestType
        self.id = id
    }
    
    func resetPageToFirst() {
        page = 1
    }
   
    func fetchShots() {
        apiManager.getShots(perPage: perPage, page: page, id: id, requestType: reqestType, successCallback: { (shots) in
            self.page += 1
            self.presenter?.fetchedShots(shots: shots)
            self.filterDbManager.storeShotsDS(shots: shots)
            
        }, error: { (error) in
            self.presenter?.fetchedShotsError(error: error)
        }) { (error) in
            self.presenter?.fetchedShotsFailure(error: error)
        }
    }
    
    
}
