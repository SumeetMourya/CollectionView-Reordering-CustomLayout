//
//  GridVC.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 29/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class GridVC: UICollectionViewController {

    var selectedCellItem: Int = 0
    var gridDataItems = GridData()
    var padding: CGFloat = 5

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        var items = [GridItem]()
        items.append(GridItem(image: UIImage(named: "01"), name: "value 1"))
        items.append(GridItem(image: UIImage(named: "02"), name: "value 2"))
        items.append(GridItem(image: UIImage(named: "03"), name: "value 3"))
        items.append(GridItem(image: UIImage(named: "04"), name: "value 4"))
        items.append(GridItem(image: UIImage(named: "05"), name: "value 5"))
        items.append(GridItem(image: UIImage(named: "06"), name: "value 6"))
        var addButton = GridItem(image: nil, name: "value 7")
        addButton.movable = false
        items.append(addButton)

        gridDataItems.items = items
        
        self.collectionView?.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        // Set the Layout delegate
        self.collectionView?.collectionViewLayout = GridLayout()
//        if let layout = self.collectionView?.collectionViewLayout as? GridLayout {
//            layout.delegate = self
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func moveDataItem(sIndex: Int, _ dIndex: Int) {
        let item = gridDataItems.items.remove(at: sIndex)
        gridDataItems.items.insert(item, at:dIndex)
    }

    func deleteItems(forItemAt indexPath: IndexPath) {
        if let layout = self.collectionView?.collectionViewLayout as? GridLayout {
            layout.deleteCacheItems(withIndex: indexPath.row)
        }
        self.gridDataItems.items.remove(at: indexPath.row)
        self.collectionView?.deleteItems(at: [indexPath])
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.gridDataItems.items.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: indexPath) as! GridCell
        
        let dataValues = self.gridDataItems.items[self.indexOf(indexPath: indexPath)]
        cell.configure(with: dataValues)
        
        cell.tappedOnDeleteBTN = { [unowned self] (selectedCell) -> Void in
            
            self.selectedCellItem = indexPath.row
            DispatchQueue.main.async {
               
                self.collectionView?.performBatchUpdates({
                    let indexPath: IndexPath = (self.collectionView?.indexPath(for: selectedCell)!)!
                    self.deleteItems(forItemAt: indexPath)
                }, completion: { (finish) in })
            }
        }
        
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        let dataValues = self.gridDataItems.items[self.indexOf(indexPath: indexPath)]
        if dataValues.movable {
            return true
        } else {
            return false
        }
    }

    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sIndex = self.indexOf(indexPath: sourceIndexPath)
        let dIndex = self.indexOf(indexPath: destinationIndexPath)

        self.moveDataItem(sIndex: sIndex, dIndex)
    }
    
    // MARK: - Index Transfer
    
    func indexOf(indexPath:IndexPath) -> Int{
        return indexPath.item
    }
    
    func indexPathOf(index:Int) -> IndexPath{
        return IndexPath(row: index, section: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
    
        let dataValues = self.gridDataItems.items[self.indexOf(indexPath: proposedIndexPath)]
        if dataValues.movable {
            return proposedIndexPath
        } else {
            return originalIndexPath
        }

    }

}

//MARK: - LAYOUT DELEGATE
/*
extension GridVC : GridLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, sizeForPhotoAtIndexPath indexPath:IndexPath) -> CGRect {
        
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
    
}
*/
