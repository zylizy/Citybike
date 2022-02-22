//
//  ShowBikeStationOnMapViewController.swift
//  CityBikes
//
//  Created by Thoang Tran on 11/18/18.
//  Copyright © 2018 Thoang Tran. All rights reserved.
//

import UIKit
import MapKit


class ShowBikeStationOnMapViewController: UIViewController, MKMapViewDelegate {

    var bikeStationPassed = [Any]()
    var searchLocationPassedToMap: CLLocationCoordinate2D!
    
    @IBOutlet var mapView: MKMapView!
    
    // The amount of north-to-south distance (measured in meters) to use for the span.
    let latitudinalSpanInMeters: Double = 804.672    // = 0.5 mile
    
    // The amount of east-to-west distance (measured in meters) to use for the span.
    let longitudinalSpanInMeters: Double = 804.672   // = 0.5 mile
    
    var longtitudePassed: Double?
    var latitudePassed: Double?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        longtitudePassed = bikeStationPassed[0] as? Double
        latitudePassed = bikeStationPassed[1] as? Double
        
        // Do any additional setup after loading the view.
        self.title = bikeStationPassed[3] as? String
        
        showMap()

        // Prepare to obtain direction
        let directionsRequest = MKDirections.Request()
        
        directionsRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: searchLocationPassedToMap, addressDictionary: nil))
        
        directionsRequest.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitudePassed!, longitude: longtitudePassed!), addressDictionary: nil))
        
        directionsRequest.requestsAlternateRoutes = false
        
        directionsRequest.transportType = .walking
        
        let directions = MKDirections(request: directionsRequest)
        
        directions.calculate { [unowned self] response, error in guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                self.mapView.mapType = MKMapType.standard
            }
        }
    }
    
    /*
     ------------------------------------------
     MARK: - MKMapViewDelegate Protocol Methods
     ------------------------------------------
     */
    
    /*
     Asks the delegate for a renderer object to use when drawing the specified overlay. [Apple]
     mapView    --> The map view that requested the renderer object.
     overlay    --> The overlay object that is about to be displayed.
     */
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        /*
         Instantiate a MKPolylineRenderer object for visual polyline representation
         of the directions to be displayed as an overlay on top of the map.
         */
        let polylineRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        
        // Dress up the polyline for visual representation of directions
        polylineRenderer.strokeColor = UIColor.blue
        polylineRenderer.lineWidth = 2.0
        
        return polylineRenderer
    }
    

    func showMap() {
        
        let centerLocation = CLLocationCoordinate2D(latitude: bikeStationPassed[1] as! Double, longitude: bikeStationPassed[0] as! Double)
        let mapRegion: MKCoordinateRegion = MKCoordinateRegion(center: centerLocation, latitudinalMeters: latitudinalSpanInMeters, longitudinalMeters: longitudinalSpanInMeters)
        
        mapView.setRegion(mapRegion, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerLocation
        annotation.title = bikeStationPassed[3] as? String
        annotation.subtitle = bikeStationPassed[6] as? String
        
        mapView.addAnnotation(annotation)
        
    }
    
    /*func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
        // Starting to load the map. Show the animated activity indicator in the status bar
        // to indicate to the user that the map view object is busy loading the map.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        // Finished loading the map. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        
        // An error occurred during the map load. Hide the activity indicator in the status bar.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        /*
         Create a UIAlertController object; dress it up with title, message, and preferred style;
         and store its object reference into local constant alertController
         */
        let alertController = UIAlertController(title: "Unable to Load the Map!",
                                                message: "Error description: \(error.localizedDescription)",
            preferredStyle: UIAlertController.Style.alert)
        
        // Create a UIAlertAction object and add it to the alert controller
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }*/

}
