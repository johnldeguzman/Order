//
//  CreateOrder.swift
//  Order
//
//  Created by John De Guzman on 2016-12-09.
//  Copyright © 2016 John De Guzman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderManager{

    
    func createOrder(_ completionHandler:@escaping (Int) -> ()){
        let networkManager = NetworkManager()
        networkManager.manager!.request(Router.createOrder()).validate(statusCode: 200..<300).responseJSON{ response in
            

            switch response.result{
            case .success:
                let json = JSON(response.result.value!)
                let orderId = json["orderId"].intValue
                completionHandler(orderId)
            case .failure:
                print("failure")
                
            }
         
            networkManager.manager?.session.invalidateAndCancel()
        }
        
    }
    
    func trackOrder(_ completionHandler:@escaping ((String?, String?)) -> ()){
        
        let userDefaults = UserDefaults.standard
        let orderId = userDefaults.integer(forKey: "OrderId")
         let networkManager = NetworkManager()
        networkManager.manager!.request(Router.getLocation(orderId:orderId)).validate(statusCode: 200..<300).responseJSON{ response in
            
            switch response.result{
         
            case .success:
                let json = JSON(response.result.value!)
                let latitude = json["latitude"].string
                let longitude = json["longitude"].string
                completionHandler(latitude, longitude)
            case .failure:
                print("failure")
            }
         networkManager.manager?.session.invalidateAndCancel()   
        }
        
    }

    
}


class NetworkManager {
    
    var manager: SessionManager?
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        manager = Alamofire.SessionManager(configuration: configuration)
    }
}



