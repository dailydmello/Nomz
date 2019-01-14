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
    func foodSearchParams () -> ([String:String])
}

class FoodFilterViewController: UIViewController,UITextFieldDelegate,CLLocationManagerDelegate, FoodFilterDelegate{
    
    var criteria = [String]()
    var latitude: String = ""
    var longitude: String = ""
    var address: String?
    var radius: String = " "
    var radiusM: Double = 0
    var locationManager = CLLocationManager()
    var emptyLabel = UILabel()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    @IBOutlet weak var findFoodButton: UIButton!    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //setup for location services
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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
    navigationController?.navigationBar.tintColor = .white
        
    //bottom tab bar customizations
    tabBarController?.tabBar.backgroundImage = UIImage()
    tabBarController?.tabBar.shadowImage = UIImage()
    tabBarController?.tabBar.backgroundColor = UIColor.lightText
    tabBarController?.tabBar.tintColor = UIColor.black
    tabBarController?.tabBar.isTranslucent = true
    tabBarController?.tabBar.layer.borderWidth = 1.2
    tabBarController?.tabBar.layer.borderColor = UIColor.black.cgColor
    
    //line seperating tab bars implementation
    setupTabBarSeparators()
        
    findFoodButton.layer.borderColor = UIColor.black.cgColor
    findFoodButton.layer.borderWidth = 1.75
    }
    
    @IBAction func locationButtonTapped(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled(){
            //print("location services enabled")
        }else{
            //print warning to user
            //print("location services not enabled")
        }
        
        if let address = address{
            self.addressTextField.text = address
        }else{
            print("address is nil")
        }
    }
    
    func foodSearchParams() -> ([String : String]) {
        let params = ["latitude":latitude,"longitude":longitude,"radius":radius]
        return params
    }
    
    //get location using auto locate feature
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            //to stop multiple longs and lats, locmanager takes time to shutdown
            //locationManager.delegate = nil
            
            latitude = String(location.coordinate.latitude)
            longitude = String(location.coordinate.longitude)
            
            reverseGeocoder(location: location)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        
    }
    
    //turn address
    func reverseGeocoder(location: CLLocation) {
        
        let geocoderManager = CLGeocoder()
        
        geocoderManager.reverseGeocodeLocation(location) { (placemarks, error) in
            
            if error != nil{
                print("reverse geocode failed: \(String(describing: error?.localizedDescription))")
                self.addressTextField.text = "Address Unknown"
            }
            
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                if (placemark.subThoroughfare != nil) || (placemark.thoroughfare != nil) || (placemark.locality != nil){
                    let subThroughfare = placemark.subThoroughfare ?? "Sub Thoroughfare Unknown"
                    let throughFare = placemark.thoroughfare ?? "Thoroughfare Unknown"
                    let locality = placemark.locality ?? "Locality Unknown"
                    
                    self.address = "\(subThroughfare) \(throughFare) \(locality)"
    
                }else{
                    self.addressTextField.text = "Address Unknown"
                    //print warning to user that autolocate not working, enter manually
                }
            }else{
                self.addressTextField.text = "Address Unknown"
            }
        }
    }
    
    
    func getCoordinatesFromAddress(address: String,completion: @escaping (CLLocation) -> ()){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            if error != nil{
                print("getCoordinatesFromAddress failed: \(String(describing: error?.localizedDescription))")
            }
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
        let separatorWidth: CGFloat = 1.2
        
        // iterate through the items in the Tab Bar, except the last one
        for i in 0...1 {
            // make a new separator at the end of each tab bar item
            //let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: tabBarController?.tabBar.frame.height)
            
            let separator = UIView(frame: CGRect(x: itemWidth * CGFloat(i + 1) - CGFloat(separatorWidth / 2), y: 0, width: CGFloat(separatorWidth), height: (tabBarController?.tabBar.frame.height)!))
            
            // set the color to light gray (default line color for tab bar)
            separator.backgroundColor = UIColor.black
            
            tabBarController?.tabBar.addSubview(separator)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        setLatitudeLongitudeRadius()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.resignFirstResponder()
        //calling this uses memory, specifically corelocation
        setLatitudeLongitudeRadius()
    }
    
    func setLatitudeLongitudeRadius(){
        if let address = addressTextField.text{
            getCoordinatesFromAddress(address: address){location in
                self.latitude = String(location.coordinate.latitude)
                self.longitude = String(location.coordinate.longitude)
                //print("The latitude is \(self.latitude) and longitude \(self.longitude)")
            }
        }else{print("addressTextField is nil")}
        
        if let radius = radiusTextField.text, let radiusDouble = Double(radius){
            //convert to meters
            radiusM = (radiusDouble * 1000)
            let radiusMStirng = String(radiusM).dropLast(2)
            self.radius = String(radiusMStirng)
            print("The radius is \(self.radius)")
            
        }else{print("radius is nil")}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        switch identifier{
        case "displaySwipeScreen":
            emptyLabel.removeFromSuperview()
            setLatitudeLongitudeRadius()
                if let swipeFoodViewController = segue.destination as? SwipeFoodViewController{
                    swipeFoodViewController.delegate = self
                }
        default:
            print("Unexpected segue identifier")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        emptyLabel.removeFromSuperview()
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
        }else if radiusM > 40000{
            emptyLabel = UILabel(frame: CGRect(x:0, y: self.view.frame.height * 0.60, width: self.view.frame.width, height: 30))
            emptyLabel.backgroundColor = UIColor.clear
            emptyLabel.textColor = UIColor.white
            emptyLabel.adjustsFontSizeToFitWidth = true
            emptyLabel.textAlignment = .center
            emptyLabel.text = "Distance must be less than 40km"
            emptyLabel.font = UIFont(name: "GillSans", size: 22)
            self.view.addSubview(emptyLabel)
            return false
        }

        return true
    }
}

