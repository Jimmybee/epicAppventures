//
//  AppventureRest.swift
//  EA - Clues
//
//  Created by James Birtwell on 18/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import Alamofire

extension Appventure {
    
    func postRequestAlamo() {
        let headers = ["application-id" : "975C9B70-4090-2D14-FFB1-BA95CB96F300", "secret-key" : "EEE8A10A-F7FC-955E-FF84-EE35BF400800" , "application-type" : "REST", "Content-Type" : "application/json"]
        let url = "https://api.backendless.com/v1/data/Appventures"
        let parameters: Parameters = [
            "title": title ?? "[title]",
//            "keyFeatures" : keyFeatures ?? ["keyFeatures"],
        ]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response.request!)
            print(response.result)
            print(response.response!)
        }
    }

    
}

class BackendlessRest {
    
    
    func postRequest() {
        let urlString = "https://mashape-community-urban-dictionary.p.mashape.com/define?term=hipster"
        if let url = NSURL(string: urlString) {
            let URLRequest = NSMutableURLRequest(url: url as URL)
            URLRequest.setValue("975C9B70-4090-2D14-FFB1-BA95CB96F300", forHTTPHeaderField: "application-id")
            URLRequest.setValue("EEE8A10A-F7FC-955E-FF84-EE35BF400800", forHTTPHeaderField: "secret-key")
            URLRequest.setValue("REST", forHTTPHeaderField: "application-type")
            
            URLRequest.httpMethod = "P"
            Alamofire.request(URLRequest as! URLRequestConvertible).responseJSON { response in
                print(response)
            }
        }
        
        
    }
    
   }
