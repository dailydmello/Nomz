//
//  ListOffersTableViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-25.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit

class ListOffersTableViewController: UITableViewController {
    
    var swipedFood: SwipedFood?
    var swipedFoodArray = [SwipedFood](){
        didSet {
            tableView.reloadData()
        }
    }
    var delegate: SwipeFoodViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = UIColor.darkGray
        swipedFoodArray = CoreDataHelper.retrieveSwipedFood()
        //print(swipedFoodArray)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swipedFoodArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTableViewCell", for: indexPath) as! FoodTableViewCell //typecast to  custom stylized cell
        
        let swipedFood = swipedFoodArray[indexPath.row]
        
        if let url = swipedFood.imageUrl{
            let url = URL(string: url)
            let data = try? Data(contentsOf: url!)
            cell.foodImageView.image = UIImage(data: data!)
        }else{print("unable to change pic")}
    
        cell.distance.text = swipedFood.distance
        cell.priceLevel.text = swipedFood.price
        cell.restaurantName.text = swipedFood.restaurantName
        cell.rating.text = swipedFood.rating
        
        
        
        return cell
    }
    
    //to delete calculations
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let swipedFoodToDelete = swipedFoodArray[indexPath.row]
            CoreDataHelper.delete(swipedFood: swipedFoodToDelete)
            swipedFoodArray = CoreDataHelper.retrieveSwipedFood()
        }
    }
}

