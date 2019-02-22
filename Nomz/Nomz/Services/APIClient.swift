//
//  APIClient.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Gloss

typealias FetchFoodCallback = ([JSONBusiness]?) -> Void

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
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest){ data, response, error in
            
            if error != nil{
                print("url session failed: \(String(describing: error?.localizedDescription))")
            }
            
            if let data = data{
                print(data)
                do {
                    
//                    let jsonArray = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions (rawValue:0)) as! [String:Any]
//                    let businessJsonArray = jsonArray[Constants.JsonParseBy.businesses] as! [String:Any]
//                    let json = businessJsonArray.da

                    let decoder = JSONDecoder()
                    let foodData = try decoder.decode(PlaceHolder.self, from: data)
                    print(foodData.businesses)
                    //print(foodData.restaurantName ?? "Empty Name")
//
//                    let foods = businessJsonArray.map({JSONFood.init(from: $0)})
//
//                    if let foods = foods {
//                        DispatchQueue.main.async {
//                            completion(foods)
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            completion(nil)
//                        }
//                        print("Businesses could not be parsed in API Client")
//                    }
                }
                catch{
                    print("json error: \(error)")
                    //print("json error: \(error.localizedDescription)")
                }
            }else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        dataTask.resume()
    }
}
