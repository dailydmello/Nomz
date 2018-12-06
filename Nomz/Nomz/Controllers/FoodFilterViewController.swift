//
//  FoodFilterViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit
import CoreLocation

protocol FoodFilterDelegate {
    func passFilterCriteria () -> [String]
}

class FoodFilterViewController: UIViewController,UITextFieldDelegate{
    
    var criteria = [String]()
    var location: CLLocation?
    var latitude: String = " "
    var longitude: String = " "
    var address: String = " "
    var radius: String = " "
    
    @IBOutlet weak var findFoodButton: UIButton!    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        radiusTextField.delegate = self
        setupViews()
        
//        for familyName:String in UIFont.familyNames {
//            print("Family Name: \(familyName)")
//            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
//                print("--Font Name: \(fontName)")
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    func setupViews(){
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    tabBarController?.tabBar.backgroundImage = UIImage()
    tabBarController?.tabBar.shadowImage = UIImage()
    tabBarController?.tabBar.backgroundColor = UIColor.clear
    tabBarController?.tabBar.isTranslucent = true
    tabBarController?.tabBar.layer.borderWidth = 1.2
    tabBarController?.tabBar.layer.borderColor = UIColor.white.cgColor
    //tabBarController?.tabBar.clipsToBounds = true
    setupTabBarSeparators()
    //tabBarController?.tabBar.layer.
    findFoodButton.layer.borderColor = UIColor.black.cgColor
    findFoodButton.layer.borderWidth = 1.2
        

    }
    
    func setupTabBarSeparators() {
        let itemWidth = (tabBarController?.tabBar.frame.width)! / CGFloat(2)
        
        // this is the separator width.  0.5px matches the line at the top of the tab bar
        let separatorWidth: CGFloat = 1.9
        
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...1 {
            // make a new separator at the end of each tab bar item
            //let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: tabBarController?.tabBar.frame.height)
            
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: (tabBarController?.tabBar.frame.height)!))
            
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = UIColor.white
            
            tabBarController?.tabBar.addSubview(separator)
        }
    }
    
    func getCoordinates(completion: @escaping (_: CLLocation) -> ()){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("location not found")
                    return
            }
            //self.location = location
            completion(location)
        }
    }
    
    @IBAction func unwindWithSegue (_ segue: UIStoryboardSegue){
        //each time the user taps the save or cancel bar button item in CalculationViewController, update calculations array in ListCalcTableViewController
    }
    
    @IBAction func FindFoodButtonTapped(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let address = addressTextField.text{
            self.address = address
            getCoordinates {location in
                self.latitude = String(location.coordinate.latitude)
                self.longitude = String(location.coordinate.longitude)
            }
        }else{print("unable to retrieve")}
        
        if let radius = radiusTextField.text{
            self.radius = String(radius)
            
        }else{print("unable to retrieve")}
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        switch identifier{
        case "displaySwipeScreen":
            //print("triggered")
            if let swipeFoodViewController = segue.destination as? SwipeFoodViewController{
                swipeFoodViewController.delegate = self
            }
        default:
            print("Unexpected segue identifier")
        }
    }
}

extension FoodFilterViewController: FoodFilterDelegate, UITabBarDelegate{
    func passFilterCriteria() -> [String] {
        self.criteria.removeAll()
        self.criteria.append(latitude)
        self.criteria.append(longitude)
        self.criteria.append(radius)
        return self.criteria
    }
    
    
}
