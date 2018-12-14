//
//  OnboardingViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-12-12.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import UIKit

class OnboardingViewController: UIViewController{
    
    @IBOutlet weak var skipButton: UIButton!
    
    @IBOutlet weak var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        container.layer.cornerRadius = 20
        skipButton.layer.borderWidth = 1.2
        skipButton.layer.borderColor = UIColor.white.cgColor
    }
    
    @IBAction func skipButtonTapped(_ sender: Any) {
        
        UserDefaults.standard.set(Constants.UserDefaults.value, forKey: Constants.UserDefaults.key)
        performSegue(withIdentifier: Constants.Segue.toMain, sender: self)
        
    }
}
