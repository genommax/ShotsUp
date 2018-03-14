//
//  FilterRouter.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation

protocol FilterViewDelegate {
    func filterView(_ filterView: FilterViewController, needUpdate: Bool)
}


class FilterRouter {
   
    private var delegate: FilterViewDelegate?
    
    var presenter: FilterPresenter?
    
    init(with delegate: FilterViewDelegate? = nil) {
        self.delegate = delegate
    }
    
    
    func dismissFilterController(view: FilterViewController?, animated: Bool, needUpdate: Bool) {
        view?.dismiss(animated: true) { [unowned aSelf = self] in
            
            guard let view = view else {
                return
            }
            
            aSelf.delegate?.filterView(view, needUpdate: needUpdate)
        }
    }
}
