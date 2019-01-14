//
//  SwipeFoodViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-14.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

let MAX_DISPLAY_BUFFER_SIZE = 3;
let SEPERATOR_DISTANCE = 8;

import UIKit

class SwipeFoodViewController: UIViewController{
    
    @IBOutlet weak var foodCardBackground: UIView!
    
    var allFoodCardsArray = [FoodCard]()
    var currentDisplayedCardsArray = [FoodCard]()
    var currentIndex = 0
    var foodArray = [JSONFood]()
    var loadingView = UIView()
    
    var delegate: FoodFilterViewController?
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        getFoodData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupViews()
    }
    
    func getFoodData(){
        
        displayLoadingScreen()
        
        if let delegate = delegate {
            let params = delegate.foodSearchParams()
            let latitude = params["latitude"]
            let longitude = params["longitude"]
            let radius = params["radius"]
            
            APIClient.fetchFood(latitude: latitude ?? "", longitude: longitude ?? "", radius: radius ?? ""){result in
                
                if (result?.isEmpty)!{
                    self.loadingView.removeFromSuperview()
                    self.displayNoNomzFound()
                }else{
                    if let result = result{
                        let radiusDouble = Double(radius!)
                        //Yelp API sometimes returns results > radius
                        for jsonFood in result{
                            if jsonFood.distance! <= radiusDouble! {
                                self.foodArray.append(jsonFood)
                            }else{
                                print("\(jsonFood.distance ?? 0.0) > \(radius!)")
                            }
                        }
                        self.loadCardValues()
                        self.loadingView.removeFromSuperview()
                    }else{
                        print("result is nil")}
                }
            }
        }
    }

    
    func setupViews(){
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundColor = UIColor.lightText
        tabBarController?.tabBar.tintColor = UIColor.black
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.layer.borderWidth = 1.2
        tabBarController?.tabBar.layer.borderColor = UIColor.black.cgColor
        navigationController?.navigationBar.tintColor = .white

    }
    
    func displayLoadingScreen(){
        foodCardBackground.center.x = self.view.center.x
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 220, height: 220))
        loadingView.center.x = foodCardBackground.center.x
        loadingView.center.y = foodCardBackground.center.y - 60
        loadingView.backgroundColor = UIColor.clear
        loadingView.layer.borderColor = UIColor.white.cgColor
        loadingView.layer.borderWidth = 1.5
        loadingView.clipsToBounds = false
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center.x = loadingView.frame.width/2
        activityIndicator.center.y = loadingView.frame.height * 0.25
        activityIndicator.color = UIColor.white
        
        let loadingLabel = UILabel(frame: CGRect(x:0, y: loadingView.frame.height * 0.70, width: loadingView.frame.width, height: 30))
        loadingLabel.backgroundColor = UIColor.clear
        loadingLabel.textColor = UIColor.white
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading Your Nomz!"
        loadingLabel.font = UIFont(name: "GillSans", size: 22)
        
        loadingView.addSubview(activityIndicator)
        loadingView.addSubview(loadingLabel)
        
        self.view.addSubview(loadingView)
        activityIndicator.startAnimating()
    }
    
    func displayNoNomzFound(){
        loadingView = UIView(frame: CGRect(x: 80, y: 180, width: 220, height: 220))
        loadingView.backgroundColor = UIColor.clear
        loadingView.layer.borderColor = UIColor.white.cgColor
        loadingView.center.x = foodCardBackground.center.x
        loadingView.center.y = foodCardBackground.center.y - 60
        loadingView.layer.borderWidth = 1.5
        loadingView.clipsToBounds = false
        
        let loadingLabel = UILabel(frame: CGRect(x:0, y: loadingView.frame.height * 0.45, width: loadingView.frame.width, height: 30))
        loadingLabel.backgroundColor = UIColor.clear
        loadingLabel.textColor = UIColor.white
        loadingLabel.adjustsFontSizeToFitWidth = true
        loadingLabel.textAlignment = .center
        loadingLabel.text = "No Nomz Found"
        loadingLabel.font = UIFont(name: "GillSans", size: 22)
        
        loadingView.addSubview(loadingLabel)
        self.view.addSubview(loadingView)
    }
    
    func loadCardValues(){
        
        if self.foodArray.count > 0{
            
            let capCount = (self.foodArray.count > MAX_DISPLAY_BUFFER_SIZE) ? MAX_DISPLAY_BUFFER_SIZE : self.foodArray.count
            
            for (i,jsonFood) in self.foodArray.enumerated() {
                //print("\(i) and \(food)")
                let newCard = createFoodCard(jsonFood: jsonFood)
                allFoodCardsArray.append(newCard)
                //load first 3 cards into currentLoadedCardsArray
                if i < capCount{
                    currentDisplayedCardsArray.append(newCard)
                }
            }
            
            for(i,_) in currentDisplayedCardsArray.enumerated(){
                if i > 0 {
                    foodCardBackground.insertSubview(currentDisplayedCardsArray[i], belowSubview: currentDisplayedCardsArray[i - 1])
                } else {
                    foodCardBackground.addSubview(currentDisplayedCardsArray[i])
                }
            }
            animateStackAfterSwiping()
        }
    }
    
    func createFoodCard(jsonFood: JSONFood) -> FoodCard{
        let card = FoodCard(frame: CGRect(x: 0, y: 0, width: foodCardBackground.frame.size.width, height: foodCardBackground.frame.size.height),jsonFood: jsonFood)
        card.delegate = self
        return card
    }
    
    func animateStackAfterSwiping(){
        for(i,card) in currentDisplayedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                if i == 0{
                    card.isUserInteractionEnabled = true
                }
                //print(card.frame.origin.y)
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
    }
    
    func removeObjectAndAddNewValues(){
        //remove card that is swiped
        currentDisplayedCardsArray.removeFirst()
        
        //increment index
        currentIndex += 1
        
        if (currentIndex + currentDisplayedCardsArray.count) < allFoodCardsArray.count{
            let nextCard = allFoodCardsArray[currentIndex + currentDisplayedCardsArray.count]
            var frame = nextCard.frame
            frame.origin.y = CGFloat(MAX_DISPLAY_BUFFER_SIZE * SEPERATOR_DISTANCE)
            nextCard.frame = frame
            currentDisplayedCardsArray.append(nextCard)
            foodCardBackground.insertSubview(currentDisplayedCardsArray[2], belowSubview: currentDisplayedCardsArray[1])
        }
        //print(currentIndex)
    }
    
}

extension SwipeFoodViewController: FoodCardDelegate {
    
    func cardGoesLeft(card: FoodCard) {
        removeObjectAndAddNewValues()
        animateStackAfterSwiping()
    }
    
    func cardGoesRight(card: FoodCard) {
        removeObjectAndAddNewValues()
        animateStackAfterSwiping()
    }
    
}


