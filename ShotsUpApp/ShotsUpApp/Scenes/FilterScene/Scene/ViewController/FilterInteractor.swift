//
//  FilterInteractor.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 17.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import Foundation


class FilterInteractor {
    
    private let dbManager: FilterDBManager
    private let filterName: String
    var presenter: FilterPresenter?
    
    init(with dbManager: FilterDBManager, filterName name: String) {
        self.dbManager = dbManager
        self.filterName = name
    }
    
    // MARk: -
    
    func getFilterName() -> String {
        return filterName
    }
    
    
    // MARK: - Interact with db
    
    func getComponents() {
        guard let filter = dbManager.getFilter(by: filterName) else {
            return
        }
        
        var components: [[String]] = []
        
        let defaultFilter = filter.defaultFilter
        
        for item in defaultFilter {
            
            guard let type = item.type else {
                return
            }
            
            let component: Array<RFItem> = dbManager.getItems(by: type)
            components.append(convertRFItem(components: component))
        }
        
        let componentData = VFComponents(with: components)
        let defaultFilterData = VFFilter(with: convertRFFilterItems(filterItems: Array(defaultFilter)))
        let customFilterData = VFFilter(with: convertRFFilterItems(filterItems: Array(filter.customFilter)))

        
        presenter?.requestedComponents(components: componentData, and: defaultFilterData, customFilter: customFilterData, isCustom: filter.isCustom)
    }
    
    
    // MARK: - presenter
    
    func setCustomFilter(customFilter: VFFilter) {
        guard let filter = dbManager.getFilter(by: filterName) else {
            return
        }
        
        // setup custom
        var components: [RFItem] = []
        
        let items = filter.filter
        
        for (index, item) in items.enumerated() {
            
            guard let type = item.type else {
                return
            }
            
            let component: RFItem = dbManager.getItem(by: type, and: customFilter.selectedIndex(by: index))
            components.append(component)
        }
        
        dbManager.updateFilter(with: filter, custom: components) { [unowned sSelf = self] (sucess) in
            guard sucess == true else {
                return
            }
            
            sSelf.presenter?.compleatedUpdate()
        }
    }
}


// MARK: - Helper

extension FilterInteractor {
    func convertRFItem(components: Array<RFItem>) -> [String] {
        var items = [String]()
        
        for item in components {
            items.append(item.name)
        }
        
        return items
    }
    
    func convertRFFilterItems(filterItems: Array<RFItem>) -> [Int] {
        var items = [Int]()
        
        for item in filterItems {
            items.append(item.num)
        }
        
        return items
    }
}
