//
//  SwipeFoodViewController.swift
//  Nomz
//
//  Created by Ethan D'Mello on 2018-11-14.
//  Copyright © 2018 Ethan D'Mello. All rights reserved.
//

import UIKit

class SwipeFoodViewController: UIViewController{
    
    @IBOutlet weak var foodCard: UIView!
    
    @IBOutlet weak var thumbImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func resetCard(){
        UIView.animate(withDuration: 0.2) {
            self.foodCard.center = self.view.center
            self.thumbImageView.alpha = 0
            self.foodCard.alpha = 1
            self.foodCard.transform = CGAffineTransform.identity
        }
    }
    @IBAction func resetTapped(_ sender: Any) {
        resetCard()
    }
    
    @IBAction func panCard(_ sender: UIPanGestureRecognizer) {
        let foodCard = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = foodCard.center.x - view.center.x
        foodCard.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        let scale = min(100/abs(xFromCenter),1)
        foodCard.transform = CGAffineTransform(rotationAngle: (2 * 0.61 * xFromCenter)/view.frame.width).scaledBy(x: scale, y: scale)
        if xFromCenter > 0 {
            thumbImageView.image = #imageLiteral(resourceName: "ThumbUp")
            thumbImageView.tintColor = UIColor.green
        } else {
            thumbImageView.image = #imageLiteral(resourceName: "ThumbDown.png")
            thumbImageView.tintColor = UIColor.red
        }
        
        thumbImageView.alpha = abs(xFromCenter)/view.center.x
        
        if sender.state == UIGestureRecognizerState.ended {
            if foodCard.center.x < 75 {
                UIView.animate(withDuration: 0.3, animations: {
                    foodCard.center = CGPoint(x: foodCard.center.x - 200, y: foodCard.center.y + 75)
                    foodCard.alpha = 0
                })
                return
            } else if foodCard.center.x > (view.frame.width - 75){
                UIView.animate(withDuration: 0.3, animations: {
                    foodCard.center = CGPoint(x: foodCard.center.x + 200, y: foodCard.center.y + 75)
                    foodCard.alpha = 0
                })
                return
            }
            
            resetCard()
        }
        
    }
    
}


