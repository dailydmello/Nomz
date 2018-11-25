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
    func passCoordinates () -> [String]
}

class FoodFilterViewController: UIViewController, FoodFilterDelegate, UITextFieldDelegate{

    var criteria = [String]()
    var location: CLLocation?
    var address: String = " "
    var radius: String = " "
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var radiusTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressTextField.delegate = self
        radiusTextField.delegate = self
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
            self.location = location
            completion(location)
        }
    }
    
    func passCoordinates() -> [String] {
        self.criteria.removeAll()
        if let location = self.location{
            let longitude = location.coordinate.latitude
            let latitude = location.coordinate.longitude
            self.criteria.append(String(latitude))
            self.criteria.append(String(longitude))
        }else{print("couldnt access")
//            self.criteria.append("0")
//            self.criteria.append("0")
        }
        
        self.criteria.append(String(radius))
        print(criteria)
        return criteria
        
    }
    @IBAction func unwindWithSegue (_ segue: UIStoryboardSegue){
        //each time the user taps the save or cancel bar button item in CalculationViewController, update calculations array in ListCalcTableViewController
    }
    
    @IBAction func FindFoodButtonTapped(_ sender: Any) {
        getCoordinates(){_ in
            self.passCoordinates()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let address = addressTextField.text{
            self.address = address
        }else{print("unable to retrieve")}
        
        if let radius = radiusTextField.text{
            self.radius = radius
        }else{print("unable to retrieve")}
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier{
        case "displayFood":
            if let swipeFoodViewController = segue.destination as? SwipeFoodViewController{
                swipeFoodViewController.delegate = self}
        default:
            print("Unexpected segue identifier")
        }
    }
    
    
}
