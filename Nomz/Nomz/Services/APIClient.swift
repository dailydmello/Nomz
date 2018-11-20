//
//  APIClient.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Gloss

typealias FetchFoodCallback = ([JSONFood]?) -> Void

class APIClient{
    var apiHost = "https://api.yelp.com"
    var searchPath = "/v3/businesses/search"
    var businesPath = "/v3/businesses/"
    
    let apiKey = "gdZKkWA2rnjxQl3EAZx-EhdLNlWcds2PD6_5exVwwjEGX3LjYmmB6LrBQSdDa8nPJ1BEzXlVQFxassXubpwUN_58JZF7mek5MtTocSK5icJAhjRn2Ru1bPY1CVbiW3Yx"
    var businessID = "yelp-san-francisco"
    var term = "dinner"
    var location = "New York, NY"
    var limit = 5
    
    func fetchFood(completion: @escaping FetchFoodCallback) {
        let headers = [
            "Authorization": "Bearer gdZKkWA2rnjxQl3EAZx-EhdLNlWcds2PD6_5exVwwjEGX3LjYmmB6LrBQSdDa8nPJ1BEzXlVQFxassXubpwUN_58JZF7mek5MtTocSK5icJAhjRn2Ru1bPY1CVbiW3Yx",
            "Cache-Control": "no-cache",
            ]
        let request = NSMutableURLRequest(url: NSURL(string: "https://api.yelp.com/v3/businesses/search?radius=700&location=11-Delawana-Drive-Scarorough")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let data = data{
                let jsonArray = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions (rawValue:0)) as! [String:Any]
                let businessJsonArray = jsonArray["businesses"] as! [Dictionary<String,AnyObject>]
                let foods = [JSONFood].from(jsonArray: businessJsonArray)
                if let foods = foods {
                    DispatchQueue.main.async {
                        completion(foods)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    print("Trips could not be parsed")
                }
            }else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        })
        dataTask.resume()
    }
}
