
//
//  GridData.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 26/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation
import UIKit

class GridData: NSObject {

    private var items = [GridItem]()
    
    func createVAO(dictionaryData: [String: AnyObject]) {
        self.items.removeAll()
        guard let listItems = dictionaryData["items"] as? [[String: AnyObject]] else {
            return
        }
        
        for data in listItems {
            self.items.append(GridItem(dictionary: data))
        }
    }
    
    public func getItems() -> [GridItem] {
        return items
    }

    public func setItems(values: [GridItem]) {
        items = values
    }

    /**
     This method will delete Item for the given index from the Array Of items
     */
    func deleteItem(with index: Int) {
        items.remove(at: index)
    }
    
    func addItem(itemOfData: GridItem) {
        items.append(itemOfData)
    }
    
    func moveItem(from indexSource: Int, to indexDestination: Int) {
        let backUpData = items[indexSource]
        items.remove(at: indexSource)
        items.insert(backUpData, at: indexDestination)
    }

}

class GridItem: NSObject, NSCoding {
    
    let uuidKey = "uuid"
    let imageURLKey = "imageUrlString"
    
    var identifier = UUID()
    let imageURL: String?
    let uuidValue: String?
    var movable: Bool = true

    init(imageURL: String?) {
        self.imageURL = imageURL
        self.uuidValue = identifier.uuidString
    }

    init(dictionary:  Dictionary<String, Any> ) {
        self.imageURL = dictionary["imageUrlString"] as? String
        self.uuidValue = dictionary["uuid"] as? String
        self.identifier = UUID(uuidString: self.uuidValue!)!
    }

    required init?(coder aDecoder: NSCoder) {
        self.imageURL = aDecoder.decodeObject(forKey: imageURLKey) as? String;
        self.uuidValue = aDecoder.decodeObject(forKey: uuidKey) as? String;
        self.identifier = UUID(uuidString: self.uuidValue!)!
        self.movable = true
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uuidValue, forKey: uuidKey)
        aCoder.encode(self.imageURL, forKey: imageURLKey)
    }

}


//sample for creating clouser
/*
 func doSomething(number:Int,onSuccess closure:(Int)->Void) {
 closure(number * number * number)
 }
 doSomething(number: 100) { (numberCube) in
 print(numberCube) // prints  1000000
 }
*/


