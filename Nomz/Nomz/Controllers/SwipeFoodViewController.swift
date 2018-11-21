//
//  SwipeFoodViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-14.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

let MAX_BUFFER_SIZE = 3;

import UIKit

class SwipeFoodViewController: UIViewController {

    
    @IBOutlet weak var foodCardBackground: UIView!
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var foods = [JSONFood]()
    var allCardsArray = [FoodCard]()
    var currentLoadedCardsArray = [FoodCard]()
    var valueArray = ["1","2","3","4","5","6","7","8","9","hello"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        APIClient().fetchFood{result in
//        print("result")
//            if let result = result{
//                self.foods = result
//            }else{
//                print("No foods could be retrieved")
//            }
//            let url = URL(string: self.foods[0].imageUrl!)
//            let data = try? Data(contentsOf: url!)
//            self.foodImage.image = UIImage(data: data!)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        view.layoutIfNeeded()
        loadCardValues()
    }
    
    func loadCardValues(){
        if valueArray.count > 0{
            
            let capCount = (valueArray.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : valueArray.count
            
            for (i,_) in valueArray.enumerated() {
                let newCard = createFoodCard()
                allCardsArray.append(newCard)
                if i < capCount{
                    currentLoadedCardsArray.append(newCard)
                }
            }
            
            for(i,_) in currentLoadedCardsArray.enumerated(){
                if i > 0 {
                    foodCardBackground.insertSubview(currentLoadedCardsArray[i], belowSubview: currentLoadedCardsArray[i-1])
                } else {
                    foodCardBackground.addSubview(currentLoadedCardsArray[i])
                }
            }
            animateCardAfterSwiping()
 
        }
        print(allCardsArray)
        
    }
    
    func createFoodCard() -> FoodCard{
        let card = FoodCard(frame: CGRect(x: 0, y: 0, width: foodCardBackground.frame.size.width, height: foodCardBackground.frame.size.height - 50))
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
                frame.origin.y = CGFloat(i * 8)
            })
        }
    }
    
}

extension SwipeFoodViewController: FoodCardDelegate {
    func cardGoesLeft(card: FoodCard) {
        
    }
    
    func cardGoesRight(card: FoodCard) {
        
    }
    
    func currentCardStatus(card: FoodCard, distance: CGFloat) {
        
    }
}


