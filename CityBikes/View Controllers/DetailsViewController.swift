//
//  DetailsViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/4/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController {
    
    @IBOutlet var addressLabel : UILabel?
    @IBOutlet var companyName : UILabel?
    @IBOutlet var emptySlots : UILabel?
    @IBOutlet var freeBike : UILabel?
    @IBOutlet var mapTypeSeg: UISegmentedControl!
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    // dataPassed[0] = address
    // dataPassed[1] = company name
    // dataPassed[2] = emptyslot
    // dataPassed[3] = freeBikes
    // dataPassed[4] = latitude
    // dataPassed[5] = longitude
    // dataPassed[6] = stationName
    // dataPassed[7] = country
    // dataPassed[8] = cityId
    // dataPassed[9] = stationId
    var dataPassed = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressLabel?.text = dataPassed[0]
        companyName?.text = dataPassed[1]
        emptySlots?.text = dataPassed[2]
        freeBike?.text = dataPassed[3]
        
        mapTypeSeg.selectedSegmentIndex = -1
        
        //--------------------------------------------------
        // Adjust the title to fit within the navigation bar
        //--------------------------------------------------
//        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
//        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
//        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
//        let titleLabel = UILabel(frame: labelRect)
//
//        titleLabel.text = dataPassed[6]
//        titleLabel.font = titleLabel.font.withSize(12)
//        titleLabel.numberOfLines = 2
//        titleLabel.textAlignment = .center
//        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.title = dataPassed[6]
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func showTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
//         To Map
        if segue.identifier == "toMap" {
            var mapTypeToPass: MKMapType?
            let index = mapTypeSeg.selectedSegmentIndex
            switch index {
            case 0:
                mapTypeToPass = MKMapType.standard
            case 1:
                mapTypeToPass = MKMapType.satellite
            case 2:
                mapTypeToPass = MKMapType.hybrid
            default:
                showAlertMessage(messageHeader: "No Map Type Selected", messageBody: "Please select map type")
                return
            }
            let stationMapVC : StationMapViewController = segue.destination as! StationMapViewController
            stationMapVC.mapTypePassed = mapTypeToPass
            stationMapVC.longitudePassed = Double(dataPassed[5])
            stationMapVC.latitudePassed = Double(dataPassed[4])
            stationMapVC.stationName = dataPassed[6]
        }
        
       
    }
    
  
    @IBAction func addToFavorite(_ sender: UIBarButtonItem) {
        let tempDict = NSMutableDictionary()
        tempDict.setValue(dataPassed[5], forKey: "longitude")
        tempDict.setValue(dataPassed[4], forKey: "latitude")
        tempDict.setValue(dataPassed[7], forKey: "country")
        tempDict.setValue(dataPassed[8], forKey: "cityId")
        tempDict.setValue("NoStationId", forKey: "stationId")
        applicationDelegate.dict_myFavorite.setObject(tempDict, forKey: dataPassed[6] as NSCopying)
        showAlertMessage(messageHeader: "Add succeed", messageBody: "Station Info has been added to my favorites")
    }
    
    func showAlertMessage(messageHeader header: String, messageBody body: String) {
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
}
