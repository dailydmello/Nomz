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

class SwipeFoodViewController: UIViewController {

    
    @IBOutlet weak var foodCardBackground: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var foods = [JSONFood]()
    var allCardsArray = [FoodCard]()
    var currentLoadedCardsArray = [FoodCard]()
    var currentIndex = 0
    //var valueArray = ["1","2","3","4","5","6","7","8","9","10"]
    var valueArray = [JSONFood]()
    
    var delegate: FoodFilterViewController?
    var longitude: String = " "
    var latitude: String = " "
    var radius: String = " "
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if delegate = delegate{
//            self.longitude = String(delegate?.passCoordinates()[0])
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        APIClient().fetchFood{result in
            print("result")
            if let result = result{
                self.valueArray = result
                print(self.valueArray.count)
                self.loadCardValues()
            }else{
                print("No foods could be retrieved")
            }
        }
    }
    
    func loadCardValues(){
       
        if self.valueArray.count > 0{
            
            let capCount = (self.valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : self.valueArray.count
            
            for (i,food) in self.valueArray.enumerated() {
                //print("\(i) and \(food)")
                let newCard = createFoodCard(foodURL: food.imageUrl!)
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
        }
    }
    
    func createFoodCard(foodURL: String) -> FoodCard{
        let card = FoodCard(frame: CGRect(x: 0, y: 0, width: foodCardBackground.frame.size.width, height: foodCardBackground.frame.size.height - 50), imageURL:foodURL)
        card.delegate = self
        return card
    }
    
    func animateCardAfterSwiping(){
        for(i,card) in currentLoadedCardsArray.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
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
        print(currentLoadedCardsArray.count)
        
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
    func cardGoesLeft(card: FoodCard) {
        removeObjectAndAddNewValues()        
    }
    
    func cardGoesRight(card: FoodCard) {
        removeObjectAndAddNewValues()
    }
}


