//
//  ViewController.swift
//  CustomGrid
//
//  Created by Sumeet Mourya on 26/01/18.
//  Copyright © 2018 Sumeet Mourya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK:  UIOutlet Connections

    @IBOutlet var cvGridView: UICollectionView!

    // MARK:  Globle Variables

    var selectedCellIndex: Int = 0 // This is current item selected index
    var numberOfItemsInGrid: [GridItem] = [GridItem]()
    var padding: CGFloat = 5

    // MARK:  Action Methods
    
    @objc func panGestureAction(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            guard let indexPath = self.cvGridView.indexPathForItem(at: sender.location(in: self.cvGridView)) else {
                return
            }
            self.cvGridView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            self.cvGridView.updateInteractiveMovementTargetPosition(sender.location(in: self.cvGridView))
        case .ended:
            self.cvGridView.endInteractiveMovement()
        default:
            self.cvGridView.cancelInteractiveMovement()
        }
    }

    // MARK:  View Initialization Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Grip Layout"
        
        //add Long press gesture for dragging and dropping
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        gesture.minimumPressDuration = 0.5
        gesture.delegate = self
        self.cvGridView.addGestureRecognizer(gesture)
        
        self.loadDataOnViewLoading()
        
        //create the content inset for maintaining the gap between the cells.
        self.cvGridView.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        // Setting up the layout
        cvGridView.collectionViewLayout = GridLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:  Helper Methods

    fileprivate func gridItem(wiht itemIndex: Int) -> GridItem {
        return self.gridItem(at: self.indexPathOf(index: itemIndex, section: 0))
    }

    fileprivate func gridItem(at indexPath: IndexPath) -> GridItem {
        return self.numberOfItemsInGrid[indexPath.item]
    }

    fileprivate func indexOf(indexPath:IndexPath) -> Int{
        return indexPath.item
    }
    
    fileprivate func indexPathOf(index:Int, section: Int) -> IndexPath{
        return IndexPath(row: index, section: section)
    }

    func deleteItems(forItemAt indexPath: IndexPath) {
        if let layout = cvGridView.collectionViewLayout as? GridLayout {
            layout.deleteCacheItems(withIndex: indexPath.item)
        }
        self.numberOfItemsInGrid.remove(at: indexPath.item)
        self.cvGridView.deleteItems(at: [indexPath])
        
        ComponentManager.sharedInstance.deleteItem(with: indexPath.item)
    }
    
    func moveDataItem(sIndex: Int, _ dIndex: Int) {
        let item = self.numberOfItemsInGrid.remove(at: sIndex)
        self.numberOfItemsInGrid.insert(item, at:dIndex)
        
        ComponentManager.sharedInstance.moveItem(from: sIndex, to: dIndex)
    }

    func addItem(with imageURL: String){
        
        let addNewGridItem = GridItem(imageURL: imageURL)
        self.numberOfItemsInGrid.insert(addNewGridItem, at:(self.numberOfItemsInGrid.count - 1))

        self.cvGridView.insertItems(at: [IndexPath(item: (self.numberOfItemsInGrid.count - 2), section: 0)])
        ComponentManager.sharedInstance.addItem(itemOfData: addNewGridItem)
    }
    
    //MARK: private Methods
    
    private func loadDataOnViewLoading() {
        ComponentManager.sharedInstance.getGridDataVAO(onSuccess: { (success) in
            
            DispatchQueue.main.async {
                
                if success {
                    self.numberOfItemsInGrid = ComponentManager.sharedInstance.getGridData().getItems()
                    let addButton = GridItem(imageURL: nil)
                    addButton.movable = false
                    self.numberOfItemsInGrid.append(addButton)
                    //                    self.cvGridView.reloadData()
                    
                    self.cvGridView.performBatchUpdates({
                        
                        var cellNeedToAdd: [IndexPath] = [IndexPath]()
                        for index in 0..<self.numberOfItemsInGrid.count {
                            let indexPath: IndexPath = self.indexPathOf(index: index, section: 0)
                            cellNeedToAdd.append(indexPath)
                        }
                        self.cvGridView.insertItems(at: cellNeedToAdd)
                        
                    }, completion: { (finish) in
                    })
                    
                } else {
                    //When loading has not been successful due to any reason then just show the Add Button in the colletionView
                    self.onlyShowAddButton()
                }
            }
        }, onFailure: { (error, errorDescription) in
           
            //When loading has been failed to load the data from storage then just show the Add Button in the colletionView
            DispatchQueue.main.async {
                self.onlyShowAddButton()
                self.showAlertView(withTitle: "Warning!!!", massaege: errorDescription!)
            }
        })
    }
    
    private func onlyShowAddButton() {
        self.numberOfItemsInGrid = ComponentManager.sharedInstance.getGridData().getItems()
        let addButton = GridItem(imageURL: nil)
        addButton.movable = false
        self.numberOfItemsInGrid.append(addButton)
        self.cvGridView.reloadData()
    }
    
    private func showAlertView(withTitle alertTitle: String, massaege alertDescription: String  ) {
        let alert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: popup Methods
    
    func openPopForAddItem() {
        let alert = UIAlertController(title: "Add Cell", message: "Enter your image url.", preferredStyle: UIAlertControllerStyle.alert)

        alert.addTextField { (textField) in
            textField.placeholder = "Image URL"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
        }))
        
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.cancel, handler: { action in
            
            let tfImageURL = alert.textFields![0] as UITextField
            
            if let imageURL = tfImageURL.text {

                if (imageURL.isValidURLForImage()) {
                    self.addItem(with: imageURL)
                } else {
                    self.showAlertView(withTitle: "Warning!!!", massaege: "Please provide valid URL of image, that should end with either .png or .jpeg or .jpg.")
                }
            }
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func openDeletePopUp() {
        
        let dataValues = self.gridItem(wiht: self.selectedCellIndex)

        let alert = UIAlertController(title: "Cell Deleting!!!", message: "Do you really want to delete the item  with identifier \(dataValues.identifier.uuidString)?", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.cancel, handler: { action in
            
            DispatchQueue.main.async {
                self.cvGridView.performBatchUpdates({
                    let indexPath: IndexPath = self.indexPathOf(index: self.selectedCellIndex, section: 0)
                    self.deleteItems(forItemAt: indexPath)
                }, completion: { (finish) in
                })
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { action in
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

}

    // MARK:  UICollectionViewDelegate Methods
extension ViewController: UICollectionViewDelegate {
    

    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        let dataValues = self.gridItem(at: indexPath)
        if dataValues.movable {
            return true
        } else {
            return false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let sIndex = self.indexOf(indexPath: sourceIndexPath)
        let dIndex = self.indexOf(indexPath: destinationIndexPath)
        
        self.moveDataItem(sIndex: sIndex, dIndex)
    }

    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        let dataValues = self.gridItem(at: proposedIndexPath)
        if dataValues.movable {
            return proposedIndexPath
        } else {
            return originalIndexPath
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let dataValues = self.gridItem(at: indexPath)
        
        if dataValues.movable {
            let alert = UIAlertController(title: "Message", message: "You have selected the item with identifier \(dataValues.identifier.uuidString)", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    
}

    // MARK: UICollectionViewDataSource Methods
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfItemsInGrid.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCell.reuseIdentifier, for: indexPath) as! GridCell

        cell.configure(with: self.gridItem(at: indexPath))
        
        cell.tappedOnAddBTN = { [unowned self] (selectedCell) -> Void in
            DispatchQueue.main.async {
                self.openPopForAddItem()
            }
        }
        
        cell.tappedOnDeleteBTN = { [unowned self] (selectedCell) -> Void in
            
            guard let indexPAthValue = self.cvGridView.indexPath(for: selectedCell) else { return }

            self.selectedCellIndex = indexPAthValue.item
            self.openDeletePopUp()
        }
        
        return cell
    }
    
}

    // MARK: UIGestureRecognizerDelegate Methods
extension ViewController : UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }

}

