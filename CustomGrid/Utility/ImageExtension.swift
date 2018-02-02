//
//  ImageExtension.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 01/02/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    /// Returns a rect that can be applied to the image view to clip to the image, assuming a scale aspect fit content mode.
    var contentClippingRect: CGRect {
        guard let image = image, contentMode == .scaleAspectFit else { return bounds }
        
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        guard imageWidth > 0 && imageHeight > 0 else { return bounds }
        
        let scale: CGFloat
        if imageWidth > imageHeight {
            scale = bounds.size.width / imageWidth
        } else {
            scale = bounds.size.height / imageHeight
        }
        
        let clippingSize = CGSize(width: imageWidth * scale, height: imageHeight * scale)
        let x = (bounds.size.width - clippingSize.width) / 2.0
        let y = (bounds.size.height - clippingSize.height) / 2.0
        
        return CGRect(origin: CGPoint(x: x, y: y), size: clippingSize)
    }
    
    /**
     Generates and returns a thumbnail for the image using scale aspect fill.
     
     - Parameter thumbnailSize: this is the CGSize value with this size
     - Returns: calculated CGRect for indexpath which will use in darwing the cell for given indexPath
     */
    
    func generateThumbnail(for thumbnailSize: CGSize) -> UIImage? {
        
        guard let image = self.image else { return nil }
        
        
        let imageSize = image.size
        
        let widthRatio = thumbnailSize.width / imageSize.width
        let heightRatio = thumbnailSize.height / imageSize.height
        let scaleFactor = widthRatio > heightRatio ? widthRatio : heightRatio
        
        if #available(iOS 10.0, *) {
            
            let renderer = UIGraphicsImageRenderer(size: thumbnailSize)
            let thumbnail = renderer.image { _ in
                let size = CGSize(width: imageSize.width * scaleFactor, height: imageSize.height * scaleFactor)
                let x = (thumbnailSize.width - size.width) / 2.0
                let y = (thumbnailSize.height - size.height) / 2.0
                image.draw(in: CGRect(origin: CGPoint(x: x, y: y), size: size))
            }
            return thumbnail
            
        } else {
            
            let size = CGSize(width: imageSize.width * scaleFactor, height: imageSize.height * scaleFactor)
            
            let ctx = CGContext(
                data: nil,
                width: Int(size.width),
                height: Int(size.height),
                bitsPerComponent: image.cgImage!.bitsPerComponent,
                bytesPerRow: 0,
                space: image.cgImage!.colorSpace!,
                bitmapInfo: UInt32(image.cgImage!.bitmapInfo.rawValue)
            )
            
            ctx?.draw(image.cgImage!, in: CGRect(x: (thumbnailSize.width - size.width) / 2.0, y: (thumbnailSize.height - size.height) / 2.0, width: (imageSize.width * scaleFactor), height: (imageSize.width * scaleFactor)))
            let cgimg = ctx!.makeImage()
            
            let img = UIImage(cgImage: cgimg!)
            
            return img;
        }
        
    }
}
