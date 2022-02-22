//
//  ViewDetailedPhotoViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 12/2/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class ViewDetailedPhotoViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var imageViewTextPassed: String = ""
    var keyPassed: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageView.image = getImage(imageName: imageViewTextPassed)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func getImage(imageName: String) -> UIImage {
        let fileManager = FileManager.default
        
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        
        if fileManager.fileExists(atPath: imagePath) {
            return UIImage(contentsOfFile: imagePath)!
        }
        else {
            return UIImage(named: imageName)!
        }
    }
    
}
