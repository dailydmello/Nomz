//
//  Food.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-08.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation

struct PlaceHolder: Decodable {
    let businesses:[JSONBusiness]
    
    enum CodingKeys: String, CodingKey {
        case businesses = "businesses"
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        var businessTemp = try rootContainer.nestedUnkeyedContainer(forKey: .businesses)
        var allBusinesses: [JSONBusiness] = []
        
        while !businessTemp.isAtEnd{
            let jsonBusiness = try businessTemp.decode(JSONBusiness.self)
            allBusinesses.append(jsonBusiness)
        }
        businesses = allBusinesses
    }
}

struct JSONBusiness: Decodable{
    
    let restaurantId: String?
    let restaurantName: String?
    let foodImageUrl: String?
    let rating: Double?
    let price: String?
    let distance: Double?
    let yelpUrl: String?
    
    enum CodingKeys: String, CodingKey{
        case rating
        case price
        case distance
        case restaurantId = "id"
        case restaurantName = "name"
        case foodImageUrl = "image_url"
        case yelpUrl = "url"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.restaurantId = try values.decode(String.self, forKey: .restaurantId)
        self.restaurantName = try values.decode(String.self, forKey: .restaurantName)
        self.foodImageUrl = try values.decode(String.self, forKey: .foodImageUrl)
        self.yelpUrl = try values.decode(String.self, forKey: .yelpUrl)
        self.rating = try values.decode(Double.self, forKey: .rating)
        self.price = try values.decode(String.self, forKey: .price)
        self.distance = try values.decode(Double.self, forKey: .distance)
    }
    
}


