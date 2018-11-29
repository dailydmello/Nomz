//
//  ListOffersTableViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-25.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit

class ListOffersTableViewController: UITableViewController {
    
    var foodOffer: FoodOffer?
    var foodOffers = [FoodOffer](){
        didSet {
            tableView.reloadData()
        }
    }
    var delegate: SwipeFoodViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.darkGray
        foodOffers = CoreDataHelper.retrieveFoodOffer()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodOffers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTableViewCell", for: indexPath) as! FoodTableViewCell //typecast to  custom stylized cell
        
        let foodOffer = foodOffers[indexPath.row]
        switch foodOffer.imageNumberString{
        case "1":
            cell.offerTitleLabel.text = "LYFT"
            cell.offerDescriptionLabel.text = "Get $10 off your next two Lyft Rides"
//            cell.offerDescriptionLabel.numberOfLines = 0
//            cell.offerDescriptionLabel.lineBreakMode = .byWordWrapping
            cell.expiryLabel.text = "Expiry: Oct 31,2018"
            cell.offerImageView.image = UIImage(named: "1")
            cell.offerImageView.contentMode = .scaleAspectFill
        case "2":
            cell.offerTitleLabel.text = "METRO"
            cell.offerDescriptionLabel.text = "Save $3 on groceries from Metro"
            cell.offerDescriptionLabel.numberOfLines = 0
            cell.offerDescriptionLabel.lineBreakMode = .byWordWrapping
            cell.expiryLabel.text = "Expiry: Nov 30,2018"
            cell.offerImageView.image = UIImage(named: "2")
            cell.offerImageView.contentMode = .scaleAspectFill
        case "3":
            cell.offerTitleLabel.text = "Foodora"
            cell.offerDescriptionLabel.text = "Get $15 Off and Free Delivery"
            cell.offerDescriptionLabel.numberOfLines = 0
            cell.offerDescriptionLabel.lineBreakMode = .byWordWrapping
            cell.expiryLabel.text = "Expiry: March 1, 2019"
            cell.offerImageView.image = UIImage(named: "3")
            cell.offerImageView.contentMode = .scaleAspectFill
            
        case "4":
            cell.offerTitleLabel.text = "Booster Juice"
            cell.offerDescriptionLabel.text = "Get $2 cash back next visit"
            cell.offerDescriptionLabel.numberOfLines = 0
            cell.offerDescriptionLabel.lineBreakMode = .byWordWrapping
            cell.expiryLabel.text = "Expiry: Oct 31, 2018"
            cell.offerImageView.image = UIImage(named: "4")
            cell.offerImageView.contentMode = .scaleAspectFill
            
        default:
            print("unidentified image number")
        }
        
        return cell
    }
    //to delete calculations
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        //retrieve the calculation to be deleted corresponding to the selected index path. Then use Core Data helper to delete the selected calculation. Last, update calculations array to reflect the changes
        if editingStyle == .delete {
            let foodOfferToDelete = foodOffers[indexPath.row]
            CoreDataHelper.delete(foodOffer: foodOfferToDelete)
            foodOffers = CoreDataHelper.retrieveFoodOffer()
        }
    }
}

extension ListOffersTableViewController: SwipeViewControllerDelegate{
    func saveToCoreData(imageNumberString: String) {
        let foodOffer = CoreDataHelper.newFoodOffer()
        foodOffer.imageNumberString = imageNumberString
        CoreDataHelper.saveFoodOffer()
    }
    
}
