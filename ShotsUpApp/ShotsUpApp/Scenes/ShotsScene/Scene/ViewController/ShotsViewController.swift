//
//  ShotsViewController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 03.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


import IGListKit
import ObjectMapper
import Moya
import SwiftMessages



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

protocol ListOfShotsFilterProtocol {
    func presentFilterController()
    func scrollToTop()
}


class ShotsViewController: SUViewController, ListAdapterDataSource, UIScrollViewDelegate {

    var presenter: ShotsPresenter?
    
    var pageInfo: GMPageInfo = GMPageInfo(obgect: "")

    
    // MARK: -  ui
    var stateController = StateController.FirstLoading {
        didSet {
            switch stateController {
            case .Error(_), .NetworkError(_):
                self.adapter.performUpdates(animated: true, completion: nil)

            default:
                break
            }
        }
    }
    
    var storedItems: [ShotsDS]  = [] {
        didSet {
            
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
            
            self.stateController = .Loaded
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
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
    
    private var filter: FilterViewController?
    
    //
    
    let collectionView: UICollectionView = {
        
        let layout = ListCollectionViewLayout(stickyHeaders: false, topContentInset: 0, stretchToEdge: true)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.showsVerticalScrollIndicator = true
        collectionView.backgroundColor = UIColor.white
        collectionView.bounces = true
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        //collectionView.clipsToBounds = false
        
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r  = UIRefreshControl()
        return r
    }()
    
    let spinToken = "spinner"
    let headerToken = "header"
    
    
    // MARK: - init
    required init(with filter: FilterViewController? = nil, displayName: String ) {
        self.filter = filter

        super.init(nibName: nil, bundle: nil)
        self.title = displayName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecykle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialization()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = UIColor.red
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        if !stateController.loading {
            stateController = .Reload
         
            presenter?.requestShots(with: stateController)
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
        
        if !stateController.loading && distance < 200  && canLoadMore {
            stateController = .LoadMore
            adapter.performUpdates(animated: true, completion: nil)
            
            
            presenter?.requestShots(with: stateController)
        }
    }
}

extension ShotsViewController: GMPageInfoProvider {
    
    func tabInfo(for pagerTabScrollController: GMPagerController) -> GMPageInfo {
        
        return pageInfo
    }
}

extension ShotsViewController: ListOfShotsFilterProtocol {
    
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


// MARK:  Configurations

extension ShotsViewController {
    
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
        
        let rect = view.bounds
        collectionView.frame = CGRect(x: 0, y: topOffset, width: rect.size.width, height: rect.size.height - topOffset )
       // collectionView.frame = view.bounds
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


extension ShotsViewController: EmptyViewProtocol {
    
    func load() {
        
        stateController = .FirstLoading
        presenter?.requestShots(with: stateController)
    }
}


extension ShotsViewController: ShotSectionControllerDelegate {
    
    func shotWantsOpen(_ shot: ShotsDS) {
   
        guard let shot = shot as? ShotsDS else {
            return
        }
        
        presenter?.prepareDetail(with: shot)
        
    }
    
    func reboundsWantsOpen(_ shot: ShotsDS) {
        print(shot)
        
        guard let shot = shot as? ShotsDS else {
            return
        }
        
        presenter?.prepareRebounds(with: shot)
        
    }
}

extension ShotsViewController : FilterViewDelegate {
    
    func filterView(_ filterView: FilterViewController, needUpdate: Bool) {
        
        guard needUpdate == true else {
            return
        }
        
        scrollToTop()
        stateController = .Reload
        presenter?.requestShots(with: stateController)
    }
}


