//
//  RootWireframe.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 24.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class RootWireframe {
    
    private let window: UIWindow
    private let factory: RootViewControllersFactory
    
    required init(window: UIWindow) {
        self.window = window
        self.factory = RootViewControllersFactory()
        
    }
    
    func presentRoootViewController() {
        
        let rootVC = factory.createRootTabViewController()
        let navVC = SUNavigationController.init(rootViewController: rootVC)
    
        navVC.navigationBar.isHidden = true
        
       window.rootViewController = navVC
    }
    
    
}
