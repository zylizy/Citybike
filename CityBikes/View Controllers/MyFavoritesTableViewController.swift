//
//  MyFavoritesTableViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/4/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class MyFavoritesTableViewController: UITableViewController {
    @IBOutlet var myFavoriteTV: UITableView!
    
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var myFavoriteDict = NSMutableDictionary()
    var stationNameArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myFavoriteDict = applicationDelegate.dict_myFavorite
        stationNameArray = myFavoriteDict.allKeys as! [String]
//         Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                                         action: #selector(MyFavoritesTableViewController.addStation(_:)))
        
        self.navigationItem.rightBarButtonItem = addButton
        stationNameArray.sort { $0 < $1 }
    }
    
    // The addCity method is invoked when the user taps the Add button created in viewDidLoad() above.
    @objc func addStation(_ sender: AnyObject) {
        
        // Perform the segue
        performSegue(withIdentifier: "addAStation", sender: self)
    }
    
    
    @IBAction func unwindToMyFavoriteVC(segue : UIStoryboardSegue) {
        if segue.identifier != "unwindToMyVC" {
            return
        }
        let addStationViewController: AddStationViewController = segue.source as! AddStationViewController
        let stationNameObtained = addStationViewController.stationNameTF.text
        if stationNameObtained == "" {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "No Input")
        }
        
        let longObtained = addStationViewController.longTF.text
        if longObtained == "" {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "No Input")
        }
        let tok = longObtained?.components(separatedBy: ".")
        let ocurrenceOfPoint = tok!.count - 1
        if ocurrenceOfPoint > 1 {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "Multiple point entered")
        }
        var rawText = ""
        if longObtained?.prefix(1) == "." {
            rawText = "0" + longObtained!
        } else if (longObtained?.suffix(1) == ".") {
            rawText = longObtained! + "0"
        } else {
            rawText = longObtained!
        }
        let long = rawText
        
        let laObtained = addStationViewController.laTF.text
        if laObtained == "" {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "No Input")
        }
        let token = laObtained?.components(separatedBy: ".")
        let ocurrenceOfPoints = token!.count - 1
        if ocurrenceOfPoints > 1 {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "Multiple point entered")
        }
        var rawTexts = ""
        if laObtained?.prefix(1) == "." {
            rawTexts = "0" + laObtained!
        } else if (laObtained?.suffix(1) == ".") {
            rawTexts = laObtained! + "0"
        } else {
            rawTexts = laObtained!
        }
        let la = rawTexts
        
        let country = addStationViewController.countryTF.text
        if country == "" {
            showAlertMessage(messageHeader: "Invalid Input", messageBody: "No Input")
        }
        let tempDict = NSMutableDictionary()
        tempDict.setValue(long, forKey: "longitude")
        tempDict.setValue(la, forKey: "latitude")
        tempDict.setValue(country, forKey: "country")
        tempDict.setValue("NoCityId", forKey: "cityId")
        tempDict.setValue("NoStationId", forKey: "stationId")
        applicationDelegate.dict_myFavorite.setObject(tempDict, forKey: stationNameObtained! as NSCopying)
        stationNameArray = myFavoriteDict.allKeys as! [String]
        stationNameArray.sort { $0 < $1 }
        myFavoriteTV.reloadData()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stationNameArray.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath)

        let rowNumber = (indexPath as NSIndexPath).row
        
        let stationName = stationNameArray[rowNumber]
        
        cell.textLabel!.text = stationName
        
        return cell
    }
    

  

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let rowNumber = (indexPath as NSIndexPath).row
            
            // Obtain the stock symbol of the selected Company
            let selectedStationName = stationNameArray[rowNumber]
            
            applicationDelegate.dict_myFavorite.removeObject(forKey: selectedStationName)
            
           stationNameArray = myFavoriteDict.allKeys as! [String]
            
            // Sort the stock symbols within itself in alphabetical order
            stationNameArray.sort { $0 < $1 }
            
            // Reload the Table View
            myFavoriteTV.reloadData()
        }
    }
    



 

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    /*
     -----------------------------
     MARK: - Display Alert Message
     -----------------------------
     */
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
