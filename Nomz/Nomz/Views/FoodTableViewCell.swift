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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.lightText
        self.restaurantName.numberOfLines = 0
        self.restaurantName.lineBreakMode = .byWordWrapping
        self.foodImageView.layer.borderColor = UIColor.white.cgColor
        self.foodImageView.layer.borderWidth = 1.2
    }
    
}
