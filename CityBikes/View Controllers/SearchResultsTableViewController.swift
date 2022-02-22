//
//  SearchResultsTableViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/16/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit


class SearchResultsTableViewController: UITableViewController, MKMapViewDelegate, UIViewControllerPreviewingDelegate {
   
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView.indexPathForRow(at: location),
            let cell = tableView.cellForRow(at: indexPath) else { return nil }
        let identifier = "ShowDetailsInformationBikeStationViewController"
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: identifier) as? ShowDetailsInformationBikeStationViewController else {
            return nil
        }
        let rowNumber = (indexPath as NSIndexPath).row
        detailVC.bikeStationPassed = stationsFound[rowNumber] as! [Any]
        previewingContext.sourceRect = cell.frame
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    

    var addressPassed: String! = ""
    var longtitudePassed: Double = 0.0
    var latitudePassed: Double = 0.0
    
    var stationsFound: NSMutableArray = NSMutableArray()
    var bikeStationToPass = [Any]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

   
        readAPI()
    }

    
    func readAPI() {
        
        let coordinate0 = CLLocation(latitude: latitudePassed, longitude: longtitudePassed)
        
        let apiURL = "https://api.coord.co/v1/bike/location?latitude=\(latitudePassed)&longitude=\(longtitudePassed)&radius_km=2.00&access_key=-wpwXlWKE9UL2UfX_7RvQa9QdttHkyrantZ3LHbaHZM"
        
        //let apiURL = "https://api.coord.co/v1/bike/location?latitude=40.742868&longitude=-73.989186&radius_km=0.25&access_key=-wpwXlWKE9UL2UfX_7RvQa9QdttHkyrantZ3LHbaHZM"
        
        
        let url: URL? = URL(string: apiURL)
        
        let jsonData: Data?
        
        do {
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the first JSON data file to get the information")
            return
        }
        
        if let jsonDataFromApiURL = jsonData {
            let jsonDataDict = try? JSONSerialization.jsonObject(with: jsonDataFromApiURL, options: []) as? [String: Any]
            
            if let dictionaryStatus = jsonDataDict as? Dictionary<String, AnyObject> {
                if let results = dictionaryStatus["features"] as? [[String: AnyObject]] {
                    
                    for result in results {
                        var long: Double = 0
                        var lat: Double = 0
                        var lastReport = ""
                        var stationName = ""
                        var bikeAvail: Int = 0
                        var dockAvail: Int = 0
                        var systemID = ""
                        
                        if let properties = result["properties"] as? Dictionary<String, AnyObject>{
                            long = properties["lon"] as! Double
                            lat = properties["lat"] as! Double
                            lastReport = properties["last_reported"] as! String
                            stationName = properties["name"] as! String
                            bikeAvail = properties["num_bikes_available"] as! Int
                            if properties.count <= 11 {
                                dockAvail = 0
                            }
                            else {
                                dockAvail = properties["num_docks_available"] as! Int
                            }
                            systemID = properties["system_id"] as! String
                        }
                        
                        let coordinate1 = CLLocation(latitude: lat, longitude: long)
                        let distanceInMeters = coordinate0.distance(from: coordinate1)
                        //let distance = distanceInMeters / 1000
                        let distance = String(format: "%.02f", distanceInMeters) + " m"
                        
                        let stationData = [long, lat, lastReport, stationName, bikeAvail, dockAvail, systemID, distance] as [Any]
                        
                        stationsFound.add(stationData)
                        
                    }
                }
            }
        }
        
        if stationsFound.count == 0 {
            showAlertMessage(messageHeader: "No Station is found!", messageBody: "There is no station found!")
        }
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stationsFound.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Bike Stations Cell", for: indexPath)
        
        let stationDataObtained = stationsFound[rowNumber] as! [Any]
        
        cell.textLabel?.text = stationDataObtained[3] as? String
        cell.detailTextLabel?.text = stationDataObtained[7] as? String
       
        self.registerForPreviewing(with: self, sourceView: cell)
        
        return cell
    }
    
    //---------------------------
    // TopNews (Row) Selected
    //---------------------------
    
    // Tapping a row (TopNews) displays data about the selected TopNews
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        bikeStationToPass = stationsFound[rowNumber] as! [Any]
        
        performSegue(withIdentifier: "Show Details Information Bike Station", sender: self)
        
    }
    
    //--------------------------------
    // Detail Disclosure Button Tapped
    //--------------------------------
    
    // This is the method invoked when the user taps the Detail Disclosure button (circle icon with i)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        let rowNumber = (indexPath as NSIndexPath).row
        
        bikeStationToPass = stationsFound[rowNumber] as! [Any]
        
        performSegue(withIdentifier: "Show Bike Station On Map", sender: self)
        
    }
    
    //-------------------------------------
    // Prepare and Return a Table View Cell
    //-------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Details Information Bike Station" {
            
            let bikeStationDetailViewController: ShowDetailsInformationBikeStationViewController = segue.destination as! ShowDetailsInformationBikeStationViewController
            
            bikeStationDetailViewController.bikeStationPassed = bikeStationToPass
            
        }
        
        if segue.identifier == "Show Bike Station On Map" {
            
            let bikeStationOnMapViewController: ShowBikeStationOnMapViewController = segue.destination as! ShowBikeStationOnMapViewController
            
            bikeStationOnMapViewController.bikeStationPassed = bikeStationToPass
            bikeStationOnMapViewController.searchLocationPassedToMap = CLLocationCoordinate2D(latitude: latitudePassed, longitude: longtitudePassed)
        }
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
