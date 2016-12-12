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
import FlexibleSteppedProgressBar
import Presentr
import NVActivityIndicatorView
class ViewController: UIViewController {
    @IBOutlet weak var LabelofOrder: UILabel!

    @IBOutlet weak var hide: UIView!
    @IBOutlet weak var activity: NVActivityIndicatorView!
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var generateOrder: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var hidden: UIView!
    var customAnn: CustomAnnotation!
    var presenter: Presentr!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        map.showsUserLocation = true
        progressBar.numberOfPoints = 3
        progressBar.lineHeight = 5
        progressBar.radius = 10
        progressBar.progressRadius = 8
        progressBar.progressLineHeight = 2
        progressBar.stepTextColor = UIColor.lightGray
        progressBar.currentSelectedTextColor = UIColor.colorFromRGB(0x404992)
        progressBar.selectedBackgoundColor = UIColor.colorFromRGB(0x404992)
        progressBar.delegate = self
        map.delegate = self
//        map.showsUserLocation = true
        hide.isHidden = true
        let width = ModalSize.custom(size: 300)
        let height = ModalSize.custom(size: 300)
        let modalcenterPosition = ModalCenterPosition.center
        let customType = PresentationType.custom(width: width, height: height, center: modalcenterPosition)
        
        
        
        presenter = {
            let presenter = Presentr(presentationType: customType)
            //                presenter.transitionType = .coverVerticalFrom
            presenter.roundCorners = true
            return presenter
        }()
        
        let defaults = UserDefaults.standard
        let orderId = defaults.object(forKey: "OrderId")
        
        if orderId != nil {
          self.createTimer()
            LabelofOrder.text = "Order Id: \(orderId!)"
            
        }else{
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "order") as! OrderViewController
        customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
       
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.showOverlayView), name: Notification.Name("showOverlayView"), object: nil)
        }
        self.navigationController?.isNavigationBarHidden = true
        
    }

    
    func showOverlayView(){
    
        hide.isHidden = false
        activity.type = .ballTrianglePath
        activity.startAnimating()
        
        
        OrderManager().createOrder({[unowned self] orderId in
            
            self.saveOrderId(Order: orderId)
            
        })

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
        LabelofOrder.text = "Order Id: \(Order)"
        createTimer()
    }
    
    func createTimer(){
        Timer.every(3.seconds, { [unowned self] in
        
        self.trackOrder()
        
        })
    }
    
    func refreshMap(Location: (Double?, Double?)){
       
        
        if Location.1 != nil {
            hide.isHidden = true
       progressBar.currentIndex = 1
            if map.annotations.count == 0 {
                
            
            customAnn = CustomAnnotation(location: CLLocationCoordinate2D(latitude: Location.1!, longitude: Location.0!))
            customAnn.image = "ufo-512"
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
            hide.isHidden = false
            activity.type = .ballTrianglePath
            activity.startAnimating()
           
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

extension ViewController:  FlexibleSteppedProgressBarDelegate {

    
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
  
        
        
        if position == FlexibleSteppedProgressBarTextLocation.top {
            switch index {
                
            case 0: return "Preparing Order"
            case 1: return "Order in Transit"
            case 2: return "Delivered"
            case 3: return "In Transit"
            case 4: return "Delivered"
            default: return "Date"
                
            }
        }
        return ""
    }

    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
//        if index > maxIndex {
//            maxIndex = index
//            progressBar.completedTillIndex = maxIndex
//        }
    }

    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView?.canShowCallout = false
        } else {
            annotationView?.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomAnnotation
        annotationView?.image = UIImage(named: customPointAnnotation.image)
        
        return annotationView
    }
}


