//
//  StringExtension_URL.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 01/02/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /**
     This method will return the Bool which tell that the pattern is match with self value.
     
     - Parameter pattern: this is String value which is the pattern of the NSRegularExpression for which we need to check the string value.s
     - Returns: its return bool Value
     */
    private func matches(pattern: String) -> Bool {
        let regex = try! NSRegularExpression(
            pattern: pattern,
            options: [.caseInsensitive])
        return regex.firstMatch(
            in: self,
            options: [],
            range: NSRange(location: 0, length: utf16.count)) != nil
    }
    
    
    /**
     This method will return the Bool which tell that the **self(string)* is valid url or not for image URL only
     
     - Returns: its return bool Value
     */
    func isValidURLForImage() -> Bool {
        guard let url = URL(string: self) else { return false }
        if !UIApplication.shared.canOpenURL(url) {
            return false
        }
        
        let urlPattern = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+(.png|.jpeg|.jpg)"
        return self.matches(pattern: urlPattern)
    }
}
