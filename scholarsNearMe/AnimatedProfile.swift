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
    var circlesToSpawn = 7
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        createProfilePicture()
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        createProfilePicture()
    }
    
    func startAnimating(delay: CGFloat)
    {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: #selector(createCircle), userInfo: nil, repeats: true)
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
        
        self.insertSubview(circleView, belowSubview: baseView!)
        
        UIView.animateWithDuration(1.5, delay: 0, options: .CurveEaseOut, animations: {
            circleView.transform = CGAffineTransformMakeScale(2, 2)
            circleView.alpha = 0.0
            }, completion: { (b: Bool) in
                circleView.removeFromSuperview()
        })
        
        circlesToSpawn -= 1
        if circlesToSpawn == 0 { timer?.invalidate() }
    }
}