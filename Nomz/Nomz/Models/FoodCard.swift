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
    func currentCardStatus(card: FoodCard, distance: CGFloat)
}

class FoodCard: UIView {
    var xFromCenter: CGFloat = 0.0
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var imageViewStatus = UIImageView()
    var isLiked = false
    var originalPoint = CGPoint.zero
    
    weak var delegate: FoodCardDelegate?
    
    public override init(frame: CGRect) {
        super.init (frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(){
        layer.cornerRadius = 20
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0.5, height: 3)
        clipsToBounds = true
        isUserInteractionEnabled = false
        
        originalPoint = center
        
        //create pan gesture recognizer and pass "being dragged" as action
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        addGestureRecognizer(panGestureRecognizer)
        
        //create UIImageview for food pictures
        let foodImageView = UIImageView(frame: bounds)
        foodImageView.image = UIImage(named: String(Int(1+arc4random()%(8-1))))
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        addSubview(foodImageView)
        
        //create thumbs up/down imageview
        imageViewStatus = UIImageView(frame: CGRect(x: (frame.size.width / 2) - 37.5, y: 25 , width: 75, height: 75))
        
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
            break;
        //in the middle of a swipe
        case .changed:
            xFromCenter = foodCard.center.x - (self.superview?.center.x)! //or self.superview
            //print(xFromCenter)
            foodCard.center = CGPoint(x: self.center.x + point.x, y: self.center.y + point.y)
            
            let scale = min(100/abs(xFromCenter),1)
            foodCard.transform = CGAffineTransform(rotationAngle: (2 * 0.61 * xFromCenter)/self.frame.width).scaledBy(x: scale, y: scale)
            
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
            imageViewStatus.tintColor = UIColor.green
        } else {
            imageViewStatus.image = #imageLiteral(resourceName: "ThumbDown.png")
            imageViewStatus.tintColor = UIColor.red
        }
        //make thumbs more visible as you move right/left
        imageViewStatus.alpha = abs(xFromCenter)/self.center.x
    }
    
    func afterSwipeAction(foodCard: UIView){
        
        if foodCard.center.x < 75 {
            UIView.animate(withDuration: 0.3, animations: {
                foodCard.center = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
                foodCard.alpha = 0
            }, completion: {(_) in
                self.removeFromSuperview()}
            )
            isLiked = false
            delegate?.cardGoesLeft(card: self)
            print("Going left")
            return
            
        } else if foodCard.center.x > (self.frame.width - 75){
            UIView.animate(withDuration: 0.3, animations: {
                foodCard.center = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
                foodCard.alpha = 0
            }, completion: {(_) in
                self.removeFromSuperview()}
            )
            isLiked = true
            delegate?.cardGoesRight(card: self)
            print("Going right")
            return
        }
        // return to center if not fully swiped
        UIView.animate(withDuration: 0.2) {
            foodCard.center = (self.superview?.center)!
            self.imageViewStatus.alpha = 0
            foodCard.alpha = 1
            foodCard.transform = CGAffineTransform.identity
        }
    }
}
