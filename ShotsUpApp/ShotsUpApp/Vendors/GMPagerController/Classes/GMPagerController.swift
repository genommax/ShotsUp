//
//  PTSController.swift
//  PTSController
//
//  Created by Maxim Lyashenko on 09.10.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


// MARK: Protocols

public protocol GMPageInfoProvider {
    
    var pageInfo: GMPageInfo {get}
    func tabInfo(for pagerTabScrollController: GMPagerController) -> GMPageInfo
}

public protocol GMPagerDataSource {
    
    func pages(for pagerController: GMPagerController) -> [UIViewController]
    func configure(segmentView: GMSegmentView, pagerController: GMPagerController)
}

public protocol GMPagerDelegate {
    func didSelectPage(page: GMPageInfoProvider, index: Int, tapType: GMSegmentAction)
}


open class GMPagerController: UIViewController, GMPagerDataSource, UIPageViewControllerDataSource {
    
    open var delegate: GMPagerDelegate?
    
    private var pageController: UIPageViewController!
    private var controllers = [UIViewController]()
    
    open var segmentView: GMSegmentView!
    private var margin: CGFloat = 0.0
    open var segmentHeight: CGFloat = 50.0
    
    open var infinitScroll: Bool = false
    
    private var currentIndex: Int = 0
    open var selectedIndex: Int {
        get {
            return currentIndex
        }
    }
    
    
    // MARK: LIFECYCLE
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        //pageController.delegate = self
        
        // setup vc
        setupPageController()
        setupSegmentView()
        
        // configure segment view
        configure(segmentView: segmentView, pagerController: self)
        
        // add pages
        let listOfPages = pages(for: self)
        addPages(pages: listOfPages)
        
        // select first
        selectPage(with: currentIndex)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    // MARK: public methods
    
    open func selectPage(with index: Int) {
        guard index >= 0, index < controllers.count else {
            return
        }
        
        pageController.setViewControllers([controllers[index]], direction: .forward, animated: false)
        segmentView.selectedSegmentIndex = index
    }
    
    open func pages(for pagerController: GMPagerController) -> [UIViewController] {
        
        return []
    }
    
    open func configure(segmentView: GMSegmentView, pagerController: GMPagerController) {
        let appearance = GMSegmentAppearance()
        appearance.segmentOnSelectionColour = .black
        appearance.segmentOffSelectionColour = .black
        appearance.contentVerticalMargin = 20
        
        self.segmentView.segmentAppearance = appearance
        self.segmentView.backgroundColor = .black
        
        
        self.segmentView.layer.cornerRadius = 0.0
        self.segmentView.layer.borderColor = UIColor.black.cgColor
        self.segmentView.layer.borderWidth = 1.0
    }
    
    
    public func reloadPages() {
        controllers.removeAll()
        segmentView.removeAllSegments()
        
        // add pages
        let listOfPages = pages(for: self)
        addPages(pages: listOfPages)
        
        // select first
        selectPage(with: 0)
    }
    
    
    // MARK: private
    
    private func addPages(pages: [UIViewController]) {
        
        for i in pages {
            controllers.append(i)
            guard let item = i as? GMPageInfoProvider else {
                return
            }
            segmentView.addSegment(highlightedImage: item.pageInfo.highlightedImage, normalImage: item.pageInfo.normalImage)
        }
    }
    
    private func setupSegmentView() {
        
        let defaultViewHeight: CGFloat = segmentHeight
        //let yVal = self.view.frame.size.height - defaultViewHeight
        let yVal = UIScreen.main.bounds.height - defaultViewHeight

        
        
        let segmentFrame = CGRect(x: self.margin, y: yVal, width: UIScreen.main.bounds.width - self.margin*2, height: defaultViewHeight)
        self.segmentView = GMSegmentView(frame: segmentFrame)
        
        self.view.addSubview(self.segmentView)
        
        self.segmentView.sendAction = { [weak self] segment, tapType in
            guard let aSelf = self else { return }
            
            let direction: UIPageViewControllerNavigationDirection = aSelf.currentIndex > segment.index ? .reverse : .forward
            let currentPage = aSelf.controllers[segment.index]
            aSelf.pageController.setViewControllers([currentPage], direction: direction, animated: true)
            
            guard let pageInfo = currentPage as? GMPageInfoProvider else {
                return
            }
            
            aSelf.currentIndex = segment.index
            
            aSelf.delegate?.didSelectPage(page: pageInfo, index: segment.index, tapType: tapType)
        }
    }
    
    private func setupPageController() {
        addChildViewController(pageController)
        view.addSubview(pageController.view)
        
        setupLayout()
    }
    
    
    // MARK: UIPageViewControllerDataSource
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let  previousIndex = swipeToLeft(viewController: viewController) else {
            return nil
        }
        
        return controllers[previousIndex]
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        
        guard let  nextIndex = swipeToRight(viewController: viewController) else {
            return nil
        }
        
        return controllers[nextIndex]
    }
    
    
    // MARK:  UIPageViewControllerDelegate

    
    // MARK: - Navigation
    
    func swipeToLeft(viewController: UIViewController) -> Int? {
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        self.currentIndex = viewControllerIndex
        segmentView.selectedSegmentIndex = self.currentIndex
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return infinitScroll ? controllers.count - 1 : nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        
        return previousIndex
    }
    
    func swipeToRight(viewController: UIViewController) -> Int? {
        guard let viewControllerIndex = controllers.index(of: viewController) else {
            return nil
        }
        
        self.currentIndex = viewControllerIndex
        segmentView.selectedSegmentIndex = self.currentIndex
        
        
        let nextIndex = viewControllerIndex + 1
        
        
        guard nextIndex < controllers.count else {
            return infinitScroll ? 0 : nil
        }
        
        guard controllers.count > nextIndex else {
            return nil
        }
        
        return nextIndex
    }
    
    
    
    // MARK: Layout
    
    func setupLayout() {
//        let views = ["pageController": pageController.view] as [String: AnyObject]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
        
         //pageController.view.backgroundColor = .red
        
        var rect = self.view.bounds
        rect.size.height = rect.size.height - segmentHeight
        pageController.view.frame = rect
        
    }
}
