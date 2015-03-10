//
//  ViewController.swift
//  Cfast
//
//  Created by Haroon on 26/02/2015.
//  Copyright (c) 2015 Cfast. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ViewController: UIViewController {
    
    let textFieldColor = UIColor(red: 235/255.0, green: 98/255.0, blue: 26/255.0, alpha: 1.0).CGColor
    var doctorsList = ["nsimon", "david@davidbloomdentist.com", "drbk", "Nadeem", "Biju Krishnan", "Cfast Tom"]
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func LoginAction(sender: AnyObject) {
        performAuthentication()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performSomeStyling()
    }
    
    override func viewDidAppear(animated: Bool) {
        bypassLoginIfRegistered()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var homeController: homeViewController = segue.destinationViewController.topViewController as homeViewController
        let status = NSUserDefaults()
        let isDoctorStatus = status.objectForKey("userName") as String
        for doctor in doctorsList{
            if (isDoctorStatus == doctor){
                homeController.isDoctor = true
            }
        }
        
    }
    
    /*
    *
    *   MARK: - Handy methods. Could be modified as per usage.
    *
    */
    func performSomeStyling(){
        loginButton.layer.cornerRadius = 8.0
        userNameField.layer.borderWidth = 0.7
        userNameField.layer.cornerRadius = 8.0
        userNameField.layer.borderColor = textFieldColor
        passwordField.layer.borderWidth = 0.7
        passwordField.layer.cornerRadius = 8.0
        passwordField.layer.borderColor = textFieldColor
    }
    
    func bypassLoginIfRegistered() {
        let defaults = NSUserDefaults()
        let isRegistered = defaults.objectForKey("Status") as? String
        if let result = isRegistered{
            if result == "registeredUser"{
                performSegueWithIdentifier("homeView", sender: self)
            }
        }
    }
    
    func performAuthentication() {
        var progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Please wait"
        progressHUD.detailsLabelText = "Setting things up for you"
        Alamofire.request(.POST, "http://cfast-api.fireflycommunicator.com/api/user", parameters: ["Username": userNameField.text, "Password": passwordField.text])
            .responseJSON { (_, _, JSON, _) in
                if let result: AnyObject = JSON {
                    if let statusCode = result["Status"] as? Bool {
                        progressHUD.hide(true)
                        if statusCode{
                            let getDefaults = NSUserDefaults()
                            getDefaults.setObject(self.userNameField.text, forKey: "userName")
                            getDefaults.setObject("registeredUser", forKey: "Status")
                            getDefaults.synchronize()
                            self.performSegueWithIdentifier("homeView", sender: self)
                        } else {
                            println("Wrong Details")
                            SweetAlert().showAlert("Invalid Credentials", subTitle: "Please provide your valid credentials", style: .Error)
                        }
                    }
                }
        }
    }
    
}

