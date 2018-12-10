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
        //self.tableView.backgroundColor = UIColor.darkGray
        //swipedFoodArray = CoreDataHelper.retrieveSwipedFood()
        //print(swipedFoodArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "pizza")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.separatorColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        swipedFoodArray = CoreDataHelper.retrieveSwipedFood()
        
        tabBarController?.tabBar.backgroundColor = UIColor.lightText
        //tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.layer.borderWidth = 1.2
        tabBarController?.tabBar.layer.borderColor = UIColor.white.cgColor
        tabBarController?.tabBar.tintColor = UIColor.black
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swipedFoodArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodTableViewCell", for: indexPath) as! FoodTableViewCell //typecast to  custom stylized cell
        cell.backgroundColor = UIColor.lightText

        let swipedFood = swipedFoodArray[indexPath.row]
        cell.foodImageView.layer.borderColor = UIColor.white.cgColor
        cell.foodImageView.layer.borderWidth = 1.2
        
        if let url = swipedFood.imageUrl, let contentUrl = URL(string: url) {
            let data = try? Data(contentsOf: contentUrl)
            cell.foodImageView.image = UIImage(data: data!)
        }else{print("unable to table view cell pic")
            cell.foodImageView.image = UIImage(named: "ThumbDown")
        }
    
        cell.distance.text = swipedFood.distance
        //cell.distance.backgroundColor = UIColor.lightText
        cell.priceLevel.text = swipedFood.price
        //cell.priceLevel.backgroundColor = UIColor.lightText
        cell.restaurantName.text = swipedFood.restaurantName
        //cell.restaurantName.backgroundColor = UIColor.lightText
        cell.restaurantName.numberOfLines = 0
        cell.restaurantName.lineBreakMode = .byWordWrapping
        cell.rating.text = swipedFood.rating
        //cell.rating.backgroundColor = UIColor.lightText
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tappedFood = swipedFoodArray[indexPath.row]
        
        let urlString = tappedFood.yelpUrl
        if let url = URL(string: urlString!)
        {
            UIApplication.shared.open(url)
        } else {print("could not open browser")}
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

