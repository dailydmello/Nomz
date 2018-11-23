//
//  FoodFilterViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-13.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//


import UIKit

class FoodFilterViewController: UIViewController{
    @IBOutlet weak var foodCardBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    var xFromCenter: CGFloat = 0.0
    var xCenter: CGFloat = 0.0
    var yCenter: CGFloat = 0.0
    var imageViewStatus = UIImageView()
    var isLiked = false
    var originalPoint = CGPoint.zero
    
    weak var delegate: FoodCardDelegate?


    func setupView(){
        foodCardBackground.layer.cornerRadius = 20
        foodCardBackground.layer.shadowRadius = 3
        foodCardBackground.layer.shadowOpacity = 0.4
        foodCardBackground.layer.shadowOffset = CGSize(width: 0.5, height: 3)
        foodCardBackground.clipsToBounds = true
        foodCardBackground.isUserInteractionEnabled = false
        
        //originalPoint = center
        
        //create pan gesture recognizer and pass "being dragged" as action
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.beingDragged))
        view.addGestureRecognizer(panGestureRecognizer)
        
        //create UIImageview for food pictures
        let foodImageView = UIImageView(frame: view.bounds)
        foodImageView.image = UIImage(named: String(Int(1+arc4random()%(8-1))))
        foodImageView.contentMode = .scaleAspectFill
        foodImageView.clipsToBounds = true
        view.addSubview(foodImageView)
        
        //create thumbs up/down uiimage
        imageViewStatus = UIImageView(frame: CGRect(x: (view.frame.size.width / 2) - 37.5, y: 25 , width: 75, height: 75))
        
        //so its not visible in initial spot
        imageViewStatus.alpha = 0
        view.addSubview(imageViewStatus)
    }
    
    //If you have a func to selector a private func in swift
    @objc func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let foodCard = gestureRecognizer.view!
        let point = gestureRecognizer.translation(in: view)

        switch gestureRecognizer.state {
        // Keep swiping
        case .began:
            //originalPoint = view.center;
            break;
        //in the middle of a swipe
        case .changed:
            xFromCenter = foodCard.center.x - view.center.x
            foodCard.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let scale = min(100/abs(xFromCenter),1)
            foodCard.transform = CGAffineTransform(rotationAngle: (2 * 0.61 * xFromCenter)/view.frame.width).scaledBy(x: scale, y: scale)
            
            updateOverlay(xFromCenter: xFromCenter)
            break;
            
        // swipe ended
        case .ended:
            afterSwipeAction(foodCard: foodCard)
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
        imageViewStatus.alpha = abs(xFromCenter)/view.center.x
    }
    
    func afterSwipeAction(foodCard: UIView){
        if foodCard.center.x < 75 {
            UIView.animate(withDuration: 0.3, animations: {
                foodCard.center = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
                foodCard.alpha = 0
            }, completion: {(_) in
                self.view.removeFromSuperview()
            })
            isLiked = false
            //delegate?.cardGoesRight(card: self)
            print("Going right")
            return
            
        } else if foodCard.center.x > (view.frame.width - 75){
            UIView.animate(withDuration: 0.3, animations: {
                foodCard.center = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
                foodCard.alpha = 0
            }, completion: {(_) in
                self.view.removeFromSuperview()
            })
            isLiked = true
            //delegate?.cardGoesLeft(card: self)
            print("Going left")
            return
        }
        // return to center if not fully swiped
        UIView.animate(withDuration: 0.2) {
            foodCard.center = self.view.center
            self.imageViewStatus.alpha = 0
            foodCard.alpha = 1
            foodCard.transform = CGAffineTransform.identity
        }
    }
    
    
}
