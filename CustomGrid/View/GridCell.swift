//
//  GridCell.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 26/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import UIKit

/// This is the custom class of the UICollectionViewCell which we are using the Grid View
class GridCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GridCellID"

    var tappedOnDeleteBTN: ((GridCell) -> Void)?
    var tappedOnAddBTN: ((GridCell) -> Void)?

    ///ImageView which is show the image in the Cell
    @IBOutlet weak var gridImageView: AsyncImageView!
    ///The button which is perform delete operation on the Cell
    @IBOutlet var btnDelete: UIButton!
    ///The button which is perform add operation on the cell for adding new cell in the CollectionView/GridView
    @IBOutlet var addBTN: UIControl!
    
    /**
     This method will set the value to the UIElement of the Cell or configure the cell according to the value given Data
     
     - Parameter itemData: This is GridItem which will having the data/value for configure the Cell
     - Returns: nil😁
     */
    func configure(with itemData: GridItem) {
        if itemData.movable {
            gridImageView.loadAsyncFrom(url: itemData.imageURL!, placeholder: UIImage(named: "imageplaceholder"))
            gridImageView.layer.borderColor = UIColor.gray.cgColor
            gridImageView.layer.borderWidth = 1
        }
        
        btnDelete.isHidden = !itemData.movable
        gridImageView.isHidden = !itemData.movable
        addBTN.isHidden = itemData.movable
    }
    
    @IBAction func actionOnDeleteBTN(_ sender: UIButton) {
        tappedOnDeleteBTN?(self)
    }
    
    @IBAction func actionOnAddBTN(_ sender: UIControl) {
        tappedOnAddBTN?(self)
    }


}
