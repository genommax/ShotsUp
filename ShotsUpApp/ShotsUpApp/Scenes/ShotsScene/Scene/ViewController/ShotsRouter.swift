//
//  ShotsRouter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 03.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class ShotsRouter {
    
    var presenter: ShotsPresenter?
    
    
    func presentRebounds(with view: SUViewController, rebound: SUViewController) {
        
        view.navigationController?.pushViewController(rebound, animated: true)
    }
    
    
    func presentDetail(with view: SUViewController, detail: SUViewController) {
        
        view.navigationController?.pushViewController(detail, animated: true)
    }
}
