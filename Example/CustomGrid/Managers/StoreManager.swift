//
//  StoreManager.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 01/02/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation


class StoreManager: NSObject {
    
    let gridArrayKey = "GRID_DATA_IN_USERDEFAULT"
    
    override init() {
        super.init()
    }
    
    func save(items: [GridItem]?){
        if let dataNeedToData = items {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: dataNeedToData)
            UserDefaults.standard.set(encodedData, forKey: gridArrayKey)
        } else {
            UserDefaults.standard.set(nil, forKey: gridArrayKey)
        }
    }
    
    func getGridItems() -> [GridItem]? {
        
        if let data = UserDefaults.standard.data(forKey: gridArrayKey),
            let listItems = NSKeyedUnarchiver.unarchiveObject(with: data) as? [GridItem] {
            return listItems
        } else {
            print("There is an issue")
            return nil
        }
    }
    
    
}
