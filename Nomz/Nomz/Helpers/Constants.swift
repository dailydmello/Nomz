//
//  Constants.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-12-10.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct JsonParseBy{
        static let businesses = "businesses"
    }
    
    struct Segue {
        //FILL IN
    }
    
    struct CellIdentifiers {
        //FILL IN
    }
    
    struct APICall{
        static let APIKey = "Bearer gdZKkWA2rnjxQl3EAZx-EhdLNlWcds2PD6_5exVwwjEGX3LjYmmB6LrBQSdDa8nPJ1BEzXlVQFxassXubpwUN_58JZF7mek5MtTocSK5icJAhjRn2Ru1bPY1CVbiW3Yx"
        static let APIHost = "https://api.yelp.com"
        static let searchPath = "/v3/businesses/search?"
        static let authorization = "authorization"
        static let cacheControl = "Cache-Control"
        static let noCache = "no-cache"
        static let get = "GET"
        static func getBusinesses(radius: String, latitude: String, longitude: String) -> String{
            let urlString = "\(APICall.APIHost)\(APICall.searchPath)term=food&radius=\(radius)&latitude=\(latitude)&longitude=\(longitude)"
            return urlString
            //"https://api.yelp.com/v3/businesses/search?radius=\(self.radius)&latitude=\(self.latitude)&longitude=\(self.longitude)"
        }
    }
    
//    static func getBusinesses(radius: String, latitude: String, longitude: String) -> String{
//        let urlString = "\(APICall.APIHost)\(APICall.searchPath)radius=\(radius)&latitude=\(latitude)&longitude=\(longitude)"
//        return urlString
//        //"https://api.yelp.com/v3/businesses/search?radius=\(self.radius)&latitude=\(self.latitude)&longitude=\(self.longitude)"
//    }
    
}
