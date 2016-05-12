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
    var forceTouchInformationLabel: UILabel!
    var loginButton: DeformationButton!
    var bounds = UIScreen.mainScreen().bounds
    
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
    
    

    
    
    func loginButtonPressed(sender: UIButton!) {

        
        if firstName != nil && profilePicture != nil {
            loginButton.backgroundColor = UIColor ( red: 0.0706, green: 0.1569, blue: 0.3098, alpha: 1.0 )
            // Save UUID in NSUserDefaults
            UUID = UIDevice.currentDevice().identifierForVendor!.UUIDString
            if let uuid = UUID {
                DataService.ds.setValue(value: uuid, forKey: "UUID-Key")
            }
            
            // Add user to the DB
            print(UUID)
            print("CIAO")
            
            imageData = UIImagePNGRepresentation(profilePicture.image!)!
            
            let imageText : String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            let jsonObject: [String: AnyObject] = ["uuid": UUID, "name": firstNameTextField.text!, "img": imageText]
            
            Alamofire.request(.POST, "http://napolyglot.com:8080/addscholar", parameters: jsonObject)
                .responseJSON { response in
                    let error = response.result.error
                    let json = response.result.value
                    print("Login response: ",json)
                    print("Login error: ",error)
                    
                    if error != nil{
                        self.loginButton.stopLoading()
                        print("SERVER ERROR")
                    }else if json != nil {
                        
                        userDefaults.setObject(true, forKey: "logged")
                        userDefaults.synchronize()
                        
                        let triggerTime = (Int64(NSEC_PER_SEC) * 4)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.loginButton.stopLoading()
                        })
                    }
                    
            }
            
            
            
            
            
            

            
            userDefaults.setObject(firstName, forKey: "firstName")
            userDefaults.setObject(imageData, forKey: "profilePictureData")
            userDefaults.synchronize()
            
            
        }
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefaults.boolForKey("logged") == true {
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
        
        
        
        forceTouchInformationLabel = UILabel(frame: CGRectMake(0, 0, bounds.width-bounds.width/10, bounds.height/18))
        forceTouchInformationLabel.text = "Creates a 3D Touch shortcut to contact someone nearby"
        forceTouchInformationLabel.center = CGPoint(x: bounds.width/2, y: bounds.height/20*13.5)
        forceTouchInformationLabel.font = UIFont(name: "Avenir-Light", size: 7+getFontSizeAdditioForInformationLabelnWithDeviceType())
        forceTouchInformationLabel.textColor = UIColor ( red: 0.8627, green: 0.8824, blue: 0.9294, alpha: 0.4 )
        forceTouchInformationLabel.textAlignment = .Center
        //        self.view.addSubview(forceTouchInformationLabel)
        
        
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

