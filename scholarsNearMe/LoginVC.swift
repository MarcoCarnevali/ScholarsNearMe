//
//  LoginVC.swift
//  scholarsNearMe
//
//  Created by Niklas Balazs on 07/05/16.
//  Copyright © 2016 Eli Yazdi. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var addImage: UIButton!
    var firstNameTextFieldLabel: UILabel!
    var firstNameTextField: UITextField!
    var phoneNumberTextFieldLabel: UILabel!
    var phoneNumberTextField: UITextField!
    var forceTouchInformationLabel: UILabel!
    var smsLabel: UILabel!
    var smsSwitch: UISwitch!
    var whatsAppLabel: UILabel!
    var whatsAppSwitch: UISwitch!
    var loginButton: UIButton!
    var bounds = UIScreen.mainScreen().bounds
    
    var sms: Bool! = false
    var whatsapp: Bool! = false
    
    var firstName: String!
    var phoneNumber: String!
    
    var UUID: String!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getFontSizeAdditionWithDeviceType() -> CGFloat {
        switch bounds.width {
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
        switch bounds.width {
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
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        let imagePickerController = UIImagePickerController()
        switch buttonIndex{
        case 0:
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        case 1:
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        case 2:
            print("Cancel")
        default:
            print("Error")
        }
        
    }
    
    func addImagePressed(sender: UIButton!) {
        var alert = UIAlertView()
        alert.delegate = self
        alert.message = "Add a profile picture from the library or take a new picture"
        alert.addButtonWithTitle("Photo library")
        alert.addButtonWithTitle("Take photo")
        alert.addButtonWithTitle("Cancel")
        alert.title = "Add a profile picture"
        alert.show()
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let theInfo = info as NSDictionary
        let img = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        let myencodedImage = NSKeyedArchiver.archivedDataWithRootObject(img)
        DataService.ds.setObject(value: myencodedImage, forKey: "Profile-Image")
        addImage.setImage(img, forState: .Normal)
        addImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editingDidEndFirstNameTextFieldTextField(sender: UITextField!) {
        firstName = firstNameTextField.text
    }
    
    func editingDidEndphoneNumberTextFieldTextField(sender: UITextField!) {
        phoneNumber = phoneNumberTextField.text
    }
    
    func smsSwitchPressed(sender: UISwitch!) {
        if smsSwitch.on {
          sms = true
        } else {
          sms = false
        }
    }
    
    func whatsAppSwitchPressed(sender: UISwitch!) {
        if whatsAppSwitch.on {
          whatsapp = true
        } else {
          whatsapp = false
  
        }
    }
    
    func loginButtonPressed(sender: UIButton!) {
        if firstName != nil && phoneNumber != nil {
            loginButton.backgroundColor = UIColor ( red: 0.0706, green: 0.1569, blue: 0.3098, alpha: 1.0 )
            //self.presentViewController(nextViewController, animated: true, completion: nil)
            // Save UUID in NSUserDefaults
            if UUID == nil {
                //FIXME: you can't set a nil value for a key in a NSUserDefault
//                UUID = NSUUID().UUIDString
                DataService.ds.setValue(value: UUID, forKey: "UUID-Key")
            }
            
            // Add user to the DB
            let jsonObject: [String: AnyObject] = ["uuid": UUID, "name": firstNameTextField.text!, "img": "nothingSoFar", "sms": sms, "whatsapp": whatsapp, "number": phoneNumberTextField.text!]
            
            Alamofire.request(.POST, "http://napolyglot.com:8080/addscholar", parameters: jsonObject)

            //FIXME: set userLoggedIn to true and dismiss login view controller
            
        } else {
            let alert = UIAlertController(title: "Data not filled!", message:"Ha! Not that quick, fill in your name and phone first!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in })
            self.presentViewController(alert, animated: true){}
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let h = DataService.ds.valueForKey("UUID-Key") as? String {
            
        } else {
            UUID = NSUUID().UUIDString
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        addImage = UIButton(type: UIButtonType.Custom)
        addImage.frame = CGRectMake(0, 0, bounds.width/2, bounds.width/2)
        addImage.center = CGPoint(x: bounds.width/2, y: bounds.height/5)
        addImage.setTitle("Add a profile picture", forState: .Normal)
        addImage.addTarget(self, action: #selector(LoginVC.addImagePressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        addImage.backgroundColor = UIColor ( red: 0.0431, green: 0.1255, blue: 0.2745, alpha: 1.0 )
        addImage.titleLabel?.font = UIFont(name: "Avenir-Light", size: 15+getFontSizeAdditionWithDeviceType())
        addImage.setTitleColor(UIColor ( red: 0.8309, green: 0.8526, blue: 0.9116, alpha: 0.8 ), forState: .Normal)
        addImage.layer.borderColor = UIColor.whiteColor().CGColor
        addImage.layer.borderWidth = 0.5
        addImage.layer.cornerRadius = 0.5 * addImage.frame.width
        addImage.layer.masksToBounds = true
        self.view.addSubview(addImage)
        
        firstNameTextFieldLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        firstNameTextFieldLabel.text = " Name"
        firstNameTextFieldLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*8)
        firstNameTextFieldLabel.font = UIFont(name: "Avenir-Light", size: 15+getFontSizeAdditionWithDeviceType())
        firstNameTextFieldLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.8 )
        firstNameTextFieldLabel.textAlignment = .Left
        self.view.addSubview(firstNameTextFieldLabel)
        
        firstNameTextField = UITextField(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        firstNameTextField.center = CGPoint(x: bounds.width/2, y: bounds.height/20*9)
        firstNameTextField.backgroundColor = UIColor ( red: 0.0779, green: 0.1399, blue: 0.267, alpha: 1.0 )
        firstNameTextField.font = UIFont(name: "Avenir-Light", size: 10+getFontSizeAdditionWithDeviceType())
        firstNameTextField.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 1.0 )
        firstNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        firstNameTextField.autocorrectionType = UITextAutocorrectionType.No
        firstNameTextField.keyboardType = UIKeyboardType.Default
        firstNameTextField.returnKeyType = UIReturnKeyType.Done
        firstNameTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        firstNameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        firstNameTextField.layer.borderColor = UIColor ( red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0 ).CGColor
        firstNameTextField.addTarget(self, action: #selector(LoginVC.editingDidEndFirstNameTextFieldTextField(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(firstNameTextField)
        
        phoneNumberTextFieldLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        phoneNumberTextFieldLabel.text = " Phone number"
        phoneNumberTextFieldLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*10.5)
        phoneNumberTextFieldLabel.font = UIFont(name: "Avenir-Light", size: 15+getFontSizeAdditionWithDeviceType())
        phoneNumberTextFieldLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.8 )
        phoneNumberTextFieldLabel.textAlignment = .Left
        self.view.addSubview(phoneNumberTextFieldLabel)
        
        phoneNumberTextField = UITextField(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        phoneNumberTextField.center = CGPoint(x: bounds.width/2, y: bounds.height/20*11.5)
        phoneNumberTextField.backgroundColor = UIColor ( red: 0.0779, green: 0.1399, blue: 0.267, alpha: 1.0 )
        phoneNumberTextField.font = UIFont(name: "Avenir-Light", size: 10+getFontSizeAdditionWithDeviceType())
        phoneNumberTextField.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 1.0 )
        phoneNumberTextField.borderStyle = UITextBorderStyle.RoundedRect
        phoneNumberTextField.autocorrectionType = UITextAutocorrectionType.No
        phoneNumberTextField.keyboardType = UIKeyboardType.Default
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Done
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        phoneNumberTextField.layer.borderColor = UIColor ( red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0 ).CGColor
        phoneNumberTextField.addTarget(self, action: #selector(LoginVC.editingDidEndphoneNumberTextFieldTextField(_:)), forControlEvents: UIControlEvents.EditingChanged)
        self.view.addSubview(phoneNumberTextField)
        /*
        forceTouchInformationLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        forceTouchInformationLabel.text = "Creates a 3D Touch shortcut to contact someone nearby"
        forceTouchInformationLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*13.5)
        forceTouchInformationLabel.font = UIFont(name: "Avenir-Light", size: 7+getFontSizeAdditioForInformationLabelnWithDeviceType())
        forceTouchInformationLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.4 )
        forceTouchInformationLabel.textAlignment = .Center
        self.view.addSubview(forceTouchInformationLabel)
        */
        smsLabel = UILabel(frame: CGRectMake(0, 0, bounds.width/4, bounds.height/18))
        smsLabel.text = "SMS"
        smsLabel.center = CGPoint(x: bounds.width/8*3, y: bounds.height/20*15)
        smsLabel.font = UIFont(name: "Avenir-Light", size: 15+getFontSizeAdditionWithDeviceType())
        smsLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.8 )
        smsLabel.textAlignment = .Left
        self.view.addSubview(smsLabel)
        
        smsSwitch = UISwitch(frame: CGRectMake(0, 0, bounds.width/4, bounds.height/18))
        smsSwitch.center = CGPoint(x: bounds.width/8*5, y: bounds.height/20*15)
        smsSwitch.on = false
        smsSwitch.addTarget(self, action: #selector(LoginVC.smsSwitchPressed(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(smsSwitch)
        
        whatsAppLabel = UILabel(frame: CGRectMake(0, 0, bounds.width/4, bounds.height/18))
        whatsAppLabel.text = "WhatsApp"
        whatsAppLabel.center = CGPoint(x: bounds.width/8*3, y: bounds.height/20*16.3)
        whatsAppLabel.font = UIFont(name: "Avenir-Light", size: 15+getFontSizeAdditionWithDeviceType())
        whatsAppLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.8 )
        whatsAppLabel.textAlignment = .Left
        self.view.addSubview(whatsAppLabel)
        
        whatsAppSwitch = UISwitch(frame: CGRectMake(0, 0, bounds.width/4, bounds.height/18))
        whatsAppSwitch.center = CGPoint(x: bounds.width/8*5, y: bounds.height/20*16.3)
        whatsAppSwitch.on = false
        whatsAppSwitch.addTarget(self, action: #selector(LoginVC.whatsAppSwitchPressed(_:)), forControlEvents: .ValueChanged)
        self.view.addSubview(whatsAppSwitch)
        
        loginButton = UIButton(type: UIButtonType.Custom)
        loginButton.frame = CGRectMake(0, 0, bounds.width-bounds.width/10, 40)
        loginButton.center = CGPoint(x: bounds.width/2, y: bounds.height/20*18.5)
        loginButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(LoginVC.loginButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = UIColor ( red: 0.0431, green: 0.1255, blue: 0.2745, alpha: 1.0 )
        loginButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 20+getFontSizeAdditionWithDeviceType())
        loginButton.setTitleColor(UIColor ( red: 0.8309, green: 0.8526, blue: 0.9116, alpha: 0.8 ), forState: .Normal)
        loginButton.layer.borderColor = UIColor ( red: 0.8542, green: 0.8541, blue: 0.8541, alpha: 0.6 ).CGColor
        loginButton.layer.borderWidth = 0.0
        loginButton.layer.cornerRadius = 0.2 * loginButton.frame.height
        loginButton.layer.masksToBounds = true
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

