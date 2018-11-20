//
//  FoodFilterViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit

class FoodFilterViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIClient().fetchFood{result in
        print(result)
        }
    }
    
}
