//
//  AppDelegateExtension.swift
//  ShotsUpApp
//
//  Created by Maxim Lyashenko on 24.11.2017.
//  Copyright © 2017 Maxim Lyashenko. All rights reserved.
//

import UIKit

import RealmSwift


extension AppDelegate {
    
    //MARK: create
    func baseConfigure() {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        guard let window = self.window else {
            return
        }
    
        let rw = RootWireframe(window: window)
        rw.presentRoootViewController()
        
        
        self.window?.makeKeyAndVisible()
    }
    
    
    func copyDIN() {
        
        let bundlePath = Bundle.main.path(forResource: "FilterData", ofType: "realm")
        let destPath = Realm.Configuration.defaultConfiguration.fileURL?.path
        
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: destPath!) {
            print(fileManager.fileExists(atPath: destPath!))
        } else {
            do {
                try fileManager.copyItem(atPath: bundlePath!, toPath: destPath!)
            } catch {
                print("\n",error)
            }
        }
    }
    
    
     func copyDatabaseIfNeeded() {
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
