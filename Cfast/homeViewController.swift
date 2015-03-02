//
//  homeViewController.swift
//  Cfast
//
//  Created by Haroon on 26/02/2015.
//  Copyright (c) 2015 Cfast. All rights reserved.
//

import UIKit
import MBProgressHUD


class homeViewController: UIViewController  {
    
    let buttonBorderColor = UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 0.7).CGColor
    var isDoctor: Bool = false
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    @IBAction func allChatsAction(sender: AnyObject) {
        var progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Please wait"
        progressHUD.detailsLabelText = "Configuring your chat"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            var fireBase = FireBaseViewController()
            fireBase.isQuery = false
            fireBase.isDoctor = self.isDoctor
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                NSLog("Class instantiation successful")
                progressHUD.hide(true)
                self.navigationController?.pushViewController(fireBase, animated: true)
            })
        })
        
    }
    
    
    @IBAction func queryAction(sender: AnyObject) {
        
        var progressHUD = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        progressHUD.labelText = "Please wait"
        progressHUD.detailsLabelText = "Loading up your queries"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            var fireBase = FireBaseViewController()
            fireBase.isQuery = true
            fireBase.isDoctor = self.isDoctor
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                progressHUD.hide(true)
                NSLog("Class instantiation successful")
                self.navigationController?.pushViewController(fireBase, animated: true)
            })
        })
        
    }
    
    
    @IBAction func profileAction(sender: AnyObject) {
        NSLog("Profile View loaded successfully")
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 10.0
        submitButton.layer.borderColor = buttonBorderColor
        
        chatButton.layer.cornerRadius = 10.0
        chatButton.layer.borderColor = buttonBorderColor
        
        profileButton.layer.cornerRadius = 10.0
        profileButton.layer.borderColor = buttonBorderColor
        
        if isDoctor {
            submitButton.hidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
