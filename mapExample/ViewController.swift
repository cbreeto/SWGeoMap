//
//  ViewController.swift
//  mapExample
//
//  Created by Carlos Brito on 26/12/15.
//  Copyright © 2015 Carlos Brito. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    private let manager = CLLocationManager()
    private var locationPrev = CLLocation()
    private var first = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 50.0
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            manager.startUpdatingLocation()
            
            mapView.showsUserLocation = true
            //compass
      //      manager.startUpdatingHeading()
        }
        else {
            manager.stopUpdatingLocation()
            
            mapView.showsUserLocation = false
            //stop compass
       //     manager.stopUpdatingHeading()
        }
    }
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if first == true {
            locationPrev = locations[0]
            first = false
        }
        
        let span = MKCoordinateSpanMake(0.005, 0.005)
        var dot = CLLocationCoordinate2D()
        
        dot.latitude = manager.location!.coordinate.latitude
        dot.longitude = manager.location!.coordinate.longitude
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: dot.latitude, longitude: dot.longitude), span: span)
        //distance
        let distance = locations[0].distanceFromLocation(locationPrev)
        locationPrev = locations[0]
        
        //pin
        let pin = MKPointAnnotation()
        pin.title = "Lat: \(manager.location!.coordinate.latitude) Long: \(manager.location!.coordinate.longitude))"
        pin.subtitle = "Distance: \(distance)"
        pin.coordinate = dot
        print("\(manager.location!.coordinate.latitude)")
        print("\(distance)")
        
        mapView.addAnnotation(pin)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alert = UIAlertController(title: "Error", message: "Error \(error.code)", preferredStyle: .Alert)
        let actionOk = UIAlertAction(title: "Ok", style: .Default, handler: {
            action in
            //..
        })
        alert.addAction(actionOk)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //compass reading
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
       // norteMgn.text = "\(newHeading.magneticHeading)"
       // norteGeo.text = "\(newHeading.trueHeading)"
    }




   

}

