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

// MARK: Background
func addBackground(currentViewController: UIViewController, type: String) {
    let background = UIView(frame: screenSize)
    if type == "light" {
        background.backgroundColor = colorBackground
    } else if type == "dark" {
        background.backgroundColor = colorDark
    }
}