//
//  RootControllersFactory.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 24.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

//enum ListOfShotsTypes {
//    case shots(params: [String: AnyObject])
//    case rebounds(id: String )
//    case home(id: String?)
//    case userShots(id: String)
//}


class RootViewControllersFactory {

    let dbManager: FilterDBManager
    let aPIManager: APIManager
    // MARK: -
    
    
    // MARK: - init
    init() {
        self.dbManager = FilterDBManager()
        self.aPIManager = APIManager()
    }

    
    func createRootTabViewController() -> RootTabViewController {
        
        var controllers: [SUViewController] = [SUViewController]()
        
        // home
        let home = createHome()
        controllers.append(home)
        
        // filters
        createListOfShots(with: &controllers)
        
        //  create vc
        let rootController = RootTabViewController(with: controllers)
        
        return rootController
    }
    
    
    // MARK: - Home
    func createHome() -> SUViewController {
        
        let controller = ShotsViewController(with: nil, displayName: "HOME")
        controller.pageInfo = GMPageInfo(normalImage: UIImage(named: "tabIconSelected"), highlightedImage: UIImage(named: "tabIcon"))
        
        let presenter: ShotsPresenter = ShotsPresenter(with: self)
        let interactor: ShotsInteractor = ShotsInteractor(with: dbManager, apiManager: aPIManager, reqestType: .Home, id: 0)
        let router: ShotsRouter =  ShotsRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        
        return controller
    }
    
    // MARK: - ( Popular,Recent, Debut, Animated, Teams, Shots )
    private func createListOfShots(with controllers: inout [SUViewController] ) {
        
        for (index, item) in dbManager.getFilters().enumerated() {
            
            let vc = createFilterController(with: item.name, displayName: item.displayName)
            vc.pageInfo = GMPageInfo(normalImage: UIImage(named: "tabIconSelected"), highlightedImage: UIImage(named: "tabIcon"))
            
            guard index < 4 else {
                return
            }
            controllers.append(vc)
        }
        
    }
    
    // MARK: - Profile
    func createProfile(with id: Int, user: UserDS? = nil) -> SUViewController {
        
        let controller = ProfileViewController(with:  "PROFILE")
        
        
        let presenter: ProfilePresenter = ProfilePresenter(with: self)
        let interactor: ProfileInteractor = ProfileInteractor(with: dbManager, apiManager: aPIManager,  id: id, user: user)
        let router: ProfileRouter = ProfileRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        return controller
    }
    
    // MARK: - Following
    func createFollowing(with id: String) -> SUViewController {
        
        return SUViewController()
    }
    
    // MARK: Rebounds
    func createRebounds(with id: Int) -> SUViewController {
        
        let controller = ShotsViewController(with: nil, displayName: "REBOUNDS")
        controller.pageInfo = GMPageInfo(normalImage: UIImage(named: "tabIconSelected"), highlightedImage: UIImage(named: "tabIcon"))
        
        let presenter: ShotsPresenter = ShotsPresenter(with: self)
        let interactor: ShotsInteractor = ShotsInteractor(with: dbManager, apiManager: aPIManager, reqestType: .Rebounds, id: id)
        let router: ShotsRouter =  ShotsRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        
        return controller
    }
    
    
    // MARK: - Filter
    private func createFilterController(with filterName: String, displayName: String) -> ShotsViewController {
        
        
        let filter: FilterViewController = FilterViewController()
        
        let controller = ShotsViewController(with: filter, displayName: displayName)
        controller.pageInfo = GMPageInfo(normalImage: UIImage(named: "tabIconSelected"), highlightedImage: UIImage(named: "tabIcon"))
        
        let presenterFilter: FilterPresenter = FilterPresenter()
        let interactorFilter: FilterInteractor = FilterInteractor(with: dbManager, filterName: filterName)
        let routerFilter: FilterRouter =  FilterRouter(with: controller)
        
        filter.presenter = presenterFilter
        presenterFilter.interactor = interactorFilter
        presenterFilter.view = filter
        presenterFilter.router = routerFilter
        interactorFilter.presenter = presenterFilter
        routerFilter.presenter = presenterFilter
        
        
        
        
        let presenter: ShotsPresenter = ShotsPresenter(with: self)
        let interactor: ShotsFilteredInteractor = ShotsFilteredInteractor(with: dbManager, apiManager: aPIManager, id: 0, keyName: filterName)
        let router: ShotsRouter =  ShotsRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        
        
        //delegate = controller
        
        return controller
    }
    
    
    
    // MARK: - details
    
    func createDetail(with id: Int, shot: ShotsDS? = nil) -> DetailViewController {
        
        
        let controller = DetailViewController(with:  "DETAIL")
        
        
        let presenter: DetailPresenter = DetailPresenter(with: self)
        let interactor: DetailInteractor = DetailInteractor(with: dbManager, apiManager: aPIManager,  id: id, shot: shot)
        let router: DetailRouter = DetailRouter()
        
        controller.presenter = presenter
        presenter.interactor = interactor
        presenter.view = controller
        presenter.router = router
        interactor.presenter = presenter
        router.presenter = presenter
        
        
        return controller
        
    }
    
    
}


// MARK: -

extension RootViewControllersFactory {
    
    
}

