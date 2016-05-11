//
//  Constants.swift
//  scholarsNearMe
//
//  Created by Michael Verges on 5/7/16.
//

import Foundation
import UIKit

// MARK: Screen Dimensions

let screenSize = UIScreen.mainScreen().bounds
let screenWidth = screenSize.width      //use for device compatibility
let screenHeight = screenSize.height    //use for device compatibility
//e.g. CGPointMake(screenWidth*0.1, screenHeight*0.7)

let userDefaults = NSUserDefaults.standardUserDefaults()

// MARK: User Interface Colors
let colorMain = UIColor(red:0.32, green:0.65, blue:0.98, alpha:1.0)
let colorSecondary = UIColor(red:0.01, green:0.40, blue:0.75, alpha:1.0)
let colorDark = UIColor(red:0.02, green:0.15, blue:0.34, alpha:1.0)
let colorBackground = UIColor .whiteColor()

// MARK: User Variables
var userLoggedin = false //if false, then login, set to true
let userName = String()
let userEmail = String()
let userPhone = String()
let userInstagram = String()
let userFaceBook = String()
let userSnapchat = String()
var profilePicture: UIImageView!
var imageData = NSData()
var firstName: String!
var phoneNumber: Int!
var sms: Bool! = false
var whatsapp: Bool! = false

// MARK: Background
func addBackground(currentViewController: UIViewController, type: String) {
    let background = UIView(frame: screenSize)
    if type == "light" {
        background.backgroundColor = colorBackground
    } else if type == "dark" {
        background.backgroundColor = colorDark
    }
}

func getFontSizeAdditionWithDeviceType() -> CGFloat {
    switch screenSize.width {
    case 320:
        return 1
    case 375:
        return 4
    case 414:
        return 5
    default:
        return 0
    }
}

func getFontSizeAdditioForInformationLabelnWithDeviceType() -> CGFloat {
    switch screenSize.width {
    case 320:
        return 3
    case 375:
        return 4
    case 414:
        return 5
    default:
        return 0
    }
}

func documentsDirectory() -> String {
    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    return documentsFolderPath
}
// File in Documents directory
func fileInDocumentsDirectory(filename: String) -> String {
    return documentsDirectory().stringByAppendingPathComponent(filename)
}

func saveImage(image: UIImage, path: String) -> Bool {
    let pngImageData = UIImagePNGRepresentation(image)
    let result = pngImageData!.writeToFile(path, atomically: true)
    return result
}

var image: UIImage!

func loadImageFromPath(path: String) -> UIImage? {
    
    if let optionalData = NSData(contentsOfFile: path) {
        let data = optionalData
        if let optionalImage = UIImage(data: data) {
            image = optionalImage
        }
    }
    
    return image
    
//    let data = NSData(contentsOfFile: path)
//    let image = UIImage(data: data!)
//    return image
}

extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.stringByAppendingPathComponent(path)
    }
}