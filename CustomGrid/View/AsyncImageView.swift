//
//  AsyncImageView.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 30/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation
import UIKit



//MARK: - 'asyncImagesCashArray' is a global varible cashed UIImage
var asyncImagesCashArray = NSCache<NSString, UIImage>()

/**
 This is class is use for AsyncImage loading images from given URL and showign the place holder image until the image is not download from the URL
 */

@IBDesignable

class AsyncImageView: UIImageView {
    
    //MARK: - Variables
    
    @IBInspectable public var placeHolderImage: UIImage?
    @IBInspectable public var indicatorWidth: CGFloat = 30
    @IBInspectable public var indicatorBGColor: UIColor = UIColor.darkGray
    /**
     This will accept only
     0 - for whiteLarge
     1 - for white
     2 - for  gray
     
     more than 2 it will treated as 0
     */
    @IBInspectable public var indicatorStyle: Int = 0

    ///This is the URL of image which we need to download.
    private var currentURL: NSString?
    private var loadingView: UIActivityIndicatorView!
    
    
    func createLoadingView() {
        
        if loadingView == nil {
            
            var style: UIActivityIndicatorViewStyle = .whiteLarge
            if let styleValue: UIActivityIndicatorViewStyle = UIActivityIndicatorViewStyle(rawValue: self.indicatorStyle), self.indicatorStyle < 3 {
                style = styleValue
            }

            loadingView = UIActivityIndicatorView(activityIndicatorStyle: style)
            loadingView.frame = CGRect(x: 0, y: 0, width: self.indicatorWidth, height: self.indicatorWidth)
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.widthAnchor.constraint(equalToConstant: loadingView.frame.size.width).isActive = true
            loadingView.heightAnchor.constraint(equalToConstant: loadingView.frame.size.height).isActive = true
            loadingView.isHidden = false
            loadingView.backgroundColor = indicatorBGColor
            self.addSubview(loadingView)
            
            loadingView.translatesAutoresizingMaskIntoConstraints = false
            loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//
        }
    }
    
    
    //MARK: - Public Methods
    
    /**
     This method is use for start image downloading for the given URL value and it pass the placeholder image too if we did set the IBInspectable for **placeHolderImage** in the **Attributes Inspector**
     
     - Remark:
     
     - Parameter url: This is the String value, which will use for the url Value from where we need to download the image
     - Returns: nil 😁
     */
    public func loadAsyncFrom(url: String) {
        self.loadAsyncFrom(url: url, placeholder: self.placeHolderImage)
    }
    
    /**
     This method is use for start image downloading for the given ULR value and if we provide the placeholder image then it will show that place holder image until the image will not download from the given URL.
     
     - Remark:
     
     - Parameter url: This is the String value, which will use for the url Value from where we need to download the image
     - Parameter placeholder: This is UIImage value, which will use in the UIImageView as image while Image is downloading from the URL.
     - Returns: nil 😁
     */
    public func loadAsyncFrom(url: String, placeholder: UIImage?) {

        let imageURL = url as NSString
        if let cashedImage = asyncImagesCashArray.object(forKey: imageURL) {
            image = cashedImage
            return
        }
        image = placeholder
        currentURL = imageURL
        guard let requestURL = URL(string: url) else { image = placeholder; return }
        
        self.createLoadingView()
        self.loadingView.startAnimating()
        
        URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            DispatchQueue.main.async { [weak self] in
                
                self?.loadingView?.stopAnimating()
                guard (error == nil) else {
                    self?.image = placeholder
                    return
                }
                
                guard let imageData = data  else {
                    self?.image = placeholder
                    return
                }
                
                if self?.currentURL == imageURL {
                    guard let imageToPresent = UIImage(data: imageData) else {
                        self?.image = placeholder
                        return
                    }
                    
                    asyncImagesCashArray.setObject(imageToPresent, forKey: imageURL)
                    self?.image = imageToPresent
                }
            }
            }.resume()
    }
    
    
    
}
