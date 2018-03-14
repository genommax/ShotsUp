//
//  ListOfShotsViewController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 27.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


import IGListKit
import ObjectMapper
import Moya
import SwiftMessages

enum ListOfShotsTypes {
    case home
    case filtered
    case rebounds
    case userShots
    case likes
}


enum StateController {
    case FirstLoading
    case Reload
    case LoadMore
    case Empty
    case Loaded
    case Error(Swift.Error)
    case NetworkError(MoyaError)
    
    var loading: Bool {
        get {
            switch self {
            case .FirstLoading:
                return true
            case .LoadMore:
                return true
            case .Reload:
                return true
            default:
                return false
            }
        }
    }
}



func ==(lhs: StateController, rhs: StateController) -> Bool {
    switch (lhs, rhs) {
    case (.FirstLoading, .FirstLoading):
        return true
        
    case (.Reload, .Reload):
        return true
        
    case (.LoadMore, .LoadMore):
        return true
        
    case (.Empty, .Empty):
        return true
        
    case (.Loaded, .Loaded):
        return true
        
    case (let .Error(code1 as ReachabilityError), let .Error(code2 as ReachabilityError)):
        return code1 == code2
        
    case (let .NetworkError(code1), let .NetworkError(code2)):
        return code1.response?.statusCode == code2.response?.statusCode
        
        
    default:
        return false
    }
}


protocol ShotsListViewControllerProtocol {
    
    //var requestType: ShotsRequestType { get set }
    var perPage: Int { get set }
    var page: Int { get set }
    
    // -
    func firstLoad()
    func loadMore()
    func reload()
    
}


protocol ListOfShotsFilterProtocol {
    func presentFilterController()
    func scrollToTop()
}


class ListOfShotsViewController: SUViewController , ListAdapterDataSource, UIScrollViewDelegate, ShotsListViewControllerProtocol{

    private let rootFactory: RootViewControllersFactory
    private var filter: FilterViewController?
    var pageInfo: GMPageInfo = GMPageInfo(obgect: "")

    var controllerType: ListOfShotsTypes = .filtered
    var id: Int?
    
    let aPIManager: APIManager
    let dbManager: FilterDBManager
    
    // MARK: -  ui
    var stateController = StateController.FirstLoading
    
    var storedItems: [SUViewModel] = [SUViewModel]()
    var canLoadMore: Bool {
        get {
            if storedItems.count % 30 == 0 {
                return true
            } else {
                return false
            }
        }
    }
    
    var count: Int {
        get {
            return storedItems.count
        }
    }
    
    
    //=var requestType: ShotsRequestType
    var perPage: Int = 30
    var page: Int = 0
    
    
    
    
    let collectionView: UICollectionView = {
        
        let layout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true

        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r  = UIRefreshControl()
        r.backgroundColor = .red
        return r
    }()
    
    let spinToken = "spinner"
    let headerToken = "header"
    
    // MARK: - oultles
    
    
    
    // MARK: - init

    required init(with factory: RootViewControllersFactory, filter: FilterViewController? = nil, type: ListOfShotsTypes? = nil, id: Int? = nil, displayName: String ) {
        
        perPage = 30
        page = 1
        
        rootFactory = factory
        aPIManager = factory.aPIManager
        dbManager = factory.dbManager

        
        self.filter = filter
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = displayName
        
        // type
        self.id = id
        guard let type = type else {
            return
        }
        
        controllerType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initialization()
    }

    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        if !stateController.loading {
            stateController = .Reload
            page = 1
            reload()
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var objects = storedItems as! [ListDiffable]
        
        if objects.count > 0 {
            objects.insert(headerToken as ListDiffable, at: 0)
        }
        
        if stateController.loading {
            objects.append(spinToken as ListDiffable)
        }
        
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if let obj = object as? String, obj == headerToken {
            return headerSectionController(with: self.title!) //=  requestType.name
        } else if let obj = object as? String, obj == spinToken {
            return spinnerSectionController()
        } else {
            let shotSectionController = ShotSectionController()
            shotSectionController.delegate = self
            return shotSectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        
        //        guard storedItems.count > 0 else {
        //            return nil
        //        }
        
        
  
        
        switch stateController {
        case .FirstLoading:
            let empty: EmptyView = EmptyView.instanceFromNib()
            empty.delegate = self
            
            if count == 0 {
                empty.load()
            }
            return empty
        case .Error(let error):
            let errorView: ErrorView = ErrorView.instanceFromNib(with: error)
            return errorView
        case .NetworkError(let error):
            let errorView: NoInternetView = NoInternetView.instanceFromNib(with: error)
            return errorView
        default:
            return nil
        }
        
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
        
        guard canLoadMore == true  else {
            showMessage(with: "Sorry", subtitle: "No more loading")
            return
        }
        if !stateController.loading && distance < 200 {
            stateController = .LoadMore
            adapter.performUpdates(animated: true, completion: nil)
            loadMore()
        }
    }
}


extension ListOfShotsViewController: GMPageInfoProvider {
    
    func tabInfo(for pagerTabScrollController: GMPagerController) -> GMPageInfo {
        
        return pageInfo
    }
}

extension ListOfShotsViewController: ListOfShotsFilterProtocol {
    
    func presentFilterController() {
        
        guard let filter = filter else {
            return
        }
        
        present(filter, animated: true, completion: nil)
    }
    
    func scrollToTop() {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
    }
}



// MARK: -


// MARK:  Configurations

extension ListOfShotsViewController {
    
    fileprivate func initialization() {
        setCollectionView()
        setCollectionViewCells()
        setCollectionViewRefrestControl()
    }
    
    fileprivate func setCollectionView() {
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.scrollViewDelegate = self
        adapter.dataSource = self
        collectionView.frame = view.bounds
    }
    
    fileprivate func setCollectionViewCells() {
        let cellNib = UINib(nibName: "SUShotCell", bundle: Bundle.main)
        collectionView.register(cellNib, forCellWithReuseIdentifier: "SUShotCell")
    }
    
    fileprivate func setCollectionViewRefrestControl() {
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
    }
    
    func showMessage(with title: String, subtitle: String) {
        let view: MessageView
        
        view = try! SwiftMessages.viewFromNib()
        
        view.configureContent(title: title, body: subtitle, iconImage: nil, iconText: nil, buttonImage: nil, buttonTitle: "Hide", buttonTapHandler: { _ in SwiftMessages.hide() })
        
        view.configureTheme(.info, iconStyle: IconStyle.default)
        // Config setup
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        
        
        // Show
        SwiftMessages.show(config: config, view: view)
    }
    
    @IBAction func hide(_ sender: AnyObject) {
        SwiftMessages.hide()
    }
    
}


extension ListOfShotsViewController: EmptyViewProtocol {
    
    func load() {
                
        firstLoad()
    }
}


extension ListOfShotsViewController: ShotSectionControllerDelegate {
    
    func shotWantsOpen(_ shot: SUViewModel) {
        //        let detail = SampleDetailViewController()
        //        detail.shot = shot as? ShotsDS
        //        self.navigationController?.pushViewController(detail, animated: true)
        
        
        
        //=let detailVC = factory.createDetailViewController(with: .detail(id: 1))
        
        //=detailVC.shot = shot as? ShotsDS
        
        
        //=self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func reboundsWantsOpen(_ shot: SUViewModel) {
        print(shot)
        
        guard let shot = shot as? ShotsDS else {
            return
        }
        
        let vc = rootFactory.createRebounds(with: shot.id)
        self.navigationController?.pushViewController(vc, animated: true)
        //=let vc = ShotsListViewController(requestType: .rebounds(id: shot.id), factory: rootFactory)
        //=self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ListOfShotsViewController {
    
    var path: [String : Any] {
        guard let name = filter?.filterName else {
            return [ : ]
        }
        
        var dict = dbManager.getFilterDictionary(by: name)
        
        return dict
    }
    
}


// MARK: ShotsListViewControllerProtocol

extension ListOfShotsViewController {
    
    func firstLoad() {
        
        /*aPIManager.getShots(perPage: perPage, page: page, params: path, id: id, type:controllerType, successCallback: { shots in
            self.stateController = .Loaded
            self.storedItems = shots
            self.page += 1
            
            self.adapter.performUpdates(animated: true, completion: nil)
        }, error: { error in
            self.stateController = .Error(error)
            
            self.adapter.performUpdates(animated: true, completion: nil)
        }, failure: { moyaError in
            self.stateController = .NetworkError(moyaError)
            
            self.adapter.performUpdates(animated: true, completion: nil)
        })*/
    }
    
    func loadMore() {
       /* aPIManager.getShots(perPage: perPage, page: page, params: path, id: id, type:controllerType, successCallback:  { shots  in
            self.storedItems.append(contentsOf: shots)
            self.stateController = .Loaded
            self.page += 1
            
            self.adapter.performUpdates(animated: true, completion: nil)
        }, error: { error in
            self.stateController = .Error(error)
            
            self.adapter.performUpdates(animated: true, completion: nil)
        }, failure: { moyaError in
            self.stateController = .NetworkError(moyaError)
            
            self.adapter.performUpdates(animated: true, completion: nil)
        })*/
    }
    
    func reload() {
        /*aPIManager.getShots(perPage: perPage, page: page, params: path, id: id, type:controllerType, successCallback: { shots in
            self.stateController = .Loaded
            self.storedItems = shots
            self.page += 1
            
            self.adapter.performUpdates(animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        }, error: { error in
            self.stateController = .Error(error)
            
            self.adapter.performUpdates(animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        }, failure: { moyaError in
            self.stateController = .NetworkError(moyaError)
            
            self.adapter.performUpdates(animated: true, completion: nil)
            self.refreshControl.endRefreshing()
        })*/
    }
}


extension ListOfShotsViewController : FilterViewDelegate {
    
    func filterView(_ filterView: FilterViewController, needUpdate: Bool) {
        
        guard needUpdate == true else {
            return
        }
        
        page = 1
        scrollToTop()
        reload()
    }
}

