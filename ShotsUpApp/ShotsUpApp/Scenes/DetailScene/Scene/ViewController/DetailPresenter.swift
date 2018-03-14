//
//  DetailPresenter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import Moya

class DetailPresenter {
    
    var view: DetailViewController?
    var interactor: DetailInteractor?
    var router: DetailRouter?
    
    var factory: RootViewControllersFactory
    
    
    var detailViewModel: SUDetailViewModel? {
        didSet {
            
            guard let viewModel = detailViewModel else {
                return
            }
            
            view?.storedItems.append(contentsOf: viewModel.objects)
        }
    }
    
    init(with factory: RootViewControllersFactory) {
        self.factory = factory
        self.detailViewModel = SUDetailViewModel()
    }
    
    
    func requestDetails(with stateController: StateController) {
        
        switch stateController {
        case .FirstLoading:
            interactor?.fetchShot(reload: false)

        default:
            interactor?.fetchShot(reload: true)
        }
        
    }
    
    
    func requestedDetails(shot: ShotsDS) {
        
        detailViewModel?.shot = shot
        
        guard let viewModel = detailViewModel else {
            return
        }
        view?.storedItems.removeAll()
        view?.storedItems.append(contentsOf: viewModel.objects)

    }
    
    func requestedAttachments(attachments: [AttachmentDS]) {
        
        detailViewModel?.attachments = attachments
        
        guard let viewModel = detailViewModel else {
            return
        }
        view?.storedItems.removeAll()
        view?.storedItems.append(contentsOf: viewModel.objects)
    }
    
    func fetchedError(error: Swift.Error) {
        view?.stateController = .Error(error)
    }
    
    func fetchedFailure(error: MoyaError) {
        view?.stateController = .NetworkError(error)
    }
    
    
    func prepareProfile(with user: UserDS) {
        
        let profile = factory.createProfile(with: user.id, user: user)
        guard let view = view else { return  }
        router?.presentProfile(with: view, profile: profile)
    }
    
}
