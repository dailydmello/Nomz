//
//  FoodTableViewCell.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-08.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import UIKit

class FoodTableViewCell: UITableViewCell{
    
    @IBOutlet weak var foodImageView: UIImageView!
    
    @IBOutlet weak var restaurantName: UILabel!
    
    @IBOutlet weak var priceLevel: UILabel!
    
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var rating: UILabel!
}
