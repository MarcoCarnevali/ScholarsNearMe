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

    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIView(frame: screenSize)
        background.backgroundColor = colorDark
        self.view.addSubview(background)
        self.view.sendSubviewToBack(background)
        // Do any additional setup after loading the view, typically from a nib.
        
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
            
            
            Alamofire.request(.POST, "http://napolyglot.com:8080/getscholar", parameters: ["uuid": beacon.proximityUUID])
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
        if userLoggedin == false {
            let newViewController = LoginVC(nibName: "LoginVC", bundle: nil)
            self.presentViewController(newViewController, animated: true, completion: nil)
        } else {
            //FIXME: Add functionality if user logges in
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}




