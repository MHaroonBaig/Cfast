//
//  ProfileViewController.swift
//  Cfast
//
//  Created by Haroon on 28/02/2015.
//  Copyright (c) 2015 Cfast. All rights reserved.
//

import UIKit


class ProfileViewController: FormViewController, FormViewControllerDelegate{
    
    var savedProfile: NSMutableDictionary!
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let jobTag = "job"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        static let button = "button"
        static let textView = "textview"
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var Defaults = NSUserDefaults()
        let values = Defaults.objectForKey("Profile") as? NSMutableDictionary
        if let fetchedValues = values {
            savedProfile = fetchedValues
        }
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .Bordered, target: self, action: "Done:")
    }
    
    func Done(_: UIBarButtonItem!) {
        let dict = self.form.formValues()
        for (key, value) in dict{
            if let shit = dict.objectForKey(key) as? String{
                println("\(shit) --- \(key)")
            } else {
                var a = ""
                var k = key as String
                if let storedShit = savedProfile {
                    dict.setValue(savedProfile[k], forKey: k)
                } else {
                    dict.setValue(a, forKey: k)
                }
            }
        }
        
        let getDefaults = NSUserDefaults()
        getDefaults.setObject(dict, forKey: "Profile")
        getDefaults.synchronize()
        
        SweetAlert().showAlert("Saved", subTitle: "Your profile was successfully updated", style: .Success)
    }
    
    private func loadForm() {
        var email: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var job: String = ""
        var URL: String = ""
        var phone: String = ""
        var notes: String = ""
        
        if let populateForm = savedProfile{
            email = populateForm.objectForKey("email") as String
            firstName = populateForm.objectForKey("name") as String
            lastName = populateForm.objectForKey("lastName") as String
            job = populateForm.objectForKey("job") as String
            URL = populateForm.objectForKey("url") as String
            phone = populateForm.objectForKey("phone") as String
            notes = populateForm.objectForKey("textview") as String
        }
        
        let form = FormDescriptor()
        
        form.title = "Profile"
        
        let section1 = FormSectionDescriptor()
        
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.emailTag, rowType: .Email, title: "Email")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "john@gmail.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": email]
        section1.addRow(row)
      
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.nameTag, rowType: .Name, title: "First Name")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Miguel Ángel", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": firstName]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.lastNameTag, rowType: .Name, title: "Last Name")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Ortuño", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": lastName]
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.jobTag, rowType: .Text, title: "Job")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. Entrepreneur", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": job]
        section2.addRow(row)
        
        let section3 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.URLTag, rowType: .URL, title: "URL")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. gethooksapp.com", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": URL]
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.phoneTag, rowType: .Phone, title: "Phone")
        row.configuration[FormRowDescriptor.Configuration.CellConfiguration] = ["textField.placeholder" : "e.g. 0034666777999", "textField.textAlignment" : NSTextAlignment.Right.rawValue, "textField.text": phone]
        section3.addRow(row)
        
   
        let section5 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Gender")
        row.configuration[FormRowDescriptor.Configuration.Options] = ["F", "M", "U"]
        row.configuration[FormRowDescriptor.Configuration.TitleFormatterClosure] = { value in
            switch( value ) {
            case "F":
                return "Female"
            case "M":
                return "Male"
            case "U":
                return "I'd rather not to say"
            default:
                return nil
            }
            } as TitleFormatterClosure
        
        row.value = "M"
        
        section5.addRow(row)
        
        let section6 = FormSectionDescriptor()
        row = FormRowDescriptor(tag: Static.textView, rowType: .MultilineText, title: "Review")
        
        section6.headerTitle = "Your Review"
        section6.addRow(row)
        
        let section7 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Dismiss")
        section7.addRow(row)
       
        form.sections = [section1, section2, section3, section5, section6, section7]
        
        self.form = form
    }
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        if rowDescriptor.tag == Static.button {
            self.view.endEditing(true)
            
        }
    }

}
