//
//  Constants.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-12-10.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation

struct Constants {
    struct JsonParseBy{
        static let businesses = "businesses"
    }
    
    struct StoryBoardIdentifier{
        static let main = "Main"
    }
    
    struct Segue {
        static let toMain = "toMain"
    }
    
    struct UserDefaults{
        static let key = "OnboardScreenShown"
        static let value = "true"
    }
    
    struct ViewControllerIdentifiers {
        static let onboardingViewController = "OnboardingViewController"
        static let onboardingViewController1 = "OnboardingViewController1"
        static let onboardingViewController2 = "OnboardingViewController2"
        static let onboardingViewController3 = "OnboardingViewController3"
        static let onboardingViewController4 = "OnboardingViewController4"
    }
    
    struct CoreData{
        static let entityName = "SwipedFood"
        
    }
    
    struct ImageNames{
        static let thumbDown = "ThumbDown"
        static let pizza = "pizza"
        static let noImageAvailable = "no_image_available"
    }
    
    struct GillSans{
        static let semiBold = "GillSans-Semibold"
        static let regular = "GillSans"
    }
    
    struct CellIdentifier{
        static let foodTableViewCell = "foodTableViewCell"
    }
    
    struct JSON{
        static let filterId = "Id"
        static let filterName = "name"
        static let filterImageUrl = "image_url"
        static let filterRating = "rating"
        static let filterPrice = "price"
        static let filterDistance = "distance"
        static let filterUrl = "url"
    }
    
    struct APICall{
        static let APIKey = "Bearer gdZKkWA2rnjxQl3EAZx-EhdLNlWcds2PD6_5exVwwjEGX3LjYmmB6LrBQSdDa8nPJ1BEzXlVQFxassXubpwUN_58JZF7mek5MtTocSK5icJAhjRn2Ru1bPY1CVbiW3Yx"
        static let APIHost = "https://api.yelp.com"
        static let searchPath = "/v3/businesses/search?"
        static let authorization = "authorization"
        static let cacheControl = "Cache-Control"
        static let noCache = "no-cache"
        static let get = "GET"
        static let endPointLimit = "limit=50"
        static let endPointTerm = "term=food"
        
        static func getBusinesses(radius: String, latitude: String, longitude: String) -> String{
            let urlString = "\(APICall.APIHost)\(APICall.searchPath)\(endPointLimit)&\(endPointTerm)&radius=\(radius)&latitude=\(latitude)&longitude=\(longitude)"
            //print(urlString)
            return urlString
            //"https://api.yelp.com/v3/businesses/search?radius=\(self.radius)&latitude=\(self.latitude)&longitude=\(self.longitude)"
        }
    }    
}

