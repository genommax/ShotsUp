//
//  DetailRouter.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 07.12.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit


class DetailRouter {
 
    var presenter: DetailPresenter?
    
    
    func presentProfile(with view: SUViewController, profile: SUViewController) {
        
        view.navigationController?.pushViewController(profile, animated: true)
    }
    
    func presentRebound(with view: SUViewController, rebound: SUViewController) {
        
        view.navigationController?.pushViewController(rebound, animated: true)
    }
    
    func presentTeam(with view: SUViewController, team: SUViewController) {
        
        view.navigationController?.pushViewController(team, animated: true)
    }
    
}
