//
//  ConnectionManager.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 01/02/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation



class Connection: NSObject {
    
    override init() {
        super.init()
    }
    
    func loadData(withSample loadSample: Bool, onSuccess success: @escaping (_ JSON: [String: AnyObject]) -> Void, onFailure failure: @escaping (_ error: Error?, _ errorDescription: String?) -> Void) {
        
        if loadSample {
            loadSampleData(onSuccess: success, onFailure: failure)
        } else {
            loadRemoteData(onSuccess: success, onFailure: failure)
        }
        
    }
    
    private func loadSampleData(onSuccess success: @escaping (_ JSON: [String: AnyObject]) -> Void, onFailure failure: @escaping (_ error: Error?, _ errorDescription: String?) -> Void) {
        
        guard let url = Bundle.main.url(forResource: "sampleData", withExtension: "json") else {
            failure(nil, "URL is empty")
            return
        }
        
        do {
            let data =  try Data(contentsOf: url)// Data(contentsOf: url)
            self.dataNeedToCheck(data, onSuccess: success, onFailure: failure)
        } catch {
            // Handle Error
            failure(nil, "Data is empty")
        }
        
    }
    
    
    private func loadRemoteData(onSuccess success: @escaping (_ JSON: [String: AnyObject]) -> Void, onFailure failure: @escaping (_ error: Error?, _ errorDescription: String?) -> Void) {
        
        guard let url = URL(string: "") else { return }
        
        let session = URLSession.shared
        
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                failure(error, nil)
            }
            
            guard data != nil else {
                failure(nil, "Error: while parsing JSON or decode data is not JSON")
                return
            }
            
            self.dataNeedToCheck(data!, onSuccess: success, onFailure: failure)
            
            }.resume()
        
    }
    
    func dataNeedToCheck(_ data : Data, onSuccess success: @escaping (_ JSON: [String: AnyObject]) -> Void, onFailure failure: @escaping (_ error: Error?, _ errorDescription: String?) -> Void) {
        
        do {
            let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            if let dictionary = object as? [String: AnyObject] {
                success(dictionary)
            }
        } catch {
            // Handle Error
            failure(nil, "Error: while parsing JSON or decode data is not JSON")
        }
    }
    
    
}
