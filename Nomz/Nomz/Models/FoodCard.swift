//
//  FoodCard.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-19.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//
import UIKit

protocol FoodCardDelegate: NSObjectProtocol {
    func cardGoesLeft(card: FoodCard)
    func cardGoesRight(card: FoodCard)
}

class FoodCard: UIView {
    var xFromCenter: CGFloat = 0.0
    var imageViewStatus = UIImageView()
    var overLayImage = UIImageView()
    var originalPoint = CGPoint.zero
    var jsonFood: JSONFood?
    var distance: Double?
    var savedDistance: String = " "
    
    weak var delegate: FoodCardDelegate?
    
    public init(frame: CGRect,jsonFood: JSONFood) {
        super.init(frame: frame)
        self.jsonFood = jsonFood
        self.distance = jsonFood.distance
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
        
        if let imageUrl = imageUrl, let url = URL(string: imageUrl){
            let data = try? Data(contentsOf: url)
            foodImageView.image = UIImage(data: data!)
        }else{
            print("empty image url")
            foodImageView.image = UIImage(named: "ThumbDown")
        }
        //foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        addSubview(foodImageView)
        
        let labelText = UILabel(frame:CGRect(x: 20, y: frame.size.height - 80, width: frame.size.width - 40, height: 60))
        
        let roundedDistance = round(distance ?? 0)

        if roundedDistance < 1000 {
            let stringDistance = String(roundedDistance).dropLast(2)
            let displayStringDistance = "\(stringDistance) m"
            savedDistance = displayStringDistance
        
            let attributedText = NSMutableAttributedString(string: jsonFood?.restaurantName ?? " ", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans-Semibold", size: 25) ?? UIFont.systemFont(ofSize: 25),.backgroundColor: UIColor.lightText])
            
            attributedText.append(NSAttributedString(string: ", \(displayStringDistance)", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans", size: 20
                ) ?? UIFont.systemFont(ofSize: 25),.backgroundColor: UIColor.lightText]))
            
            labelText.attributedText = attributedText
            labelText.numberOfLines = 2
            addSubview(labelText)
        }else{
            let distanceInKm = roundedDistance/1000
            let stringDistance = String(distanceInKm).dropLast(2)
            let displayStringDistance = "\(stringDistance) km"
            savedDistance = displayStringDistance
            
            let attributedText = NSMutableAttributedString(string: jsonFood?.restaurantName ?? " ", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans-Semibold", size: 25) ?? UIFont.systemFont(ofSize: 25),.backgroundColor: UIColor.lightText])
            
            attributedText.append(NSAttributedString(string: ", \(displayStringDistance)", attributes: [.foregroundColor: UIColor.black,.font:UIFont(name: "GillSans", size: 20
                ) ?? UIFont.systemFont(ofSize: 25),.backgroundColor: UIColor.lightText]))
            
            labelText.attributedText = attributedText
            labelText.numberOfLines = 2
            addSubview(labelText)
        }
        
        //create thumbs up/down imageview
        imageViewStatus = UIImageView(frame: CGRect(x: 50 , y: 50 , width: 250, height: 250))
        
        //so its not visible in initial spot
        imageViewStatus.alpha = 0
        addSubview(imageViewStatus)
        
        overLayImage = UIImageView(frame:bounds)
        overLayImage.alpha = 0
        addSubview(overLayImage)
    }
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let foodCard = gestureRecognizer.view!
        let point = gestureRecognizer.translation(in: self)
        
        switch gestureRecognizer.state {
        // Begin swiping
        case .began:
            originalPoint = self.center;
            break;
        
        //In the middle of a swipe
        case .changed:
            xFromCenter = foodCard.center.x - originalPoint.x
            foodCard.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
            
            //let scale = min(120/abs(xFromCenter),1)
            foodCard.transform = CGAffineTransform(rotationAngle: (2 * 0.4 * xFromCenter)/(self.superview?.frame.width)!)//scaledBy(x: scale, y: scale)
            
            updateOverlay(xFromCenter: xFromCenter)
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
            overLayImage.image = #imageLiteral(resourceName: "overlay_like")
            imageViewStatus.tintColor = UIColor.green
        } else {
            imageViewStatus.image = #imageLiteral(resourceName: "ThumbDown")
            overLayImage.image = #imageLiteral(resourceName: "overlay_skip")
            imageViewStatus.tintColor = UIColor.red
        }
        //make thumbs more visible as you move right/left
        imageViewStatus.alpha = abs(xFromCenter)/originalPoint.x
        overLayImage.alpha = abs(xFromCenter)/originalPoint.x
    }
    
    func afterSwipeAction(foodCard: UIView){
        
        if foodCard.center.x < 50{
            leftAction(foodCard: foodCard)
            return
            
        } else if foodCard.center.x > ((self.superview?.frame.width)! - 50){
            rightAction(foodCard: foodCard)
            return
        }
        // return to center if not fully swiped
        UIView.animate(withDuration: 0.5) {
            foodCard.center = self.originalPoint
            self.imageViewStatus.alpha = 0
            self.overLayImage.alpha = 0
            foodCard.alpha = 1
            foodCard.transform = CGAffineTransform.identity
        }
    }
    
    func leftAction(foodCard: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            foodCard.center = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
            foodCard.alpha = 0
        }, completion: {(_) in
            self.removeFromSuperview()}
        )
        delegate?.cardGoesLeft(card: self)
        print("Going left")
    }
    
    func rightAction(foodCard: UIView){
        UIView.animate(withDuration: 0.3, animations: {
            foodCard.center = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
            foodCard.alpha = 0
        }, completion: {(_) in
            self.removeFromSuperview()}
        )
        saveToCoreData()
        delegate?.cardGoesRight(card: self)
        print("Going right")
    }
    
    func saveToCoreData() {
        let swipedFood = CoreDataHelper.newSwipedFood()
        swipedFood.imageUrl = jsonFood?.imageUrl
        swipedFood.price = jsonFood?.price
        swipedFood.restaurantId = jsonFood?.restaurantId
        swipedFood.restaurantName = jsonFood?.restaurantName
        swipedFood.yelpUrl = jsonFood?.yelpURL
        swipedFood.distance = savedDistance
        
        if let rating = jsonFood?.rating{
            swipedFood.rating = String(rating)
        }else{print("unable to save rating to core data")}

        CoreDataHelper.saveSwipedFood()
    }
}
