//
//  ViewController.swift
//  Order
//
//  Created by John De Guzman on 2016-12-09.
//  Copyright © 2016 John De Guzman. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON
import SwiftyTimer

class ViewController: UIViewController {

    @IBOutlet weak var generateOrder: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var createOrderLabel: UILabel!
    @IBOutlet weak var hidden: UIView!
    var customAnn: CustomAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
    }

    
    func saveOrderId(Order: Int){
        let userDefaults = UserDefaults.standard
        userDefaults.set(Order, forKey: "OrderId")
        userDefaults.synchronize()
        createOrderLabel.text = "Thank you for creating an order! Your order id is: \(Order)"
        createTimer()
    }
    
    func createTimer(){
        Timer.every(3.seconds, { [unowned self] in
        
        self.trackOrder()
        
        })
    }
    
    func refreshMap(Location: (Double?, Double?)){
       
        
        if Location.1 != nil {
       
            if map.annotations.count == 0 {
                
            
            customAnn = CustomAnnotation(location: CLLocationCoordinate2D(latitude: Location.1!, longitude: Location.0!))
            map.addAnnotation(customAnn)
            
            }else {
               
                for all in map.annotations{
                    UIView.animate(withDuration: 0.7, animations: {
                    let point = all as! CustomAnnotation
                    point.coordinate = CLLocationCoordinate2D(latitude: Location.1!, longitude: Location.0!)
                        })
                }
                
               
            }
            let latitude = Location.1
            let longitude = Location.0
            let latDelta: CLLocationDegrees = 0.01
            let lonDelta: CLLocationDegrees = 0.01
            let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            map.setRegion(region, animated: true)
            
        }else {
            
        }
        
        
    }
    
    @IBAction func Add(_ sender: UIButton) {
        
        OrderManager().createOrder({[unowned self] orderId in
        
            self.saveOrderId(Order: orderId)
        
        })
    }

    func trackOrder(){
        OrderManager().trackOrder({[unowned self] location in
        
        print(location)
            if location.1 != nil{
                let longitude = Double(location.0!)
                let latitude = Double(location.1!)
                let locationDouble = (latitude, longitude)
                self.refreshMap(Location: locationDouble)
            }else {
                self.refreshMap(Location:(nil, nil))
        
        }
        })
        
    }
    
    
    

}

