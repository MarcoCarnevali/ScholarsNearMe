//
//  LoginVC.swift
//  scholarsNearMe
//
//  Created by Niklas Balazs on 07/05/16.
//  Copyright © 2016 Niklas Balazs. All rights reserved.
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
    var loginButton: DeformationButton!
    var bounds = UIScreen.mainScreen().bounds
    
    var wrongPhoneNumber = false
    
    var UUID: String!
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func addImagePressed(sender: UIButton!) {
        let message = "Add a profile picture from the library or take a new picture"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let cameraAction = UIAlertAction(title: "Take photo", style: .Default, handler: { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        })
        alert.addAction(cameraAction)
        
        let libraryAction = UIAlertAction(title: "Photo library", style: .Default, handler: { _ in
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePickerController, animated: true, completion: nil)
        })
        alert.addAction(libraryAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let theInfo = info as NSDictionary
        let img = theInfo.objectForKey(UIImagePickerControllerOriginalImage) as! UIImage
        let myencodedImage = NSKeyedArchiver.archivedDataWithRootObject(img)
        DataService.ds.setObject(value: myencodedImage, forKey: "Profile-Image")
        addImage.setImage(img, forState: .Normal)
        profilePicture = UIImageView()
        profilePicture.image = img
        addImage.contentMode = UIViewContentMode.ScaleAspectFill
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editingDidEndFirstNameTextFieldTextField(sender: UITextField!) {
        firstName = firstNameTextField.text
    }
    
    func editingDidBeginPhoneNumberTextFieldTextField(sender: UITextField!) {
        phoneNumber = Int(phoneNumberTextField.text!)
    }
    
    func editingDidEndPhoneNumberTextFieldTextField(sender: UITextField!) {
        if phoneNumberTextField.text?.substringFromIndex((phoneNumberTextField.text?.startIndex)!) == "+" {
            phoneNumberTextField.text?.removeAtIndex((phoneNumberTextField.text?.startIndex)!)
        }
        if let number = Int((phoneNumberTextField.text)!) {
            phoneNumber = number
        } else {
            phoneNumber = nil
            let alertTwo = UIAlertView()
            alertTwo.message = "Change the number in order to create an account"
            alertTwo.addButtonWithTitle("Ok")
            alertTwo.title = "Not a valid number"
            alertTwo.show()
            self.view.endEditing(true)
        }
        if let phoneNumberCopy = phoneNumber {
            print(phoneNumberCopy)
        }
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
        if phoneNumberTextField.text?.substringFromIndex((phoneNumberTextField.text?.startIndex)!) == "+" {
            phoneNumberTextField.text?.removeAtIndex((phoneNumberTextField.text?.startIndex)!)
        }
        if let number = Int((phoneNumberTextField.text)!) {
            phoneNumber = number
            wrongPhoneNumber = false
        } else {
            phoneNumber = nil
            wrongPhoneNumber = true
        }
        if firstName != nil && phoneNumber != nil && profilePicture != nil {
            var storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            var vc = storyboard.instantiateViewControllerWithIdentifier("MainScreen") as! MainScreen
            loginButton.backgroundColor = UIColor ( red: 0.0706, green: 0.1569, blue: 0.3098, alpha: 1.0 )
                         // Save UUID in NSUserDefaults
             if let uuid = UUID {
             DataService.ds.setValue(value: uuid, forKey: "UUID-Key")
             }
             
             // Add user to the DB
             print(UUID)
 
             let jsonObject: [String: AnyObject] = ["uuid": UUID, "name": firstNameTextField.text!, "img": "nothingSoFar", "sms": sms, "whatsapp": whatsapp, "number": phoneNumber]
             
             Alamofire.request(.POST, "http://napolyglot.com:8080/addscholar", parameters: jsonObject)
                .responseJSON { response in
                    let error = response.result.error
                    let json = response.result.value
                    print("Login response: ",json)
                    print("Login error: ",error)
                    
                    if error != nil{
                        
                        
                    }else if json != nil {
                        userLoggedin = true
                        let triggerTime = (Int64(NSEC_PER_SEC) * 4)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                            self.loginButton.stopLoading()
                        })
                    }
                    
            }
        
            
            
            
            
            
            imagePath = fileInDocumentsDirectory("profilePicture.png")
            
            if profilePicture.image != nil {
                // Save it to our Documents folder
                let result = saveImage(profilePicture.image!, path: imagePath)
                print("Image saved? Result: (result)")
                
                // Load image from our Documents folder
                var loadedImage = loadImageFromPath(imagePath)
                if loadedImage != nil {
                    print("Image loaded: (loadedImage!)")
                    profilePicture.image = loadedImage
                }
            }
            
        
            
            userDefaults.setObject(firstName, forKey: "firstName")
            userDefaults.setObject(phoneNumber, forKey: "phoneNumber")
            userDefaults.setObject(sms, forKey: "sms")
            userDefaults.setObject(whatsapp, forKey: "whatsapp")
            userDefaults.setObject(imagePath, forKey: "imagePath")
            userDefaults.setBool(userLoggedin, forKey: "userLoggedIn")
            userDefaults.synchronize()
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        } else if wrongPhoneNumber {
            self.loginButton.stopLoading()
            let alertTwo = UIAlertView()
            alertTwo.message = "Change the number in order to create an account"
            alertTwo.addButtonWithTitle("Ok")
            alertTwo.title = "Not a valid number"
            alertTwo.show()
            self.view.endEditing(true)
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.boolForKey("userLoggedIn") == true {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Not logged in, loaded login VC")
        }
        
        if let _ = DataService.ds.valueForKey("UUID-Key") as? String {
            
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
        phoneNumberTextField.keyboardType = UIKeyboardType.PhonePad
        phoneNumberTextField.returnKeyType = UIReturnKeyType.Done
        phoneNumberTextField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        phoneNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.Center
        phoneNumberTextField.layer.borderColor = UIColor ( red: 0.8667, green: 0.8667, blue: 0.8667, alpha: 1.0 ).CGColor
        phoneNumberTextField.addTarget(self, action: #selector(LoginVC.editingDidBeginPhoneNumberTextFieldTextField(_:)), forControlEvents: UIControlEvents.EditingChanged)
        phoneNumberTextField.addTarget(self, action: #selector(LoginVC.editingDidEndPhoneNumberTextFieldTextField(_:)), forControlEvents: UIControlEvents.EditingDidEnd)
        self.view.addSubview(phoneNumberTextField)
        
        forceTouchInformationLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        forceTouchInformationLabel.text = "Creates a 3D Touch shortcut to contact someone nearby"
        forceTouchInformationLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*13.5)
        forceTouchInformationLabel.font = UIFont(name: "Avenir-Light", size: 7+getFontSizeAdditioForInformationLabelnWithDeviceType())
        forceTouchInformationLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.4 )
        forceTouchInformationLabel.textAlignment = .Center
//        self.view.addSubview(forceTouchInformationLabel)
        
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
        
        loginButton = DeformationButton(frame: CGRectMake(firstNameTextField.frame.origin.x, UIScreen.mainScreen().bounds.height-60, bounds.width-bounds.width/10, 40), color: UIColor ( red: 0.0431, green: 0.1255, blue: 0.2745, alpha: 1.0 ))

        loginButton.forDisplayButton.setTitle("Login", forState: .Normal)
        loginButton.addTarget(self, action: #selector(LoginVC.loginButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.backgroundColor = UIColor ( red: 0.0431, green: 0.1255, blue: 0.2745, alpha: 1.0 )
        loginButton.forDisplayButton.titleLabel?.font = UIFont(name: "Avenir-Light", size: 20+getFontSizeAdditionWithDeviceType())
        loginButton.forDisplayButton.setTitleColor(UIColor ( red: 0.8309, green: 0.8526, blue: 0.9116, alpha: 0.8 ), forState: .Normal)
   
        loginButton.addTarget(self, action: #selector(LoginVC.loginButtonPressed(_:)), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loginButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

