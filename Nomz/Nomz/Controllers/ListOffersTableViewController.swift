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
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
        swipedFoodArray = CoreDataHelper.retrieveSwipedFood()
        
    }
    
    func setupViews(){
        let backgroundImage = UIImage(named: Constants.ImageNames.pizza)
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.separatorColor = UIColor.black
        imageView.contentMode = .scaleAspectFill
        
        tabBarController?.tabBar.backgroundColor = UIColor.lightText
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.layer.borderWidth = 1.2
        tabBarController?.tabBar.layer.borderColor = UIColor.black.cgColor
        tabBarController?.tabBar.tintColor = UIColor.black
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swipedFoodArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifier.foodTableViewCell, for: indexPath) as! FoodTableViewCell

        let swipedFood = swipedFoodArray[indexPath.row]
        cell.distance.text = swipedFood.distance
        cell.priceLevel.text = swipedFood.price ?? "Unknown"
        cell.restaurantName.text = swipedFood.restaurantName
        cell.rating.text = swipedFood.rating
        
        if let url = swipedFood.imageUrl, let contentUrl = URL(string: url) {
            //so data doesnt block UI on main queue
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: contentUrl)
                DispatchQueue.main.async {
                    cell.foodImageView.image = UIImage(data: data!)
                }
            }
        }else{print("unable to table view cell pic")
            cell.foodImageView.image = UIImage(named: Constants.ImageNames.thumbDown)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let tappedFood = swipedFoodArray[indexPath.row]
        
        let urlString = tappedFood.yelpUrl
        if let url = URL(string: urlString!){
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

