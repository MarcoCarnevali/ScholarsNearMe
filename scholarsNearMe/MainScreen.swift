//
//  ViewController.swift
//  scholarsNearMe
//
//  Created by Eli Yazdi on 5/7/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth
import Alamofire

class MainScreen: UIViewController, CBPeripheralManagerDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var localBeacon: CLBeaconRegion!
    var beaconPeripheralData: NSDictionary!
    var peripheralManager: CBPeripheralManager!
    
    var UUID: NSUUID?
    var imageViewForAnimationAfterRegistration: UIImageView!
    var animatedProfilePicture = AnimatedProfilePicture(frame: CGRectMake(0, 0, screenWidth/2*1.1, screenWidth/2*1.1))
    
    func moveObject(object: AnyObject, toX: CGFloat, toY: CGFloat, duration: CFTimeInterval, delay: CFTimeInterval) {
        CATransaction.begin()
        
        let currentLayerTime = object.layer.convertTime(CACurrentMediaTime(), fromLayer: nil)
        let fromPoint : CGPoint = CGPointZero
        let toPoint: CGPoint = CGPointMake(toX, toY)
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.additive = true
        animation.fromValue =  NSValue(CGPoint: fromPoint)
        animation.toValue =  NSValue(CGPoint: toPoint)
        animation.duration = duration
        animation.beginTime = currentLayerTime + delay
        animation.removedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        object.layer.addAnimation(animation, forKey: "move")
        
        CATransaction.commit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIView(frame: screenSize)
        background.backgroundColor = colorDark
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        // Do any additional setup after loading the view, typically from a nib.
        print("MainScreen")
        userLoggedin = userDefaults.boolForKey("logged")
        if userLoggedin == true {
            print("userLoggedIn")
            
            //            if let loadedImage = UIImage(named: "step1") {
            //                print(" Loaded Image: \(loadedImage)")
            //                animatedProfilePicture.setProfilePicture(loadedImage)
            //                self.view.addSubview(animatedProfilePicture)
            //                // /Users/niklasbalazs/Library/Developer/CoreSimulator/Devices/84388A5E-AF41-4354-9DC1-93380B4BF0FE/data/Containers/Data/Application/94A94A22-0D0D-4AFB-889F-714736BBAF2F/Documents/profilePicture.png
            //                // /Users/niklasbalazs/Library/Developer/CoreSimulator/Devices/84388A5E-AF41-4354-9DC1-93380B4BF0FE/data/Containers/Data/Application/94A94A22-0D0D-4AFB-889F-714736BBAF2F/Documents/profilePicture.png
            //                moveObject(animatedProfilePicture, toX: 0, toY: screenHeight/20*11.5, duration: 1, delay: 1)
            //                // scaleView(animatedProfilePicture, scaleX: 2, scaleY: 2, duration: 1, delay: 1) // Not working as excpected
            //                delay(1.0) {
            //                    self.animatedProfilePicture.startAnimating(0)
            //                }
            //
            //            }
            
            //            print(userDefaults.objectForKey("imagePath"))
            //
            //            if let optionalImagePath = userDefaults.objectForKey("imagePath") as? String {
            //                let imagePath = optionalImagePath as! String
            //                if let loadedImage = loadImageFromPath(imagePath) {
            //                    animatedProfilePicture.setProfilePicture(loadedImage)
            //                    self.view.addSubview(animatedProfilePicture)
            //                    delay(1.0) {
            //                        self.animatedProfilePicture.startAnimating(0)
            //                    }
            //                }
            //            }
            
            //            if let loadedImage = loadImageFromPath(imagePath) {
            //                animatedProfilePicture.setProfilePicture(loadedImage)
            //                self.view.addSubview(animatedProfilePicture)
            //                delay(1.0) {
            //                    self.animatedProfilePicture.startAnimating(0)
            //                }
            //            }
            
        } else {
            print("Error")
        }
        
        
        //
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        if let h = DataService.ds.valueForKey("UUID-Key") as? NSUUID {
            UUID = h
        }
        
        
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons {
            
            
            Alamofire.request(.GET, "http://napolyglot.com:8080/getscholar", parameters: ["uuid": beacon.proximityUUID])
                .responseJSON { response in
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
            }
        }
        
    }
    
    // iBeacon transmisor functions!
    func initLocalBeacon() {
        if localBeacon != nil {
            stopLocalBeacon()
        }
        
        let localBeaconUUID = UUID
        let localBeaconMajor: CLBeaconMajorValue = 123
        let localBeaconMinor: CLBeaconMinorValue = 456
        
        let uuid = NSUUID(UUIDString: String(localBeaconUUID))!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Your private identifer here")
        
        beaconPeripheralData = localBeacon.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }
    
    func stopLocalBeacon() {
        peripheralManager.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if peripheral.state == .PoweredOn {
            peripheralManager.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .PoweredOff {
            peripheralManager.stopAdvertising()
        }
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        if userDefaults.boolForKey("logged") == false {
            print("userRegister")
            let newViewController = LoginVC(nibName: "LoginVC", bundle: nil)
            self.presentViewController(newViewController, animated: true, completion: nil)
            userDefaults.synchronize()
        } else if userDefaults.boolForKey("logged"){
            print("User already registered Appeared!")
            // imagePath = userDefaults.objectForKey("imagePath") as! String
            // print(imagePath)
            print(userDefaults.objectForKey("imagePath"))
            
            if let optionalImagePath = userDefaults.objectForKey("imagePath") as? String {
                let imagePath = optionalImagePath
                if let loadedImage = loadImageFromPath(imagePath) {
                    if userDefaults.boolForKey("afterRegistration") {
                        
                    } else {
                        imageViewForAnimationAfterRegistration = UIImageView(frame: CGRectMake(0, 0, screenWidth/2, screenWidth/2))
                        imageViewForAnimationAfterRegistration.center = CGPoint(x: screenWidth/2, y: screenHeight/5)
                        imageViewForAnimationAfterRegistration.image = loadedImage
                        imageViewForAnimationAfterRegistration.layer.cornerRadius = imageViewForAnimationAfterRegistration.frame.width / 2
                        imageViewForAnimationAfterRegistration.clipsToBounds = true
                        imageViewForAnimationAfterRegistration.contentMode = .ScaleAspectFill
                        imageViewForAnimationAfterRegistration.layer.shadowColor = UIColor.blackColor().CGColor
                        imageViewForAnimationAfterRegistration.layer.shadowOffset = CGSize(width: 3, height: 3)
                        imageViewForAnimationAfterRegistration.layer.shadowOpacity = 0.7
                        imageViewForAnimationAfterRegistration.layer.shadowRadius = 4.0
                        
                        delay(1) {
                            self.moveObject(self.imageViewForAnimationAfterRegistration, toX: 0, toY: screenHeight/20*14, duration: 0.8, delay: 0)
                            scaleView(self.imageViewForAnimationAfterRegistration, scaleX: 1.1, scaleY: 1.1, duration: 0.8, delay: 0)
                        }
                        self.view.addSubview(imageViewForAnimationAfterRegistration)
                        
                        animatedProfilePicture.setProfilePicture(loadedImage)
                        // /Users/niklasbalazs/Library/Developer/CoreSimulator/Devices/84388A5E-AF41-4354-9DC1-93380B4BF0FE/data/Containers/Data/Application/94A94A22-0D0D-4AFB-889F-714736BBAF2F/Documents/profilePicture.png
                        // /Users/niklasbalazs/Library/Developer/CoreSimulator/Devices/84388A5E-AF41-4354-9DC1-93380B4BF0FE/data/Containers/Data/Application/94A94A22-0D0D-4AFB-889F-714736BBAF2F/Documents/profilePicture.png
                        delay(2.0) {
                            self.view.addSubview(self.animatedProfilePicture)
                            self.view.willRemoveSubview(self.imageViewForAnimationAfterRegistration)
                            self.animatedProfilePicture.startAnimating(0)
                        }
                        userDefaults.setBool(true, forKey: "afterRegistration")
                    }
                }
            }
            
        } else {
            print("Major login error!!")
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        animatedProfilePicture.createCircle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}




