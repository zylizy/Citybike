//
//  HomeViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/16/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    //var location: CLLocationCoordinate2D?
    
    //let newYorkCenterLocation = CLLocationCoordinate2D(latitude: 40.7143528, longitude: -74.00597309999999)
    
    // Obtain the object reference to the App Delegate object
    let applicationDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let latitudeSpanInMeters: Double = 1609.344
    //let latitudeSpanInMeters: Double = 160
    
    let longtitudeSpanInMeters: Double = 1069.344
    //let longtitudeSpanInMeters: Double = 106
    
    var dict_Stations_Data: NSMutableDictionary = NSMutableDictionary()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        /*let geocoder = CLGeocoder()
        let address = "20 W 34th St, New York, NY 10001"
        var location2: CLLocation!
        
        //Convert address to get latitude and longitude
        geocoder.geocodeAddressString(address) { (placemarks, error) -> Void in
            if let aPlacemark = placemarks?[0] {
                
                location2 = aPlacemark.location
                print(location2.coordinate)
                
                //self.location = CLLocationCoordinate2D(latitude: (aPlacemark.location?.coordinate.latitude)!, longitude: (aPlacemark.location?.coordinate.longitude)!)
               // print(self.location)
            }
            else {
                self.showAlertMessage(messageHeader: "Forward Geocoding Failed!", messageBody: "This could be because your device is not connected to the Internet!")
                return
            }
        }*/
        
        readAPI()
        
        showMap()
    }
    
    /**
     -----------------------------
     Read data from API for HomeViewController
     -----------------------------
     **/
    func readAPI() {
        
        let apiURL = "https://api.citybik.es/v2/networks/citi-bike-nyc"
        
        let url: URL? = URL(string: apiURL)
        
        let jsonData: Data?
        
        do {
            jsonData = try Data(contentsOf: url!, options: NSData.ReadingOptions.mappedIfSafe)
        }
        catch {
            showAlertMessage(messageHeader: "JSON Data", messageBody: "Unable to obtain the first JSON data file to get imagename, poster, and ID!")
            return
        }
        
        if let jsonDataFromApiURL = jsonData {
            
            let jsonDataDict = try? JSONSerialization.jsonObject(with: jsonDataFromApiURL, options: []) as? [String: Any]
            
            if let dictionaryStatus = jsonDataDict as? Dictionary<String, AnyObject> {
                
                if let network = dictionaryStatus["network"] as? Dictionary<String, AnyObject> {
                    
                    if let stations = network["stations"] as? [[String: AnyObject]] {
                        
                        var freebike: Int = 0
                        var empty_slots: Int = 0
                        var name: String = ""
                        var long: Double = 0.0
                        var lat: Double = 0.0
                        
                        for station in stations {
                            
                            //Empty slots
                            if station["empty_slots"] is NSNull {
                                empty_slots = 0
                            }
                            else {
                                empty_slots = station["empty_slots"] as! Int
                            }
                            
                            //Freebike
                            if station["free_bikes"] is NSNull {
                                freebike = 0
                            }
                            else {
                                freebike = station["free_bikes"] as! Int
                            }
                            
                            //Station Name
                            if station["name"] is NSNull {
                                name = ""
                            }
                            else {
                                name = station["name"] as! String
                            }
                            
                            //Longtitude
                            if station["longitude"] is NSNull {
                                long = 0.0
                            }
                            else {
                                long = station["longitude"] as! Double
                            }
                            
                            //Longtitude
                            if station["latitude"] is NSNull {
                                lat = 0.0
                            }
                            else {
                                lat = station["latitude"] as! Double
                            }
                            
                            let stationData = [freebike, empty_slots, long, lat] as [Any]
                            dict_Stations_Data[name] = stationData
                        }
                    }
                    
                }
            }
        }
    }
    
    

    func showMap() {
        
        let stationNames = dict_Stations_Data.allKeys as! [String]
        
        for i in 0...stationNames.count/2 {
            let data = dict_Stations_Data[stationNames[i]] as! [Any]
            let long = data[2] as! Double
            let lat = data[3] as! Double
            
            let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: location, latitudinalMeters: latitudeSpanInMeters, longitudinalMeters: longtitudeSpanInMeters)
            
            mapView.setRegion(mapRegion, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = stationNames[i]
            
            let subTitle = "Free bike: \(data[0]) Empty slots: \(data[1])"
            annotation.subtitle = subTitle
            
            mapView.addAnnotation(annotation)
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
