//
//  ShotsFilteredInteractor.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 04.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation



class ShotsFilteredInteractor: ShotsInteractor {
    
    let keyName: String
    
    init(with filterDbManager: FilterDBManager, apiManager: APIManager, id: Int, keyName: String) {
        self.keyName = keyName
        
        super.init(with: filterDbManager, apiManager: apiManager, reqestType: .Filtered, id: 0)
    }
    
    var params: [String: Any] {
        let dict = filterDbManager.getFilterDictionary(by: keyName)

        return dict
    }
    
    
    override func fetchShots() {
        apiManager.getFilteredShots(perPage: perPage, page: page, params: params, successCallback: { (shots) in
            self.page += 1
            self.presenter?.fetchedShots(shots: shots)
            
        }, error: { (error) in
            self.presenter?.fetchedShotsError(error: error)
        }) { (error) in
            self.presenter?.fetchedShotsFailure(error: error)
        }
    }
    
}
