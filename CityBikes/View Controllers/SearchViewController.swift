//
//  SearchViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/16/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var addressTextField: UITextField!
    
    var latitudeToPass: Double?
    var longitudeToPass: Double?
    var addressToPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addressTextField.isEnabled = false
      
    }
    
    
    
    @IBAction func searchBikeStationsNearMeButtonTapped(_ sender: UIButton) {
        addressToPass = "Current Location"
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            latitudeToPass = locationManager.location!.coordinate.latitude
            longitudeToPass = locationManager.location?.coordinate.longitude
        }
        
        performSegue(withIdentifier: "Show Bike Stations Results", sender: self)
  
    }
    
    
    @IBAction func searchBikeStationsNearAddressButtonTapped(_ sender: UIButton) {
        addressTextField.isEnabled = true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
        addressToPass = addressTextField.text!
        
        if addressToPass!.isEmpty {
            showAlertMessage(messageHeader: "Address Missing!",
                             messageBody: "Please enter an address or a landmark name to show on map!")
            return false
        }
        
        
        //Convert address to get latitude and longitude
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressToPass!) { (placemarks, error) in
            self.geocoderCompletionHandler(withPlacemarks: placemarks, error: error)
        }
        
        return true
    }
    
    
    private func geocoderCompletionHandler(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        if let errorOccurred = error {
            self.showAlertMessage(messageHeader: "Forward Geocoding Unsuccessful!",
                                  messageBody: "Forward Geocoding of the Given Address Failed: \(errorOccurred))")
            return
        }
        
        var geolocation: CLLocation?
        
        if let placemarks = placemarks, placemarks.count > 0 {
            geolocation = placemarks.first?.location
        }
        
        if let locationObtained = geolocation {
            self.latitudeToPass = locationObtained.coordinate.latitude
            self.longitudeToPass = locationObtained.coordinate.longitude
        }
        
        else {
            showAlertMessage(messageHeader: "Location Match Failed!",
                             messageBody: "Unable to Find a Matching Location!")
            return
        }
        
        performSegue(withIdentifier: "Show Bike Stations Results", sender: self)
        
    }
    
    @IBAction func backgroundTouch(_ sender: UIControl) {
        /*
         "This method looks at the current view and its subview hierarchy for the text field that is
         currently the first responder. If it finds one, it asks that text field to resign as first responder.
         If the force parameter is set to true, the text field is never even asked; it is forced to resign." [Apple]
         
         When the Text Field resigns as first responder, the keyboard is automatically removed.
         */
        view.endEditing(true)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Show Bike Stations Results" {
            
            let bikeStationsSearchResults: SearchResultsTableViewController = segue.destination as! SearchResultsTableViewController
            
            bikeStationsSearchResults.addressPassed = addressToPass
            bikeStationsSearchResults.latitudePassed = latitudeToPass!
            bikeStationsSearchResults.longtitudePassed = longitudeToPass!
            
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
