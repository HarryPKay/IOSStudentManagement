//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController {

    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var dateOfBirthDP: UIDatePicker!
    @IBOutlet weak var coursePicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func touchDone(_ sender: UIBarButtonItem) {
        
        var gender = ""
        
        if genderSC.selectedSegmentIndex == 0 {
            gender = "Male"
        }
        if genderSC.selectedSegmentIndex == 1 {
            gender = "Female"
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.insertStudent(studentID: 1, fName: fNameField.text!, lName: lNameField.text!, gender: gender, dateOfBirth: dateOfBirthDP.date)
    }
}

