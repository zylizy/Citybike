//
//  PhotoLibraryCollectionViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/19/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Image Collection Cell"

class PhotoLibraryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
// UIViewControllerPreviewingDelegate
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
//        guard let indexPath = photoCollectionView.indexPathForItem(at: location),
//            let cell = photoCollectionView.cellForItem(at: indexPath) else { return nil }
//        let identifier = "showPhotoVC"
//        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? ViewDetailedPhotoViewController else {
//            return nil
//        }
//        let cellNumber = indexPath.item
//
//        detailVC.imageViewTextPassed = applicationDelegate.dict_photo_Names[photoKeys[cellNumber]] as! String
//        previewingContext.sourceRect = cell.frame
//        return detailVC
//    }
//
//    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
//        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
//    }
//
    

    @IBOutlet var photoCollectionView: UICollectionView!
    
  
    var collectionViewFlowLayout: UICollectionViewFlowLayout! {
        return self.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var photoKeys = [String]()
    var numberOfPhoto: Int = 0
    
    var photoNameObtained: String = ""
    var keyObtained: String = ""
    
    var snapshotView: UIView?
    var snapshotIndexPath: IndexPath?
    var snapshotPanPoint: CGPoint?
    
    //var images = ImageDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PhotoLibraryCollectionViewController.addPhoto(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        
        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
        photoKeys = applicationDelegate.dict_photo_Names.allKeys as! [String]
        numberOfPhoto = photoKeys.count
        //photoKeys.sort{$0 < $1}
        
        configureUI()
        
    }
    
    func configureUI() {
        collectionViewFlowLayout.minimumInteritemSpacing = 5.0
        collectionViewFlowLayout.minimumLineSpacing = 5.0
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressRecognized(gesture:)))
        gestureRecognizer.minimumPressDuration = 0.2
        photoCollectionView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func addPhoto(_ sender: AnyObject) {
        
        // Perform the segue
        performSegue(withIdentifier: "Add Photo", sender: self)
    }
    
    /*
     ---------------------------
     MARK: - Unwind Segue Method
     ---------------------------
     */
    @IBAction func unwindToPhotoLibraryCollectionViewController(segue: UIStoryboardSegue) {
        if segue.identifier != "AddPhoto-Save" {
            return
        }
        // Obtain the object reference of the source view controller
        let addPhotoViewController: TakePhotoViewController = segue.source as! TakePhotoViewController
        let imageObtained = addPhotoViewController.imageView
        
        let fileName = "bike\(numberOfPhoto).png"
        
        //Save image with filename
        saveImage(imageName: fileName, imageView: imageObtained!)
        
        //Update dictionary
        applicationDelegate.dict_photo_Names.setValue(fileName, forKey: String(numberOfPhoto))
        
        photoKeys = applicationDelegate.dict_photo_Names.allKeys as! [String]
        numberOfPhoto = numberOfPhoto + 1
        
        //photoKeys.sort{$0 < $1}
        
        /*
         -------------------------
         Update the collectionView
         -------------------------
         */
        photoCollectionView.reloadData()
    }
    
    @IBAction func unwindDeletePhotoToPhotoLibraryCollectionViewController(segue: UIStoryboardSegue) {
        if segue.identifier != "DeletePhoto-Save" {
            return
        }
        
        // Obtain the object reference of the source view controller
        let viewDetailedPhotoViewController: ViewDetailedPhotoViewController = segue.source as! ViewDetailedPhotoViewController
        
        let deletedKey = viewDetailedPhotoViewController.keyPassed
        //let deletePhotoName = viewDetailedPhotoViewController.imageViewTextPassed
        
        //Update dictionary
        applicationDelegate.dict_photo_Names.removeObject(forKey: deletedKey)
        
        photoKeys = applicationDelegate.dict_photo_Names.allKeys as! [String]
        //photoKeys.sort{$0 < $1}
        
        /*
         -------------------------
         Update the collectionView
         -------------------------
         */
        photoCollectionView.reloadData()
        
    }
    
    func saveImage(imageName: String, imageView: UIImageView) {
        //Create an instance of the FileManager
        let fileManager = FileManager.default
        
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //get the image we took with camera
        let image = self.rotateImage(image: imageView.image!)
        
        //Get the PNG data for this image
        let data = image.pngData()
        
        //Store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }
    
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
    
    
    //***********************************
    // MARK: UICollectionView FlowLayout Delegate
    //***********************************
    /*func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
     
     return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
     return 0
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return 0
     }*/
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalInteritemSpacing = (3 * collectionViewFlowLayout.minimumInteritemSpacing)
        let totalSectionInset = collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
        let size = (collectionView.bounds.width - (totalSectionInset + totalInteritemSpacing)) / 3
        
        //let size = view.bounds.width / 3
        
        return CGSize(width: size, height: size)
    }
    
    
    //***********************************
    // MARK: UICollectionViewDataSource
    //***********************************
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return photoKeys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellNumber = indexPath.item
        let cell: PhotoLibraryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Image Collection Cell", for: indexPath) as! PhotoLibraryCollectionViewCell
        
        let key = photoKeys[cellNumber]
        let photoName = applicationDelegate.dict_photo_Names[key] as! String
        
        
        cell.imageView.image = self.getImage(imageName: photoName)
        cell.imageView.contentMode = UIView.ContentMode.scaleToFill
        
        //cell.imageView.backgroundColor = .blue
        
        
        // Configure the cell
        
        return cell
    }
    
    func getImage(imageName: String) -> UIImage {
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)!
        }
        else {
            return UIImage(named: imageName)!
            
            //if UIImage is null return noimage found
        }
    }
    
    
    @objc func longPressRecognized(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: photoCollectionView)
        let indexPath = photoCollectionView.indexPathForItem(at: location)
        
        var itemNumberFrom: Int = 0
        var itemNumberTo: Int = 0
        var imageNameFrom = ""
        var imageNameTo = ""
        
        var keyFrom = ""
        var keyTo = ""
        
        switch gesture.state {
            
        case .began:
            guard let indexPath = indexPath
                else {
                    break
            }
            let cell = photoCollectionView.cellForItem(at: indexPath) as! PhotoLibraryCollectionViewCell
            
            snapshotView = cell.snapshotView(afterScreenUpdates: true)
            photoCollectionView.addSubview(snapshotView!)
            cell.contentView.alpha = 0.9
            
            UIView.animate(withDuration: 0.2, animations: {
                self.snapshotView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self.snapshotView?.alpha = 0.9
            })
            
            snapshotPanPoint = location
            snapshotIndexPath = indexPath
            
        case .changed:
            guard let snapshotPanPoint = snapshotPanPoint
                else {
                    break
                    
            }
            
            let translation = CGPoint(x: location.x - snapshotPanPoint.x, y: location.y - snapshotPanPoint.y)
            snapshotView?.center.x += translation.x
            snapshotView?.center.y += translation.y
            
            self.snapshotPanPoint = location
            
            guard let indexPath = indexPath
                else {
                    return
                    
            }
            
            
            photoCollectionView.moveItem(at: snapshotIndexPath!, to: indexPath)
            //let end = indexPath.item
            //let start = snapshotIndexPath?.item
            
            
            //photoCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
            
            itemNumberFrom = (snapshotIndexPath?.item)!
            itemNumberTo = indexPath.item
            
            keyFrom = photoKeys[itemNumberFrom]
            keyTo = photoKeys[itemNumberTo]
            imageNameFrom = applicationDelegate.dict_photo_Names[keyFrom] as! String
            imageNameTo = applicationDelegate.dict_photo_Names[keyTo] as! String
            
            //print(imageNameFrom)
            //print(imageNameTo)
            snapshotIndexPath = indexPath
            
            //print(snapshotIndexPath?.item)
            
            
        default:
            guard let snapshotIndexPath = snapshotIndexPath
                else {
                    return
            }
            
            let cell = photoCollectionView.cellForItem(at: snapshotIndexPath) as! PhotoLibraryCollectionViewCell
            
            UIView.animate(withDuration: 0.2,
                           animations: {
                            self.snapshotView?.center = cell.center
                            self.snapshotView?.transform = CGAffineTransform.identity
                            self.snapshotView?.alpha = 1.0
            },
                           completion: {
                            finished in
                            cell.contentView.alpha = 1.0
                            self.snapshotView?.removeFromSuperview()
                            self.snapshotView = nil
            })
            
            self.snapshotIndexPath = nil
            self.snapshotPanPoint = nil
            
            //photoCollectionView.cancelInteractiveMovement()
        }
        
        if itemNumberTo != itemNumberFrom {
            applicationDelegate.dict_photo_Names[keyFrom] = imageNameTo
            applicationDelegate.dict_photo_Names[keyTo] = imageNameFrom
            
        }
        
        //let keys = applicationDelegate.dict_photo_Names.allValues as? [String]
        //print(keys)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellNumber = indexPath.item
        let key = photoKeys[cellNumber]
        photoNameObtained = applicationDelegate.dict_photo_Names[key] as! String
        keyObtained = key
        
        performSegue(withIdentifier: "View Photo Detail", sender: self)
        
        /*let imageView = UIImageView(image: UIImage(named: photoNameObtained))
         imageView.frame = view.frame
         imageView.backgroundColor = .black
         imageView.contentMode = .center
         imageView.isUserInteractionEnabled = true
         
         let tap = UITapGestureRecognizer(target: self, action: #selector(PhotoLibraryCollectionViewController.dismissFullscreenImage(_:)))
         
         imageView.addGestureRecognizer(tap)
         
         self.view.addSubview(imageView)*/
    }
    
    // Use to back from full mode
    /*@objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
     sender.view?.removeFromSuperview()
     }*/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "View Photo Detail" {
            let viewDetailedPhoto: ViewDetailedPhotoViewController = segue.destination as! ViewDetailedPhotoViewController
            
            viewDetailedPhoto.imageViewTextPassed = photoNameObtained
            viewDetailedPhoto.keyPassed = keyObtained
        }
    }
    
    
}
