//
//  Food.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-08.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import Gloss

struct JSONFood: JSONDecodable {
    
    let restaurantId: String?
    let restaurantName: String?
    let imageUrl: String?
    let rating: Double?
    let price: String?
    let distance: Double?
    let yelpURL: String?
    
    init?(json: JSON) {
        self.restaurantId = Constants.JSON.filterId <~~ json
        self.restaurantName = Constants.JSON.filterName <~~ json
        self.imageUrl = Constants.JSON.filterImageUrl <~~ json
        self.rating = Constants.JSON.filterRating <~~ json
        self.price = Constants.JSON.filterPrice <~~ json
        self.distance = Constants.JSON.filterDistance <~~ json
        self.yelpURL = Constants.JSON.filterUrl <~~ json
    }
    
}
