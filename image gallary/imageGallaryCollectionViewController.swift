//
//  imageGallaryCollectionViewController.swift
//  image gallary
//
//  Created by Moutaz_Hegazy on 6/1/20.
//  Copyright © 2020 Moutaz_Hegazy. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class imageGallaryCollectionViewController: UICollectionViewController , UICollectionViewDropDelegate , UICollectionViewDelegateFlowLayout , UICollectionViewDragDelegate , cellControlDelegate
{
    func delete(cell: imageCollectionViewCell) {
        if let indexPath = collectionView?.indexPath(for: cell){
            collectionView?.deleteItems(at: [indexPath])
        }
    }
    
    var sendURLsBack : (()->Void)?
    
    var imageURLs = [collectionViewModel]()
        /*{
        let earthImage = collectionViewModel(withURL: URL(string: "https://www.nasa.gov/centers/goddard/images/content/638831main_globe_east_2048.jpg"))
        let moon = collectionViewModel(withURL: URL(string: "https://image.freepik.com/free-vector/full-moon-night-sky-with-stars-clouds-scene_33099-2076.jpg"))
        let saturn = collectionViewModel(withURL: URL(string: "https://www.worldatlas.com/r/w1200-h701-c1200x701/upload/fb/fb/a7/shutterstock-517659922.jpg"))
        
        var images  = [collectionViewModel]()
        images.append(earthImage)
        images += [moon,saturn]
        return images
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.dropDelegate = self
        collectionView?.dragDelegate = self
        collectionView?.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(zoomEffect(_:))))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendURLsBack?()
    }
    
    
    @objc func zoomEffect(_ pinch : UIPinchGestureRecognizer){
        switch pinch.state{
        case .changed,.ended:
            scale *= pinch.scale
            pinch.scale = 1.0
            
        default : break
        }
    }
    
    private var scale : CGFloat = 1.0{
        didSet{
            collectionView?.reloadData()
        }
    }
    
    /*
     
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageURLs.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        
        if let imageCell = cell as? imageCollectionViewCell{
            
            let cellModel = imageURLs[indexPath.item]
            
            imageCell.imageURL = cellModel.imageUrl
            
        }
        return cell
    }

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    
    // drop interaction configuration ->
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) || session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        let isSelf =  (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: (isSelf) ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        let destination = coordinator.destinationIndexPath ?? IndexPath(item: imageURLs.count, section: 0)
        
        var height : Float = 300
        
        coordinator.session.loadObjects(ofClass: UIImage.self) { (images) in
            if let image = images.first as? UIImage{
                height = Float((300/image.size.width) * image.size.height)
            }
        }
        
        for item in coordinator.items{
            
            if let sourceIndexPath = item.sourceIndexPath{
                let newCell = imageURLs[sourceIndexPath.item]
                collectionView.performBatchUpdates({
                    imageURLs.remove(at: sourceIndexPath.item)
                    imageURLs.insert(newCell, at: destination.item)
                    collectionView.deleteItems(at: [sourceIndexPath])
                    collectionView.insertItems(at: [destination])
                })
                coordinator.drop(item.dragItem, toItemAt: destination)
            }else{
                let placeHolder = coordinator.drop(item.dragItem, to: UICollectionViewDropPlaceholder(insertionIndexPath: destination, reuseIdentifier: "placeHolderCell"))
                
                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let url = provider as? URL{
                            placeHolder.commitInsertion(dataSourceUpdates: { (destinationIndexPass) in
                                var newCell = collectionViewModel(withURL: url)
                                newCell.imageHeight = height
                                self.imageURLs.insert(newCell, at: destinationIndexPass.item)
                            })
                        }else{
                            placeHolder.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    // drop interaction ends.
    
    
    // drag interaction configuration -->
    
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if let cell = collectionView.visibleCells[indexPath.item] as? imageCollectionViewCell{
            if let url = cell.imageURL{
                let dragItem = UIDragItem(itemProvider: NSItemProvider(contentsOf: url)!)
                dragItem.localObject = cell.imageURL
                return [dragItem]
            }else{}
        }else{}
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return []
    }
    
//    private func dragItem(at indexPath : IndexPath) -> [UIDragItem]{
//
//        let dragItem = UIDragItem(itemProvider: NSItemProvider(contentsOf: ))
//        dragItem.
//    }
    
    // drag interaction ends here.
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (300 * scale), height: (scale * CGFloat(imageURLs[indexPath.item].imageHeight ?? 300 )))
    }

}


protocol cellControlDelegate {
    func delete(cell : imageCollectionViewCell)
}

