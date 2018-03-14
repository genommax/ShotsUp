//
//  RootTabViewController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 25.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

class RootTabViewController: GMPagerController, GMPagerDelegate {
    
    let controllers: [UIViewController]
    
    var isIphoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        return false
    }
    
    required init(with controllers: [UIViewController]) {
        
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.segmentHeight = isIphoneX ? 64 : 48

        super.viewDidLoad()
        

        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override  func configure(segmentView: GMSegmentView, pagerController: GMPagerController) {
        let appearance = GMSegmentAppearance()
        appearance.segmentOnSelectionColour = .black
        appearance.segmentOffSelectionColour = .black
        appearance.contentVerticalMargin = isIphoneX ? 10 : 5
        appearance.contentBottomMargin = isIphoneX ? 5 : 0
        
        self.segmentView.segmentAppearance = appearance
        self.segmentView.backgroundColor = .black
        
        self.segmentView.layer.cornerRadius = 0.0
        self.segmentView.layer.borderColor = UIColor.black.cgColor
        self.segmentView.layer.borderWidth = 1.0
        
        self.segmentView.layoutSubviews()
    }
    
    
    override func pages(for pagerController: GMPagerController) -> [UIViewController] {
 
        return controllers
    }
    
}

// MARK: Delegate

extension RootTabViewController {
    
    func didSelectPage(page: GMPageInfoProvider, index: Int, tapType: GMSegmentAction) {
        print("did select")
        
        print("\(index) - \(tapType.title)")
        
        guard let vc = controllers[index] as? ListOfShotsFilterProtocol else {
            return
        }
        
        switch tapType {
        case .longTapItem:
            
            
            vc.presentFilterController()
            
        case .secondTapItem:
            vc.scrollToTop()
            
        case .selectItem:
            print("")
            
        }
       
    }
}


// MARK: DataSource

extension RootTabViewController {
    
    private func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    internal func randomColor() -> UIColor {
        return UIColor(red: randomCGFloat(), green: randomCGFloat(), blue: randomCGFloat(), alpha: 1)
    }
}
