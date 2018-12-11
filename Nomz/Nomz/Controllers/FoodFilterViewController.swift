//
//  FoodFilterViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit

protocol FoodFilterDelegate {
    func passFilterCriteria () -> [String]
}

class FoodFilterViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate{
    
    var criteria = [String]()
    var latitude: String = " "
    var longitude: String = " "
    var address: String = " "
    var radius: String = " "
    var locationManager = CLLocationManager()
    var emptyLabel = UILabel()

    
    @IBOutlet weak var findFoodButton: UIButton!    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //permission requests for location manager
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //keyboard to disappear
        addressTextField.delegate = self
        radiusTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupViews()
    }
    
    func setupViews(){
    //Top nav bar customizations
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
        
    //bottom tab bar customizations
    tabBarController?.tabBar.backgroundImage = UIImage()
    tabBarController?.tabBar.shadowImage = UIImage()
    tabBarController?.tabBar.backgroundColor = UIColor.clear
    tabBarController?.tabBar.isTranslucent = true
    tabBarController?.tabBar.layer.borderWidth = 1.2
    tabBarController?.tabBar.layer.borderColor = UIColor.white.cgColor
    
    //line seperating tab bars implementation
    setupTabBarSeparators()
        
    findFoodButton.layer.borderColor = UIColor.black.cgColor
    findFoodButton.layer.borderWidth = 1.75
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate else {
            print("not location received")
            return
        }
        latitude = String(location.latitude)
        longitude = String(location.longitude)
        //print("locations = \(location.latitude) \(location.longitude)")
        reverseGeocoder(latitude: latitude, longitude: longitude)
        locationManager.stopUpdatingLocation()
    }
    
    //generate address based on longitude and latitude
    func reverseGeocoder(latitude: String, longitude: String) {
        
        // struct for implementing geocoder
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = Double(latitude) ?? 0
        coordinate.longitude = Double(longitude) ?? 0
        
        let conversionManager = CLGeocoder()
        let location = CLLocation(latitude:coordinate.latitude, longitude: coordinate.longitude)
        
        conversionManager.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil{
                print("reverse geocode failed: \(error?.localizedDescription)")
            }
            
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                let addressString = "\(placemark.subThoroughfare!) \(placemark.thoroughfare!), \(placemark.locality!)"
                self.addressTextField.text = addressString
            }else{
                self.addressTextField.text = "Address Unknown"
            }
        }
    }
    
    func getCoordinatesFromAddress(completion: @escaping (CLLocation) -> ()){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("location not found")
                    return
            }
            completion(location)
        }
    }
    
    
    func setupTabBarSeparators() {
        let itemWidth = ((tabBarController?.tabBar.frame.width)!) / CGFloat(2)
        
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
    
    @IBAction func unwindWithSegue (_ segue: UIStoryboardSegue){
        //each time the user taps the save or cancel bar button item in CalculationViewController, update calculations array in ListCalcTableViewController
    }
    
    @IBAction func FindFoodButtonTapped(_ sender: Any) {
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if let address = addressTextField.text{
            self.address = address
            
            getCoordinatesFromAddress{location in
                self.latitude = String(location.coordinate.latitude)
                self.longitude = String(location.coordinate.longitude)
            }
            
        }else{print("unable to retrieve")}
        
        if let radius = radiusTextField.text, let radiusDouble = Double(radius){
            //convert to meters
            let radiusM = (radiusDouble * 1000)
            let radiusMStirng = String(radiusM).dropLast(2)
            self.radius = String(radiusMStirng)
            
        }else{print("unable to retrieve")}
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        switch identifier{
        case "displaySwipeScreen":
            emptyLabel.removeFromSuperview()
            if let swipeFoodViewController = segue.destination as? SwipeFoodViewController{
                swipeFoodViewController.delegate = self
            }
        default:
            print("Unexpected segue identifier")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if radiusTextField.text!.isEmpty || addressTextField.text!.isEmpty{
            emptyLabel = UILabel(frame: CGRect(x:0, y: self.view.frame.height * 0.60, width: self.view.frame.width, height: 30))
            emptyLabel.backgroundColor = UIColor.clear
            emptyLabel.textColor = UIColor.white
            emptyLabel.adjustsFontSizeToFitWidth = true
            emptyLabel.textAlignment = .center
            emptyLabel.text = "Address or distance empty"
            emptyLabel.font = UIFont(name: "GillSans", size: 22)
            self.view.addSubview(emptyLabel)
            return false
            
        }

        return true
    }
}

extension FoodFilterViewController: FoodFilterDelegate{
    
    func passFilterCriteria() -> [String] {
        self.criteria.removeAll()
        self.criteria.append(latitude)
        self.criteria.append(longitude)
        self.criteria.append(radius)
        return self.criteria
    }    
    
}
