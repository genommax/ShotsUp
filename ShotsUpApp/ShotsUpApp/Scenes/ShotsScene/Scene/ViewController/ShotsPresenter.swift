//
//  ShotsPresenter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 03.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import Moya
import ObjectMapper




class ShotsPresenter {
    
    var view: ShotsViewController?
    var interactor: ShotsInteractor?
    var router: ShotsRouter?
    
    var factory: RootViewControllersFactory
    
    init(with factory: RootViewControllersFactory) {
        self.factory = factory
    }
    
    func requestShots(with requestType: StateController) {
        
        switch requestType {
        case .Reload:
            interactor?.resetPageToFirst()
        default:
            break
        }
        
        interactor?.fetchShots()
    }
    
    
    //
    
    func fetchedShots(shots: [ShotsDS]) {
        
        guard let requestType = view?.stateController else {
            return
        }
        
        switch requestType {
        case .Reload:
            view?.storedItems.removeAll()
            view?.storedItems.append(contentsOf: shots)
        default:
            view?.storedItems.append(contentsOf: shots)

        }
        
    }
    
    func fetchedShotsError(error: Swift.Error) {
        view?.stateController = .Error(error)
    }
    
    func fetchedShotsFailure(error: MoyaError) {
        view?.stateController = .NetworkError(error)
    }
}

extension ShotsPresenter {
    
    func prepareRebounds(with shot: ShotsDS)  {
        
        let rebounds = factory.createRebounds(with: shot.id)
        
        guard let view = view else { return  }
        
        router?.presentRebounds(with: view, rebound: rebounds)
    }
    
    
    func prepareDetail(with shot: ShotsDS) {
        
        let detail = factory.createDetail(with: shot.id, shot: shot)
        guard let view = view else { return  }
        router?.presentDetail(with: view, detail: detail)

    }
    
}
