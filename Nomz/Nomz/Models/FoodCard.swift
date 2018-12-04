//
//  FoodCard.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-19.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//
import UIKit

protocol FoodCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: FoodCard, imageNumber: String)
    func cardGoesRight(card: FoodCard, imageNumber: String)
}
class FoodCard: UIView {
    var xFromCenter: CGFloat = 0.0
    var imageViewStatus = UIImageView()
    var isLiked = false
    var originalPoint = CGPoint.zero
    var imageNumber: String = " "
    var jsonFood: JSONFood?
    var distance: Double?
    
    weak var delegate: FoodCardDelegate?
    
    public init(frame: CGRect,jsonFood: JSONFood) {
        super.init(frame: frame)
        self.jsonFood = jsonFood
        self.distance = jsonFood.distance
        print(jsonFood)
        setupView(imageUrl: jsonFood.imageUrl)
    }

    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(imageUrl: String?){
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        clipsToBounds = true
        isUserInteractionEnabled = false
        
        //create pan gesture recognizer and pass "being dragged" as action
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        let foodImageView = UIImageView(frame: bounds)
        print ("this is \(imageUrl)")
        if let imageUrl = imageUrl, let url = URL(string: imageUrl){
            let data = try? Data(contentsOf: url)
            foodImageView.image = UIImage(data: data!)
        }else{print("unable to change pic")
            foodImageView.image = UIImage(named: "ThumbDown")
        }
        //foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        addSubview(foodImageView)
        
        let labelText = UILabel(frame:CGRect(x: 20, y: frame.size.height - 80, width: frame.size.width - 40, height: 60))
        
        let displayDistance = round(distance ?? 0)
        
        if displayDistance < 1000 {
            let stringDistance = String(displayDistance).dropLast(2)
            //let displayName = jsonFood?.restaurantName  ?? " "
            let attributedText = NSMutableAttributedString(string: jsonFood?.restaurantName  ?? " ", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans-Semibold", size: 25),.backgroundColor: UIColor.lightText])
            attributedText.append(NSAttributedString(string: ", \(stringDistance) m", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans", size: 20
                ),.backgroundColor: UIColor.lightText]))
            labelText.attributedText = attributedText
            labelText.numberOfLines = 2
            addSubview(labelText)
        }else{
            let largeStringDistance = String(displayDistance).dropLast(2)
            let attributedText = NSMutableAttributedString(string: jsonFood?.restaurantName  ?? " ", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans-Semibold", size: 25),.backgroundColor: UIColor.lightText])
            attributedText.append(NSAttributedString(string: ", \(largeStringDistance) km", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans", size: 20
                ),.backgroundColor: UIColor.lightText]))
            labelText.attributedText = attributedText
            labelText.numberOfLines = 2
            addSubview(labelText)
        }
        
        //create thumbs up/down imageview
        imageViewStatus = UIImageView(frame: CGRect(x: 50 , y: 50 , width: 300, height: 300))
        
        //so its not visible in initial spot
        imageViewStatus.alpha = 0
        addSubview(imageViewStatus)
    }
    
    //If you have a func to selector a private func in swift
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {

        let foodCard = gestureRecognizer.view!
        let point = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
           // print("this is org")
            //print(originalPoint)
            break;
        //in the middle of a swipe
        case .changed:
            xFromCenter = foodCard.center.x - originalPoint.x //or self.superview
            foodCard.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
            let scale = min(100/abs(xFromCenter),1)
            foodCard.transform = CGAffineTransform(rotationAngle: (2 * 0.4 * xFromCenter)/(self.superview?.frame.width)!)//.scaledBy(x: scale, y: scale)
            updateOverlay(xFromCenter: xFromCenter)
            //print(foodCard.center)
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction(foodCard: self)
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    
    func updateOverlay(xFromCenter: CGFloat){
        //update thumbs depending on swipe direction +left, -right
        if xFromCenter > 0 {
            imageViewStatus.image = #imageLiteral(resourceName: "ThumbUp")
            imageViewStatus.tintColor = UIColor.green
        } else {
            imageViewStatus.image = #imageLiteral(resourceName: "ThumbDown.png")
            imageViewStatus.tintColor = UIColor.red
        }
        //make thumbs more visible as you move right/left
        imageViewStatus.alpha = abs(xFromCenter)/originalPoint.x
    }
    
    func afterSwipeAction(foodCard: UIView){
        
        if foodCard.center.x < 100 {
            leftAction(foodCard: foodCard)
            return
            
        } else if foodCard.center.x > ((self.superview?.frame.width)! - 100){
            rightAction(foodCard: foodCard)
            return
        }
        // return to center if not fully swiped
        UIView.animate(withDuration: 0.5) {
            foodCard.center = self.originalPoint
            self.imageViewStatus.alpha = 0
            foodCard.alpha = 1
            foodCard.transform = CGAffineTransform.identity
        }
    }
    
    func leftAction(foodCard: UIView){
        //let finishPoint = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
        UIView.animate(withDuration: 0.3, animations: {
            foodCard.center = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
            //print("this is food card center")
            //print(foodCard.center)
            foodCard.alpha = 0
        }, completion: {(_) in
            self.removeFromSuperview()}
        )
        isLiked = false
        delegate?.cardGoesLeft(card: self, imageNumber: imageNumber)
        print("Going left")
    }
    
    func rightAction(foodCard: UIView){
        //let finishPoint = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
        UIView.animate(withDuration: 0.3, animations: {
            foodCard.center = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
            //print("this is food card center")
            //print(foodCard.center)
            foodCard.alpha = 0
        }, completion: {(_) in
            self.removeFromSuperview()}
        )
        isLiked = true
        //delegate?.saveToCoreData(imageNumberString: imageNumber)
        saveToCoreData()
        delegate?.cardGoesRight(card: self, imageNumber: imageNumber)
        print("Going right")
    }
    
    func saveToCoreData() {
        //print("triggered")
        let swipedFood = CoreDataHelper.newSwipedFood()
        //print(jsonFood?.imageUrl)
        swipedFood.imageUrl = jsonFood?.imageUrl
        swipedFood.price = jsonFood?.price
        swipedFood.restaurantId = jsonFood?.restaurantId
        swipedFood.restaurantName = jsonFood?.restaurantName
        swipedFood.yelpUrl = jsonFood?.yelpURL
        
        if let rating = jsonFood?.rating{
            swipedFood.rating = String(rating)
        }else{print("unable to save rating to core data")}
        
        if let distance = jsonFood?.distance{
            swipedFood.distance = String(distance)
            
        }else{print("unable to save distance to core data")}

        CoreDataHelper.saveSwipedFood()
    }
}
