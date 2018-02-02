//
//  ComponentManager.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 01/02/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation

class ComponentManager: NSObject {
    
    static let sharedInstance = ComponentManager()
    
    private var gridCreationData:GridData!
    private var storageManager: StoreManager!
    private var connection: Connection!
    
    override init() {
        super.init()
        
        storageManager = StoreManager()
        gridCreationData = GridData()
        connection = Connection()
    }
    
    func getGridData() -> GridData {
        return gridCreationData
    }
    
    public func getGridDataVAO(onSuccess success: @escaping (_ success: Bool) -> Void, onFailure failure: @escaping (_ error: Error?, _ errorDescription: String?) -> Void) {
        
        if let gridItems = ComponentManager.sharedInstance.storageManager.getGridItems() {
            if gridItems.count > 0 {
                ComponentManager.sharedInstance.gridCreationData.setItems(values: gridItems)
            }
            success(true)
        } else {
            
            connection.loadData(withSample: true, onSuccess: { (dataValues) in
                
                ComponentManager.sharedInstance.gridCreationData.createVAO(dictionaryData: dataValues)
                ComponentManager.sharedInstance.storageManager.save(items: self.gridCreationData.getItems())
                success(true)
                
            }) { (error, errorDescription) in
                failure(error, errorDescription)
            }
        }
    }
    
    
    /**
     This method will delete Item for the given index from the Array Of items
     */
    func deleteItem(with index: Int) {
        ComponentManager.sharedInstance.gridCreationData.deleteItem(with: index)
        ComponentManager.sharedInstance.storageManager.save(items: ComponentManager.sharedInstance.gridCreationData.getItems())
    }
    
    func addItem(itemOfData: GridItem) {
        ComponentManager.sharedInstance.gridCreationData.addItem(itemOfData: itemOfData)
        ComponentManager.sharedInstance.storageManager.save(items: ComponentManager.sharedInstance.gridCreationData.getItems())
    }
    
    func moveItem(from indexSource: Int, to indexDestination: Int) {
        ComponentManager.sharedInstance.gridCreationData.moveItem(from: indexSource, to: indexDestination)
        ComponentManager.sharedInstance.storageManager.save(items: ComponentManager.sharedInstance.gridCreationData.getItems())
    }
    
}
