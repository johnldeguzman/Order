//
//  Router.swift
//  Order
//
//  Created by John De Guzman on 2016-12-09.
//  Copyright © 2016 John De Guzman. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible{
    case getLocation(orderId:Int)
    case createOrder()

    var baseURL: String{
       return ApplicationConstants.ServerConnection.productionURL.apiURL
    }
    
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .getLocation:
            return "trackOrder"
        case .createOrder:
            return "createOrder"
        
        }
    }
    
    
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
//        urlRequest.addValue(apiKey, forHTTPHeaderField: "api-key")
        urlRequest.httpMethod = method.rawValue
        var parameter = [String:Any]()
        
        
        switch self {
            
        case .createOrder:
            parameter = [:]
            
        case .getLocation(let orderId):
            
            parameter = ["orderId": orderId]
            
            
        }
        
         urlRequest = try URLEncoding.default.encode(urlRequest, with: parameter)
        return urlRequest
        
        
    }
}
