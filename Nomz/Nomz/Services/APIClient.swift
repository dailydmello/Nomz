//
//  APIClient.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Gloss

typealias FetchFoodCallback = ([JSONFood]?) -> Void

struct APIClient{
    
    static func fetchFood(latitude: String, longitude: String, radius: String, completion:@escaping FetchFoodCallback) {
        
        //headers for yelp API authentication
        let headers = [
            Constants.APICall.authorization : Constants.APICall.APIKey,
            Constants.APICall.cacheControl : Constants.APICall.noCache,
            ]
   
        let request = NSMutableURLRequest(url: NSURL(string: Constants.APICall.getBusinesses(radius: radius, latitude: latitude, longitude: longitude))! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
 
        request.httpMethod = Constants.APICall.get
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if let data = data{
                let jsonArray = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions (rawValue:0)) as! [String:Any]
                print(jsonArray)
                let businessJsonArray = jsonArray[Constants.JsonParseBy.businesses] as! [Dictionary<String,AnyObject>]
                let foods = [JSONFood].from(jsonArray: businessJsonArray)
                print(foods?.count)
                if let foods = foods {
                    DispatchQueue.main.async {
                        completion(foods)
                    }
                }else{
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    print("Businesses could not be parsed")
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
