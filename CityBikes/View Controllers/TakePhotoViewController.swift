//
//  TakePhotoViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 12/2/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class TakePhotoViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let saveButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(TakePhotoViewController.savePhoto(_:)))
        
        //self.navigationItem.rightBarButtonItem = saveButton

        // Do any additional setup after loading the view.
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    }
    
    /*@objc func savePhoto(_ sender: Any) {
        saveImage(imageName: "test3.png")
    }
    
    
    func saveImage(imageName: String) {
        //Create an instance of the FileManager
        let fileManager = FileManager.default
        
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        //get the image we took with camera
        let image = imageView.image
        
        //Get the PNG data for this image
        let data = image!.pngData()
        
        //Store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
    }*/

}
