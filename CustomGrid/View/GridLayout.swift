//
//  GridCell.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 26/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import UIKit

/**
 This is 🀡layout this class is responsible for the create the desire layout of the CollectionView
 */

class GridLayout: UICollectionViewLayout {
    
    //MARK: veriables
    
    /// This is **cellPadding** we will use this for providing the padding to the Cell of ColletionView from all the sides
    fileprivate var cellPadding: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return insets.left
    }
    
    /**
     This is **cache** we will use this storing the array of
     ````
     UICollectionViewLayoutAttributes
     ````
     Which will use for creating layout of the cells for collectionView
     */
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    
    /**
     This is **contentHeight** we will use for providing height of the content of collectionView
     */
    fileprivate var contentHeight: CGFloat = 0
    
    /**
     This is **contentWidth** we will use for providing width of the content of collectionView
     */
    fileprivate var contentWidth: CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    //MARK: redefining Methods
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        
        guard let collectionViewTemp = collectionView, collectionViewTemp.numberOfItems(inSection: 0) != cache.count else {
            return
        }
        
        cache.removeAll()
        
        guard cache.isEmpty == true  else {
            return
        }
        
        var yOffset: CGFloat = 0
        
        for item in 0 ..< collectionViewTemp.numberOfItems(inSection: 0) {
            
            let indexPath = IndexPath(item: item, section: 0)
            
            let cellRect = self.collectionView(collectionViewTemp, sizeForPhotoAtIndexPath: indexPath)
            let height = cellRect.size.height
            let frame = CGRect(x: cellRect.origin.x, y: ((item == 0) ? cellRect.origin.y : yOffset), width: cellRect.size.width, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            if item == 1 {
                yOffset = yOffset + height
            }
            
            if ((item + 1) % 3) == 0 && item > 1 {
                yOffset = yOffset + height
            }
            
            contentHeight = max(contentHeight, frame.maxY)
        }
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    //MARK: Private Methods
    
    /**
     This method will return the rect for the given IndexPath for given UIColletionView.
     
     - Remark:
     This is method is required and responsible for genrate the desire layout of the collectionView
     
     - Parameter collectionView: This is collectionview which will use for calculating the rectangle
     - Parameter sizeForPhotoAtIndexPath: This is the current indexpath for which we need to calculate the rect
     - Returns: calculated CGRect for indexpath which will use in darwing the cell for given indexPath
     */
    fileprivate func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGRect {
        
        let width = ((self.collectionView?.frame.size.width)! - ((self.collectionView?.contentInset.left)! + (self.collectionView?.contentInset.right)!)) / 3
        
        if indexPath.row == 0 {
            return CGRect(x: 0, y: 0, width: (width * 2), height: (width * 2))
        } else if ((indexPath.row == 1) || (indexPath.row == 2)) {
            return CGRect(x: (width * 2), y: ((indexPath.row == 2) ? width : 0), width: width, height: width)
        } else {
            
            var drawFromRight = false
            let itemIndex = indexPath.row
            let rowValue: Int = itemIndex / 3
            if rowValue % 2 == 0 {
                drawFromRight = true
            }
            
            let columnValue: Int = (itemIndex) % 3
            
            switch columnValue {
            case 0:
                return CGRect(x: (drawFromRight ? CGFloat((indexPath.row % 3)) * width : (2 * width)), y: 0, width: width, height: width)
                
            case 1:
                return CGRect(x: CGFloat((indexPath.row % 3)) * width, y: 0, width: width, height: width)
                
            case 2:
                return CGRect(x: (drawFromRight ? CGFloat((indexPath.row % 3)) * width : 0), y: 0, width: width, height: width)
                
            default:
                return CGRect.zero
            }
        }
    }
    
    //MARK: Public Methods
    
    /**
     In this method we are deleting Cell with given index, and rearrange the
     ````
     cache of [UICollectionViewLayoutAttributes]
     ````
     
     - Remark:
     This will cuase the maintain the desire layout of the UICollectionView
     
     - Parameter index: This is an Int value, this is row/item of the IndexPath value which we use for getting cell form CollectionVeiw
     */
    public func deleteCacheItems(withIndex index: Int) {
        
        for attributes in cache {
            if (attributes.indexPath.item >= index) && ((cache.count) <= (attributes.indexPath.item + 1)){
                let indexPath = IndexPath(item: (attributes.indexPath.item + 1), section: attributes.indexPath.section)
                attributes.indexPath = indexPath
            }
        }
        
        cache.removeLast()
        
        if let lastItemFrame = cache.last?.frame {
            contentHeight = lastItemFrame.maxY
        }
    }
    
}


