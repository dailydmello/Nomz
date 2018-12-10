//
//  SwipeFoodViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-14.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

let MAX_BUFFER_SIZE = 3;
let SEPERATOR_DISTANCE = 8;

import UIKit

protocol SwipeViewControllerDelegate: NSObjectProtocol {
    func saveToCoreData(imageNumberString: String)
}

class SwipeFoodViewController: UIViewController{
    
    //@IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var foodCardBackground: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var foods = [JSONFood]()
    var allCardsArray = [FoodCard]()
    var currentLoadedCardsArray = [FoodCard]()
    var currentIndex = 0
    var foodArray = [JSONFood]()
    var longitude: String = " "
    var latitude: String = " "
    var radius: String = " "
    var loadingView = UIView()
    
    var delegate: FoodFilterViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let delegate = delegate {
            let latitude = delegate.passFilterCriteria()[0]
            let longitude = delegate.passFilterCriteria()[1]
            let radius = delegate.passFilterCriteria()[2]
            
            displayLoadingScreen()
            
            APIClient(latitude: latitude, longitude: longitude, radius: radius).fetchFood{result in
                if let result = result{
                    self.foodArray = result
                    print(self.foodArray)
                    self.loadCardValues()
                    self.loadingView.removeFromSuperview()
                }else{
                    print("No foods could be retrieved")
                }
            }
        }
        loadCardValues()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        setupViews()
    }
    
    func setupViews(){
        tabBarController?.tabBar.backgroundImage = UIImage()
        tabBarController?.tabBar.shadowImage = UIImage()
        tabBarController?.tabBar.backgroundColor = UIColor.clear
        tabBarController?.tabBar.isTranslucent = true
        tabBarController?.tabBar.layer.borderWidth = 1.2
        tabBarController?.tabBar.layer.borderColor = UIColor.white.cgColor
        navigationController?.navigationBar.tintColor = .clear

    }
    
    func displayLoadingScreen(){
        loadingView = UIView(frame: CGRect(x: 80, y: 180, width: 220, height: 220))
        //loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
        loadingView.backgroundColor = UIColor.clear
        loadingView.layer.borderColor = UIColor.white.cgColor
        loadingView.layer.borderWidth = 1.5
        loadingView.clipsToBounds = false
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        //            activityIndicator.frame = CGRect(x: 65, y: 40, width: activityIndicator.frame.width, height:activityIndicator.frame.height )
        
        activityIndicator.center.x = loadingView.frame.width/2
        activityIndicator.center.y = loadingView.frame.height * 0.25
        activityIndicator.color = UIColor.white
        
        //loadingView.addSubview(activityIndicator)
        
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
    
    func loadCardValues(){
        
        if self.foodArray.count > 0{
            
            let capCount = (self.foodArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : self.foodArray.count
            
            for (i,jsonfood) in self.foodArray.enumerated() {
                //print("\(i) and \(food)")
                let newCard = createFoodCard(jsonFood: jsonfood)
                allCardsArray.append(newCard)
                //load first 3 cards into currentLoadedCardsArray
                if i < capCount{
                    currentLoadedCardsArray.append(newCard)
                }
            }
            
            for(i,_) in currentLoadedCardsArray.enumerated(){
                if i > 0 {
                    foodCardBackground.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i - 1])
                } else {
                    foodCardBackground.addSubview(currentLoadedCardsArray[i])
                    
                }
            }
            animateCardAfterSwiping()
        }else{
//            let loadingView = UIView(frame: CGRect(x: 50, y: 180, width: 280, height: 220))
//            //loadingView.center = CGPoint(x: self.view.center.x, y: self.view.center.y)
//            loadingView.backgroundColor = UIColor.clear
//            loadingView.layer.borderColor = UIColor.clear.cgColor
//            loadingView.layer.borderWidth = 1.5
//            loadingView.clipsToBounds = false
//
//            let loadingLabel = UILabel(frame: CGRect(x:0, y: loadingView.frame.height * 0.40, width: loadingView.frame.width, height: 30))
//            loadingLabel.backgroundColor = UIColor.clear
//            loadingLabel.textColor = UIColor.white
//            loadingLabel.adjustsFontSizeToFitWidth = true
//            loadingLabel.textAlignment = .center
//            loadingLabel.numberOfLines = 1
//            //loadingLabel.lineBreakMode = .byWordWrapping
//            loadingLabel.text = "No Nomz within that distance!"
//            loadingLabel.font = UIFont(name: "GillSans", size: 22)
//
//            loadingView.addSubview(loadingLabel)
//
//            self.view.addSubview(loadingView)
        }
    }
    
    
    
    func createFoodCard(jsonFood: JSONFood) -> FoodCard{
        let card = FoodCard(frame: CGRect(x: 0, y: 0, width: foodCardBackground.frame.size.width, height: foodCardBackground.frame.size.height),jsonFood: jsonFood)
        card.delegate = self
        return card
    }
    
    func animateCardAfterSwiping(){
        for(i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.2, animations: {
                if i == 0{
                    card.isUserInteractionEnabled = true
                }
                var frame = card.frame
                frame.origin.y = CGFloat(i * SEPERATOR_DISTANCE)
                card.frame = frame
            })
        }
    }
    
    func removeObjectAndAddNewValues(){
        //remove card that is swiped
        currentLoadedCardsArray.remove(at:0)
        //increment index
        currentIndex = currentIndex + 1
        //print(currentLoadedCardsArray.count)
        
        if (currentIndex + currentLoadedCardsArray.count) < allCardsArray.count{
            let card = allCardsArray[currentIndex + currentLoadedCardsArray.count]
            var frame = card.frame
            frame.origin.y = CGFloat(MAX_BUFFER_SIZE * SEPERATOR_DISTANCE)
            card.frame = frame
            currentLoadedCardsArray.append(card)
            foodCardBackground.insertSubview(currentLoadedCardsArray[2], belowSubview: currentLoadedCardsArray[1])
        }
        print(currentIndex)
        animateCardAfterSwiping()
    }
    
}

extension SwipeFoodViewController: FoodCardDelegate {
    
    func cardGoesLeft(card: FoodCard, imageNumber:String) {
        print(imageNumber)
        removeObjectAndAddNewValues()
    }
    
    func cardGoesRight(card: FoodCard, imageNumber:String) {
        print(imageNumber)
        removeObjectAndAddNewValues()
    }
    
    
}


