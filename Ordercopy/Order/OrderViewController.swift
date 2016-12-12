//
//  OrderViewController.swift
//  Order
//
//  Created by John De Guzman on 2016-12-11.
//  Copyright © 2016 John De Guzman. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class OrderViewController: UIViewController{
    
    var locationManager: CLLocationManager!
    @IBOutlet weak var map: MKMapView!
    @IBAction func checkOut(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: Notification.Name("showOverlayView"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.showsUserLocation = true
        setupLocationManager()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension OrderViewController: CLLocationManagerDelegate {
    func setupLocationManager(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
}
}
