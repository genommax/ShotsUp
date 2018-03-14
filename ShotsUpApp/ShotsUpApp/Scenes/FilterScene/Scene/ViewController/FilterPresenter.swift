//
//  FilterPresenter.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


class FilterPresenter {
    var view: FilterViewController?
    var interactor: FilterInteractor?
    var router: FilterRouter?
    
    
    // MARK: interactor
    
    func requestFilterName() -> String {
        guard let name = interactor?.getFilterName() else {
            return ""
        }
        return name 
    }
    
    func requestComponents() {
        interactor?.getComponents()
    }
    
    func applyFilter(customFilter: VFFilter) {
        interactor?.setCustomFilter(customFilter: customFilter)
    }
    
    func dismiss(animated: Bool, needUpdate: Bool) {
        router?.dismissFilterController(view: view, animated: animated, needUpdate: needUpdate)
    }
    
    // MARK: view
    
    func requestedComponents(components: VFComponents, and filter: VFFilter, customFilter: VFFilter ,isCustom: Bool) {
        view?.updatedCompanents(components: components, and: filter, customFilter: customFilter, custom: isCustom)
    }
    
    func compleatedUpdate() {
        router?.dismissFilterController(view: view, animated: true, needUpdate: true)
    }
}
