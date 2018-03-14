//
//  ProfileViewController.swift
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






class ProfileViewController: SUViewController, ListAdapterDataSource, UIScrollViewDelegate {

    var presenter: ProfilePresenter?
    
    var pageInfo: GMPageInfo = GMPageInfo(obgect: "")

    
   


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
    
    var storedItems: [Any]  = [] {
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
        
        
        return collectionView
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let r  = UIRefreshControl()
        //r.backgroundColor = .red
        return r
    }()
    
    let spinToken = "spinner"
    let headerToken = "header"
    
    
    
    // MARK: - init
    required init(with displayName: String ) {
        
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
        
        presenter?.request(with: stateController)
    }
    
    
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topOffset: CGFloat = 20.0
        let rect = view.bounds
        collectionView.frame = CGRect(x: 0, y: topOffset, width: rect.size.width, height: rect.size.height - topOffset)
    }*/
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topOffset: CGFloat = 64.0
        let rect = view.bounds
        collectionView.frame = CGRect(x: 0, y: topOffset, width: rect.size.width, height: rect.size.height - topOffset - 48)
    }
    
  
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        if !stateController.loading {
            stateController = .Reload
            
            presenter?.request(with: stateController)
        } else {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: ListAdapterDataSource
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let objects = storedItems as! [ListDiffable]
        
        
        return objects
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
     
        var type: ProfileSectionsType = .user
        
        if let item = object as? ProfileSection {
            type = item.type
        }
        
        switch type {
        case .user:
            return SUProfileUserSectionController()
            
        case .shots: 
            return SUProfileHorizontalSectionController()
        
        case .likes:
            return SUProfileHorizontalSectionController()
        
        default:
            return SUProfileUserSectionController()
        }
        
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {        
        
        switch stateController {
        case .FirstLoading:
            let empty: EmptyView = EmptyView.instanceFromNib()
            //empty.delegate = self
            
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
        
        //        guard canLoadMore == true  else {
        //            showMessage(with: "Sorry", subtitle: "No more loading")
        //            return
        //        }
        if !stateController.loading && distance < 200  && canLoadMore {
            stateController = .LoadMore
            adapter.performUpdates(animated: true, completion: nil)
            
            
            presenter?.request(with: stateController)
        }
    }
}

extension ProfileViewController: GMPageInfoProvider {
    
    func tabInfo(for pagerTabScrollController: GMPagerController) -> GMPageInfo {
        
        return pageInfo
    }
}



// MARK:  Configurations

extension ProfileViewController {
    
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
