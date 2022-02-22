//
//  StationsTableViewController.swift
//  CityBikes
//
//  Created by Xue on 12/4/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit

class StationsTableViewController: UITableViewController, UIViewControllerPreviewingDelegate {

    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let identifier = "stationDetailVC"
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? DetailsViewController else {
            return nil
        }
        let rowNumber = (indexPath as NSIndexPath).row
        
        
        
        dataObjectToPass.append(station_Address[rowNumber])
        dataObjectToPass.append(companyArray[0])
        let stationDict = dict_stations_fields.value(forKey: station_Address[rowNumber]) as! NSDictionary
        let longtitude = stationDict["longitude"] as! Double
        let latitude = stationDict["latitude"] as! Double
        let emptyslot = stationDict["empty_slots"] as! Int
        let freeBikes = stationDict["free_bikes"] as! Int
        dataObjectToPass.append(String(emptyslot))
        dataObjectToPass.append(String(freeBikes))
        dataObjectToPass.append(String(latitude))
        dataObjectToPass.append(String(longtitude))
        dataObjectToPass.append(station_Address[rowNumber])
        dataObjectToPass.append(countryPassed)
        dataObjectToPass.append(cityIdObtained)
        
        detailVC.dataPassed = dataObjectToPass
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
    
    @IBOutlet var stationTableView: UITableView!
    let tableViewRowHeight: CGFloat = 60.0
    
    // Define MintCream color: #F5FFFA  245,255,250
    let MINT_CREAM = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 1.0)
    
    // Define OldLace color: #FDF5E6   253,245,230
    let OLD_LACE = UIColor(red: 253.0/255.0, green: 245.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    
    var dataObjectToPass: [String] = []
    var station_Address = [String]()
    var companyArray = [String]()
    var dict_stations_fields : NSMutableDictionary = NSMutableDictionary()
    var stationData : Data?
    
    var countryPassed = ""
    var cityIDToPass: [String] = []
    var stationIDToPass: [String] = []
    
    var cityIdObtained = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // let cityId = dataObjectToPass
        stationTableView.delegate = self
        stationTableView.dataSource = self
        let apiUrl = "http://api.citybik.es/v2/networks/" + cityIdObtained
        
        let cSet = CharacterSet.urlQueryAllowed
        
        let temp = apiUrl.addingPercentEncoding(withAllowedCharacters: cSet)
        let url = URL(string: temp!)
        
        let stationDataReturned : Data? = try? Data(contentsOf: url!)
        // check the nil situation
        if let stationDataObtained = stationDataReturned
        {
            stationData = stationDataObtained
        }
        else {
            showAlertMessage(messageHeader: "Invalid Data!", messageBody: "Cannot find such data from api")
        }
        
        let jsonDict : NSDictionary = (try! JSONSerialization.jsonObject(with: stationData!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        var networkDict = NSDictionary()
        if let tempDict = jsonDict.value(forKey: "network") as? NSDictionary {
            networkDict = tempDict
        }
        
        
        var stationArray = [NSDictionary]()
        if let tempArray = networkDict.value(forKey: "stations") as? Array<NSDictionary>  {
            stationArray = tempArray
        }
        if(stationArray.count == 0)
        {
            
        }
        if let tempArray = networkDict.value(forKey: "company") as? Array<String> {
            companyArray = tempArray
        }
        for item in stationArray {
            let tempDict = NSMutableDictionary()
//            let a = item["latitude"] as! Double
//            let b = item["longitude"] as! Double
            tempDict.setValue((item["latitude"] as! Double), forKey: "latitude")
            tempDict.setValue((item["longitude"] as! Double), forKey: "longitude")
            let test = item["empty_slots"] as? NSNull
            if test == nil {
                tempDict.setValue(item["empty_slots"] as! Int, forKey: "empty_slots")
            } else {
                tempDict.setValue(0, forKey: "empty_slots")
            }
            let test1 = item["free_bikes"] as? NSNull
            if test1 == nil {
                tempDict.setValue(item["free_bikes"] as! Int, forKey: "free_bikes")
            } else {
                tempDict.setValue(0, forKey: "free_bikes")
            }
            
            dict_stations_fields.setValue(tempDict, forKey: item["name"] as! String)
        }
        
        station_Address = dict_stations_fields.allKeys as! [String]
        companyArray.sort { $0 < $1 }
        station_Address.sort { $0 < $1 }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return station_Address.count
    }
    
    
    /*
     ------------------------------------
     Prepare and Return a Table View Cell
     ------------------------------------
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber: Int = (indexPath as NSIndexPath).row    // Identify the row number
        // Obtain the object reference of a reusable table view cell object instantiated under the identifier
        
        // CountryCellType, which was specified in the storyboard
        let cell: StationsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "StationsCell") as! StationsTableViewCell
        
        // Obtain the country code of the row
        let name: String = station_Address[rowNumber]
        cell.textLabel!.text = name
        
        self.registerForPreviewing(with: self, sourceView: cell)
        return cell
    }
    
    /*
     -----------------------------------
     MARK: - Table View Delegate Methods
     -----------------------------------
     */
    
    // Asks the table view delegate to return the height of a given row.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableViewRowHeight
    }
    
    /*
     Informs the table view delegate that the table view is about to display a cell for a particular row.
     Just before the cell is displayed, we change the cell's background color as MINT_CREAM for even-numbered rows
     and OLD_LACE for odd-numbered rows to improve the table view's readability.
     */
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /*
         The remainder operator (RowNumber % 2) computes how many multiples of 2 will fit inside RowNumber
         and returns the value, either 0 or 1, that is left over (known as the remainder).
         Remainder 0 implies even-numbered rows; Remainder 1 implies odd-numbered rows.
         */
        if (indexPath as NSIndexPath).row % 2 == 0 {
            // Set even-numbered row's background color to MintCream, #F5FFFA 245,255,250
            cell.backgroundColor = MINT_CREAM
            
        } else {
            // Set odd-numbered row's background color to OldLace, #FDF5E6 253,245,230
            cell.backgroundColor = OLD_LACE
        }
    }
    
    //--------------------------------
    // Detail Disclosure Button Tapped
    //--------------------------------
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        // Obtain the stock symbol of the selected Company
        let selectedStation = station_Address[rowNumber]
        let selectedCompany = companyArray[0]
        
        //let stations: AnyObject? = dict_stations_fields[selectedStation] as AnyObject
        
        let stationDict = dict_stations_fields.value(forKey: selectedStation) as! NSDictionary
        let longtitude = stationDict["longitude"] as! Double
        let latitude = stationDict["latitude"] as! Double
        let emptyslot = stationDict["empty_slots"] as! Int
        let freeBikes = stationDict["free_bikes"] as! Int
        // Prepare the data object to pass to the downstream view controller
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


        dataObjectToPass.append(selectedStation)
        dataObjectToPass.append(selectedCompany)
        dataObjectToPass.append(String(emptyslot))
        dataObjectToPass.append(String(freeBikes))
        dataObjectToPass.append(String(latitude))
        dataObjectToPass.append(String(longtitude))
        dataObjectToPass.append(selectedStation)
        dataObjectToPass.append(countryPassed)
        dataObjectToPass.append(cityIdObtained)
//        dataObjectToPass.append(stationIDToPass[rowNumber])
        

        // Perform the segue named CityMap
        performSegue(withIdentifier: "ShowDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if segue.identifier == "ShowDetails" {
            
            // Obtain the object reference of the destination view controller
            let detailsVC: DetailsViewController = segue.destination as! DetailsViewController
            
            // Under the Delegation Design Pattern, set the addCityViewController's delegate to be self
            detailsVC.dataPassed = dataObjectToPass
        }/*
         else if segue.identifier == "CityMap" {
         
         // Obtain the object reference of the destination view controller
         let cityMapViewController: CityMapViewController = segue.destination as! CityMapViewController
         
         //Pass the data object to the destination view controller object
         cityMapViewController.dataObjectPassed = dataObjectToPass
         
         }*/
    }

    /**
     * show alert msg
     */
    func showAlertMessage(messageHeader header: String, messageBody body: String)
    {
        let alertController = UIAlertController(title: header, message: body, preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    

}
