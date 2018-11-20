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
    
    init?(json: JSON) {
        self.restaurantId = "id" <~~ json
        self.restaurantName = "name" <~~ json
        self.imageUrl = "image_url" <~~ json
    }
    
}
