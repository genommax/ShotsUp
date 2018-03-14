//
//  SUViewController.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 27.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

class SUViewController: UIViewController {

    var topOffset: CGFloat {
        
        if isIphoneX {
            return 40
        }
        return 20
    }
    
    var isIphoneX: Bool {
        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            return true
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
