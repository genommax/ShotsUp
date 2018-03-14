//
//  DetailViewController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 06.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import IGListKit
import ObjectMapper
import Moya
import SwiftMessages



protocol DetailSectionControllerDelegate {
    func shotWantsOpen(_ shot: ShotsDS)
    func reboundsWantsOpen(_ shot: ShotsDS)
    func profileWantsOpen(_ user: UserDS)
    func teamWantsOpen(_ team: TeamDS)
    func attachmentWantsOpen(_ attachment: AttachmentDS)
}



class DetailViewController: SUViewController, ListAdapterDataSource, UIScrollViewDelegate {

    var presenter: DetailPresenter?
    
    @IBOutlet weak var bottomView: SUDetailBottomView!
    
    
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
    
    var storedItems: [SUViewModel]  = [] {
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()

        presenter?.requestDetails(with: stateController)
    }
    
    
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
            
            presenter?.requestDetails(with: stateController)
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
        
        switch object {
        case is ImagesDS:   return SUDetailImageSectionController()
        case is ShotsDS:
            let detailShotSection = SUDetailShotSectionController()
            detailShotSection.delegate = self
            return detailShotSection
        case is SUDetailAttachmentsViewModel: return SUHorizontalAttachmentsSectionController()

        case is String:     return SUDetailDescriptionSectionController()
        default:            return SUDetailShotSectionController()
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
            
        }
    }
    
    
}


extension DetailViewController: ListOfShotsFilterProtocol {
    
    func presentFilterController() {
        
       
    }
    
    func scrollToTop() {
        
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionViewScrollPosition.top, animated: true)
    }
}



// MARK:  Configurations

extension DetailViewController {
    
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



extension DetailViewController: EmptyViewProtocol {
    
    func load() {
        
        stateController = .FirstLoading
    }
}


extension DetailViewController: ShotSectionControllerDelegate {
    
    func shotWantsOpen(_ shot: SUViewModel) {
  
        guard let shot = shot as? ShotsDS else {
            return
        }
    }
    
    func reboundsWantsOpen(_ shot: SUViewModel) {
        print(shot)
        
        guard let shot = shot as? ShotsDS else {
            return
        }
    
    }
}


extension DetailViewController: DetailSectionControllerDelegate {
    
    func shotWantsOpen(_ shot: ShotsDS) {
        
    }
    
    func reboundsWantsOpen(_ shot: ShotsDS) {
        
    }
    
    func profileWantsOpen(_ user: UserDS) {
        presenter?.prepareProfile(with: user)
    }
    
    func teamWantsOpen(_ team: TeamDS) {
        
    }
    
    func attachmentWantsOpen(_ attachment: AttachmentDS) {
        
    }
}
