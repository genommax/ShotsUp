//
//  ProfilePresenter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

import IGListKit

import  Moya

enum ProfileSectionsType {
    case user
    case shots
    case likes
    
    
    var title : String {
        switch self {
        case .user:
            return ""
        case .shots:
            return "SHOTS"
        case .likes:
            return "LIKES"
        }
    }
    

}

class ProfileSection  {
    var type: ProfileSectionsType
    var object: Any
    
    init(with type: ProfileSectionsType, object: Any) {
        self.type = type
        self.object = object
    }
}


extension ProfileSection: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return type.title as NSObjectProtocol
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? ProfileSection else { return false }
        return type.hashValue == object.type.hashValue
    }
}


//extension ProfileSections : Diff

class ProfileViewModel {
    
    var user: UserDS
    var shots:[ShotsDS] = [ShotsDS]()
    var likes:[ShotsDS] = [ShotsDS]()
    
    init(with user: UserDS) {
        self.user = user
    }
    
    var objects: [Any] {
        
        var userDict = ProfileSection(with: .user, object: user)
        
        guard shots.count > 0 && likes.count > 0 else {
            return [userDict]
        }
        
        
       
        

        return [userDict, ProfileSection(with: .shots, object: shots),ProfileSection(with: .likes, object: likes)]
        
        //var shotsDict: [ProfileSectionsType: Any] = [ProfileSectionsType: Any]()
        //shotsDict[.shots] = shots
        
        //var likesDict: [ProfileSectionsType: Any] = [ProfileSectionsType: Any]()
        //likesDict[.likes] = likes
        
        //return [userDict, shotsDict, likesDict]
    }
    
}


class ProfilePresenter {

    var view: ProfileViewController?
    var interactor: ProfileInteractor?
    var router: ProfileRouter?

    var factory: RootViewControllersFactory
    
    var viewModel: ProfileViewModel?

    init(with factory: RootViewControllersFactory) {
        self.factory = factory
    }

    
    func request(with stateController: StateController) {
        interactor?.fetchUser(reload: true)
    }
    
    
    func fetched(user: UserDS) {
        
        viewModel = ProfileViewModel(with: user)
        
        guard let viewModel = self.viewModel else { return  }
        
        view?.storedItems = viewModel.objects
    }
    
    func fetchedUserShots(shots: [ShotsDS]) {
        
        viewModel?.shots = shots
        guard let viewModel = self.viewModel else { return  }
        
        view?.storedItems = viewModel.objects
    }
    
    func fetchedUserLikes(shots: [ShotsDS]) {
        
        viewModel?.likes = shots
        guard let viewModel = self.viewModel else { return  }
        
        view?.storedItems = viewModel.objects
    }
    
    
    func fetchedError(error: Swift.Error) {
        view?.stateController = .Error(error)
    }
    
    func fetchedFailure(error: MoyaError) {
        view?.stateController = .NetworkError(error)
    }

}
