//
//  AnimatedProfilePicture.swift
//  scholarsNearMe
//
//  Created by M.A. Vos on 07-05-16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import Foundation
import UIKit

class AnimatedProfilePicture: UIView
{
    var profileImageView: UIImageView?
    var baseView: UIView?
    var timer: NSTimer?
    var circlesToSpawn = 1000
    var sizeBigger = CGFloat()
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        createProfilePicture()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        createProfilePicture()
        print("createProfilePicture")
        self.center = CGPoint(x: screenWidth/2, y: screenHeight/5)
        
    }
    
    func startAnimating(delay: CGFloat)
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: #selector(createCircle), userInfo: nil, repeats: true)
    }
    
    func setProfilePicture(image: UIImage)
    {
        profileImageView?.image = image
    }
    
    private func createProfilePicture()
    {
        profileImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        profileImageView?.layer.cornerRadius = self.frame.size.width / 2
        profileImageView?.clipsToBounds = true
        profileImageView?.contentMode = .ScaleAspectFill
        
        profileImageView?.layer.shadowColor = UIColor.blackColor().CGColor
        profileImageView?.layer.shadowOffset = CGSize(width: 3, height: 3)
        profileImageView?.layer.shadowOpacity = 0.7
        profileImageView?.layer.shadowRadius = 4.0
        
        // add the shadow to the base view
        baseView = UIView(frame: profileImageView!.frame)
        baseView?.backgroundColor = UIColor.clearColor()
        baseView?.layer.shadowColor = UIColor.blackColor().CGColor
        baseView?.layer.shadowOffset = CGSize(width: 0, height: 0)
        baseView?.layer.shadowOpacity = 0.5
        baseView?.layer.shadowRadius = 3.0
        
        // add the border to subview
        let borderView = UIView()
        borderView.frame = baseView!.bounds
        borderView.layer.cornerRadius = 10
        borderView.layer.masksToBounds = true
        baseView!.addSubview(borderView)
        
        // add any other subcontent that you want clipped
        borderView.addSubview(profileImageView!)
        
        self.addSubview(baseView!)
    }
    
    func createCircle()
    {
        let circleView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        circleView.backgroundColor = UIColor.whiteColor()
        circleView.layer.cornerRadius = circleView.frame.width / 2
        circleView.layer.masksToBounds = true
        circleView.layer.opacity = 0.3
        
        self.insertSubview(circleView, belowSubview: baseView!)
        
        UIView.animateWithDuration(3.5, delay: 0, options: .CurveEaseOut, animations: {
            circleView.transform = CGAffineTransformMakeScale(3, 3)
            circleView.alpha = 0.0
            }, completion: { (b: Bool) in
                circleView.removeFromSuperview()
        })
        // You can do it! /)(\
        sizeBigger = baseView!.frame.width * 1.2
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            self.baseView?.transform = CGAffineTransformMakeScale(1.2, 1.2)
            }, completion: { (b: Bool) in
                
        })
        
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseOut, animations: {
            self.baseView?.transform = CGAffineTransformMakeScale(self.baseView!.frame.width/self.sizeBigger, self.baseView!.frame.width/self.sizeBigger
            )
            }, completion: { (b: Bool) in
                
        })
        
        circlesToSpawn -= 1
        if circlesToSpawn == 0 { timer?.invalidate() }
    }
}