//
//  ProfileView.swift
//  scholarsNearMe
//
//  Created by Niklas Balazs on 13/05/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import UIKit

class ProfileView: UIViewController {
    
    var scholarImage: UIImageView!
    var scholarFirstNameLabel: UILabel!
    
    var bounds = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red:0.02, green:0.15, blue:0.34, alpha:1.0)
        
        scholarImage = UIImageView()
        scholarImage.frame = CGRectMake(0, 0, bounds.width/2, bounds.width/2)
        scholarImage.center = CGPoint(x: bounds.width/2, y: bounds.height/5)
        scholarImage.backgroundColor = UIColor ( red: 0.0431, green: 0.1255, blue: 0.2745, alpha: 1.0 )
        scholarImage.layer.borderColor = UIColor.whiteColor().CGColor
        scholarImage.layer.borderWidth = 0.5
        scholarImage.layer.cornerRadius = 0.5 * scholarImage.frame.width
        scholarImage.layer.masksToBounds = true
        self.view.addSubview(scholarImage)
        
        scholarFirstNameLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        scholarFirstNameLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*9)
        scholarFirstNameLabel.backgroundColor = UIColor ( red: 0.0779, green: 0.1399, blue: 0.267, alpha: 1.0 )
        scholarFirstNameLabel.font = UIFont(name: "Avenir-Light", size: 10+getFontSizeAdditionWithDeviceType())
        scholarFirstNameLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 1.0 )
        scholarFirstNameLabel.textAlignment = .Center
        scholarFirstNameLabel.layer.borderColor = UIColor ( red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0 ).CGColor
        self.view.addSubview(scholarFirstNameLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
