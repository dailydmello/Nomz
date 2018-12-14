//
//  LaunchScreenViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-12-12.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
                for familyName:String in UIFont.familyNames {
                    print("Family Name: \(familyName)")
                    for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                        print("--Font Name: \(fontName)")
                    }
                }
//        let customFont = UIFont(name: "Custom Font Name", size: UIFont.systemFontSize)
//        let customLabel = UILabel()
//        customLabel.font = customFont
    }
    
    
}
