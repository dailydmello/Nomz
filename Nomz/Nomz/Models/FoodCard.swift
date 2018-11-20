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
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var imageViewStatus = UIImageView()
    var isLiked = false
    var originalPoint = CGPoint.zero
    
    weak var delegate: FoodCardDelegate?
    
    public init(frame: CGRect, value:String){
        super.init (frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder){
        fatalError("init(coder:) has not been implemented")
    }
    func setupView(at value: String){
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
        let backGroundImageView = UIImageView(frame: bounds)
        backGroundImageView.image = UIImage(named: String(Int(1+arc4random()%(8-1))))
        backGroundImageView.contentMode = .scaleAspectFill
        backGroundImageView.clipsToBounds = true
        addSubview(backGroundImageView)
        
        //create thumbs up/down uiimage
        imageViewStatus = UIImageView(frame: CGRect(x: (frame.size.width / 2) - 37.5, y: 25 , width: 75, height: 75))
        
        //so its not visible in initial spot
        imageViewStatus.alpha = 0
        addSubview(imageViewStatus)
        

    }
    
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        xCenter = gestureRecognizer.translation(in: self).x
        yCenter = gestureRecognizer.translation(in: self).y
        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            originalPoint = self.center;
            break;
        //in the middle of a swipe
        case .changed:
            let rotationStrength = min(xCenter / UIScreen.main.bounds.size.width, 1)
            let rotationAngel = .pi/8 * rotationStrength
            //let scale = max(1 - abs(rotationStrength) / SCALE_STRENGTH, SCALE_RANGE)
            center = CGPoint(x: originalPoint.x + xCenter, y: originalPoint.y + yCenter)
            let transforms = CGAffineTransform(rotationAngle: rotationAngel)
            //let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
            //self.transform = scaleTransform
            //updateOverlay(xCenter)
            break;
            
        // swipe ended
        case .ended:
            //afterSwipeAction()
            break;
            
        case .possible:break
        case .cancelled:break
        case .failed:break
        }
    }
    
    
}
