//
//  ProfilePictureController.swift
//  Cfast
//
//  Created by Haroon on 10/03/2015.
//  Copyright (c) 2015 Cfast. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary

class ProfilePictureController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var fromCameraOutlet: UIButton!
    
    var newMedia: Bool!
    
    @IBAction func fromCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }

    
    }
    
    @IBOutlet weak var fromCameraRoll: UIButton!
    
    @IBAction func fromCameraRollAction(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fromCameraOutlet.layer.borderColor = UIColor(red: 85/255.0, green: 122/255.0, blue: 165/255.0, alpha: 1.0).CGColor
        fromCameraOutlet.layer.borderWidth = 0.5
        fromCameraOutlet.layer.cornerRadius = 5.0
        
        fromCameraRoll.layer.borderColor = UIColor(red: 224/255.0, green: 52/255.0, blue: 184/255.0, alpha: 1.0).CGColor
        
        fromCameraRoll.layer.borderWidth = 0.5
        fromCameraRoll.layer.cornerRadius = 5.0
        

        self.navigationItem.title = "Profile Picture"
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let destinationPath = documentsPath.stringByAppendingPathComponent("profilePictureUpdated.jpg")
        
        let profileImage = UIImage(contentsOfFile: destinationPath)
        
        if let profileImageSaved = profileImage?.size{
            imageView.image = profileImage
        } else {
            imageView.image = UIImage(named: "blankProfile")
        }
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            let image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            
            var url = info[UIImagePickerControllerReferenceURL] as NSURL
            
            println(url)
            var r = ALAssetsLibrary()
            r.assetForURL(url, resultBlock: { (aa: ALAsset!) -> Void in
                println(aa.defaultRepresentation().filename())
                }, failureBlock: nil)
            
            
            imageView.image = image

            let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            let destinationPath = documentsPath.stringByAppendingPathComponent("profilePictureUpdated.jpg")
            UIImageJPEGRepresentation(image,1.0).writeToFile(destinationPath, atomically: true)

            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        }
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
        else {
            println(error)
        }
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
