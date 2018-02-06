# CollectionLayout-Reordering-CustomLayout 

## Supporting iOS 9.0+ version

This Project is contains the custom grid view which will use for showing items in grid by using `UICollectionView`
All the items are draggable and the last is for add new images/`UICollectionCell` into the `UICollectionView`. 
The last item is not movable/draggable because of it's type/operation is provided by it right now.
You can customize these all according to you requirements. 


If you want your last item will become movable/draggable and its not add items or having any action then just update it.
and in the data model of the `UICollectionCell` you need to set is `true`. 

    let addButton = GridItem(imageURL: nil)
    addButton.movable = false

you need to create the array of `GridItem`

## In this repository You can find out Custom Layout of Collection View : 
<p align="center">
  <img src="https://github.com/9SumeetMourya/CollectionLayout-Reordering-CustomLayout/blob/master/Screenshots/layoutSample.png" width=400 />
</p>

# How to use

For using the custom grid layout, you need to provide [GridLayout.swift](https://github.com/9SumeetMourya/CollectionLayout-Reordering-CustomLayout/blob/master/Example/CustomGrid/View/GridLayout.swift) class to UICollectionViewLayout.

If you want that any cell should not movable or draggable then you can use this 
             
     func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
          //it will return true for those item which are movable/Draggable and 
          //for which cell you want: will not movable/Draggable it should return false 
     }

     func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
          //it will return proposedIndexPath for those item which are movable/Draggable,
          //And for which cell you want: will not movable/Draggable it should return originalIndexPath
    }


## For enabling Draggable :



Add **UILongPressGestureRecognizer** to your **UICollectionView**
        
        //add Long press gesture for dragging and dropping
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        gesture.minimumPressDuration = 0.5
        gesture.delegate = self
        self.cvGridView.addGestureRecognizer(gesture)

Action On **UILongPressGestureRecognizer**

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



Implement to these delegate methods for  **UIGestureRecognizerDelegate**

    extension ViewController : UIGestureRecognizerDelegate {
    
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
          return true
        }
    
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
          return true
        }
    }


###  

***
