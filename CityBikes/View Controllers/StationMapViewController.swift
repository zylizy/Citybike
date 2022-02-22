//
//  StationMapViewController.swift
//  CityBikes
//
//  Created by Zhiyuan Li on 12/4/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StationMapViewController: UIViewController {
    
    @IBOutlet var mapView : MKMapView!
    var mapTypePassed : MKMapType?
    var longitudePassed : Double?
    var latitudePassed : Double?
    var stationName = ""
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 804.672    // = 0.5 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 804.672   // = 0.5 mile
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationBarWidth = self.navigationController?.navigationBar.frame.width
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height
        let labelRect = CGRect(x: 0, y: 0, width: navigationBarWidth!, height: navigationBarHeight!)
        let titleLabel = UILabel(frame: labelRect)
        
        titleLabel.text = stationName
        titleLabel.font = titleLabel.font.withSize(12)
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.lineBreakMode = .byWordWrapping
        self.navigationItem.titleView = titleLabel
        // Do any additional setup after loading the view.
        //-----------------------------
        // Dress up the map view object
        //-----------------------------
        
        mapView.mapType = mapTypePassed!
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = false
        
        // Address Center Geolocation
        let addressCenterLocation = CLLocationCoordinate2D(latitude: latitudePassed!, longitude: longitudePassed!)
        
        // Define map's visible region
        let addressMapRegion: MKCoordinateRegion? = MKCoordinateRegion(center: addressCenterLocation, latitudinalMeters: latitudinalSpanInMeters, longitudinalMeters: longitudinalSpanInMeters)
        
        // Set the mapView to show the defined visible region
        mapView.setRegion(addressMapRegion!, animated: true)
        //*************************************
        // Prepare and Set Address Annotation
        //*************************************
        
        // Instantiate an object from the MKPointAnnotation() class and place its obj ref into local variable annotation
        let annotation = MKPointAnnotation()
        
        // Dress up the newly created MKPointAnnotation() object
        annotation.coordinate = addressCenterLocation
        annotation.title = stationName
        annotation.subtitle = ""
        
        // Add the created and dressed up MKPointAnnotation() object to the map view
        mapView.addAnnotation(annotation)
    }
    /*
     -------------------------------------------------------------------
     Force this view to be displayed only in Portrait device orientation
     -------------------------------------------------------------------
     */
    override func viewDidAppear(_ animated: Bool) {
        
        let portraitValue = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(portraitValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
