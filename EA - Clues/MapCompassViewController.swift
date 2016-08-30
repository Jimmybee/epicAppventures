//
//  MapCompassViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapCompassViewController: UIViewController, CLLocationManagerDelegate {
    
    lazy var stepCoordinate = kCLLocationCoordinate2DInvalid
    lazy var showCompass = false
    lazy var showLocation = false
    lazy var showDistance = false
    lazy var locationName = ""
    
    var firstLocationUpdate = true
    
    
    @IBOutlet weak var showLocationButton: UIButton!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            mapView.myLocationEnabled = true
        }
    }

    
    let locationManager = CLLocationManager()
    var lastLocation = CLLocation()
    var compassImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.delegate = self

        updateLocations()
        // Do any additional setup after loading the view.
    }
    
    func setup() {
        firstLocationUpdate = true
        mapView.clear()
        if showLocation {
            addLocationMarker()
            showLocationButton.alpha = 1
        } else {
            showLocationButton.alpha = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: MapLocation
    func updateLocations() {
//        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocation = locations.last!
        if firstLocationUpdate {
            centerOnUser(self)
        }
        firstLocationUpdate = false
        if let pvc = self.parentViewController as? StepViewController   {
            pvc.updateLastLocation(lastLocation)
        }
        if showDistance {calculateDistanceCallParent()}
        if showCompass {compassUpdate()}
    }
    
    //MARK: Marker for Map
    func addLocationMarker () {
        
        let marker = GMSMarker(position: stepCoordinate)
        marker.title = locationName
        marker.map = self.mapView
    }
    
    //MARK: Distance calculation
    func calculateDistanceCallParent() {
        if let target = stepCoordinate as CLLocationCoordinate2D! {
            let lat = target.latitude
            let long = target.longitude
            let location = CLLocation(latitude: lat, longitude: long)
            let distance = location.distanceFromLocation(lastLocation)
            if let pvc = self.parentViewController as? StepViewController   {
                pvc.updateLabel(distance, lastLocation: location)
            }
        }
    }
    
    //MARK: Comapass calculation
    func compassUpdate() {
        func degreesToRadians(x: Double) -> Double {
            return (M_PI * x / 180.0)
        }
        func radiansToDegrees(x: Double) -> Double {
            return (x * 180.0 / M_PI)
        }
        
        let fLoc = CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
        let tLoc = CLLocationCoordinate2D(latitude: stepCoordinate.latitude, longitude: stepCoordinate.longitude)
        
        let fLat = degreesToRadians(fLoc.latitude);
        let fLng = degreesToRadians(fLoc.longitude);
        let tLat = degreesToRadians(tLoc.latitude);
        let tLng = degreesToRadians(tLoc.longitude);
        
        var degree = radiansToDegrees(atan2(sin(tLng-fLng)*cos(tLat), cos(fLat)*sin(tLat)-sin(fLat)*cos(tLat)*cos(tLng-fLng)))
        
        if (degree >= 0) {
            
        } else {
            degree = 360+degree
        }
        
        let floaty = CGFloat(degree)
        
        if let pvc = self.parentViewController as? StepViewController {
            pvc.updateCompass(floaty)
        }
        
    }
    @IBAction func centerOnUser(sender: AnyObject) {
        let camera = GMSCameraPosition.cameraWithTarget(lastLocation.coordinate, zoom: 14)
        mapView.animateToCameraPosition(camera)
    }

    @IBAction func showLocation(sender: AnyObject) {
        let camera = GMSCameraPosition.cameraWithTarget(stepCoordinate, zoom: 14)
        mapView.animateToCameraPosition(camera)
    }
}
