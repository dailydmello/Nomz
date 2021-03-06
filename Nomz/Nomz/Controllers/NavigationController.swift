//
//  NavigationController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-12-12.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import UIKit

class NavigationController: UINavigationController{
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.preferredStatusBarStyle ?? .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
