//
//  DBManager.swift
//  FilterRealmApp
//
//  Created by Maxim Lyashenko on 14.11.17.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import RealmSwift


class FilterDBManager {
    
    
     static let config = Realm.Configuration(
        // Get the URL to the bundled file
        fileURL: Bundle.main.url(forResource: "FilterData", withExtension: "realm"),
        // Open the file in read-only mode as application bundles are not writeable
        readOnly: false)

    
    
   
    
    
    private  var  database: Realm = try! Realm()//(configuration: config)
    
    init() {
    
    }
    
    private func copyDatabaseIfNeeded() {
        // Move database file from bundle to documents folder
        
        let fileManager = FileManager.default
        
        let documentsUrl = fileManager.urls(for: .documentDirectory,
                                            in: .userDomainMask)
        
        guard documentsUrl.count != 0 else {
            return // Could not find documents URL
        }
        
        let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("FilterData.realm")
        
        if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
            print("DB does not exist in documents folder")
            
            let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("FilterData.realm")
            
            do {
                try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
            } catch let error as NSError {
                print("Couldn't copy file to final location! Error:\(error.description)")
            }
            
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
    }
  
    
}



// MARK: - get values


extension FilterDBManager {
 
    func getTypes() -> Results<RFType> {
        let results: Results<RFType> =   database.objects(RFType.self)
        return results
    }

    func getItems() -> Results<RFItem> {
        let results: Results<RFItem> =   database.objects(RFItem.self)
        return results
    }
    
    func getFilters() -> Results<RFFilter> {
        let results: Results<RFFilter> =   database.objects(RFFilter.self)
        return results
    }
    

    func getItems(by type: RFType) -> Array<RFItem> {
        let results: Results<RFItem> = database.objects(RFItem.self).filter("type == %@", type).sorted(byKeyPath: "num")
        return Array(results)
    }
    
    func getItem(by type: RFType, and num: Int) -> RFItem {
        let results: Results<RFItem> = database.objects(RFItem.self).filter("type == %@ AND num == %@", type, num)
        
        guard let item = results.first else {
            return RFItem()
        }
        
        return item
    }
    
    func getFilter(by name: String) -> RFFilter? {
        let results: Results<RFFilter> = database.objects(RFFilter.self).filter("controller.name == %@", name)

        guard let filter = results.first else {
            return nil
        }
        
        return filter
    }
    
    
    func getControllers() -> Array<RFController> {
        let results: Results<RFController> = database.objects(RFController.self).sorted(byKeyPath: "num")
        return Array(results)
    }
    
    func getController(by name: String) -> RFController? {
        let results: Results<RFController> = database.objects(RFController.self).filter("name == %@", name)
        
        guard let filter = results.first else {
            return nil
        }
        
        return filter
    }
    
    
    //
    func getFilterDictionary(by name: String) -> [String : Any] {
        let results: Results<RFFilter> = database.objects(RFFilter.self).filter("controller.name == %@", name)
        
        guard let filter = results.first else {
            return [:]
        }
        
        var params: [String: Any] = [String : Any]()
        for item in filter.filter {
            
            guard let value = item.type?.value else {
                return [:]
            }
            
            params[value] = item.value
        }
        
        
        return params
    }
    
    
}


// MARK: - update


extension FilterDBManager {
    
    func updateFilter(with newItem: RFFilter, custom: [RFItem], completionHandler:@escaping (Bool) -> ()) {
        
        try! database.write {
                newItem.customFilter.removeAll()
                newItem.customFilter.append(objectsIn: custom)
            
                database.add(newItem, update: true)
            
            completionHandler(true)
            print("Updated newItem object")
        }
    }
    
    func removeCustomFilter(with newItem: RFFilter) {
        
        try! database.write {
            newItem.customFilter.removeAll()
            database.add(newItem, update: true)
            print("Updated newItem object")
        }
    }
}



extension FilterDBManager {
    
    func storeShotsDS(shots: [ShotsDS]) {
        try! database.write {
            for (item) in shots {
                
                let shot = ShotsRealm()
                shot.setup(shot: item)
                
                database.add(shot, update: true)
            }
            
            print("Added new object list")
        }
    }
}




// MARK: ---


extension FilterDBManager {
    
    func setupDefault() {
        
        setup()
        makePopular()
    }
    

    /////////
    
    func setup() {
        
        let list = RFType()
        list.name = "List"
        list.value = "list"
        
        let timeFrame = RFType()
        timeFrame.name = "TimeFrame"
        timeFrame.value = "timeframe"
        
        let sort = RFType()
        sort.name = "Sort"
        sort.value = "sort"
        
        
        try! database.write {
            database.add([list,timeFrame, sort])
            
            print("Added new object type")
        }
        
        // list
        
        let arrList = [("Shots","", 0),
                    ("Animated","animated", 1),
                    ("Attachments","attachments",2),
                    ("Debuts","debuts",3),
                    ("Playoffs","playoffs",4),
                    ("Rebounds","rebounds",5),
                    ("Teams","teams",6)]
        
        try! database.write {
            for (item) in arrList {
                let b = RFItem()
                b.name = item.0
                b.value = item.1
                b.num = item.2
                b.type = list
                
                database.add(b)
            }
            
            print("Added new object list")
        }
        
        
        // tf
        let arrTimeFrame = [("Now","now", 0),
                            ("Week","week",1),
                            ("Month","month", 2),
                            ("Year","year", 3),
                            ("Ever","ever", 4)]
        
        try! database.write {
            for (item) in arrTimeFrame {
                let b = RFItem()
                b.name = item.0
                b.value = item.1
                b.num = item.2
                b.type = timeFrame
                
                database.add(b)
            }
            
            print("Added new object TimeFrame")
        }
        
        // sort
        
        let arrSort = [("Popularity","popularity", 0),
                   ("Views","views", 1),
                   ("Recent","recent", 2),
                   ("Comments","comments",3)]
        
        try! database.write {
            for (item) in arrSort {
                let b = RFItem()
                b.name = item.0
                b.value = item.1
                b.num = item.2
                b.type = sort
                
                database.add(b)
            }
            
            print("Added new object sort")
        }
        
    }
    
    //
    
    func makePopular() {
        let home: RFController = RFController()
        home.name = "home"
        
        try! database.write {
            
                
                database.add(home)
            
            print("Added new object sort")
        }
        
        
        let popular = RFFilter()
        popular.controller = home
        try! database.write {
            
            
            database.add(popular)
            
            print("Added new object sort")
        }
    }
    
}
