//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import UIKit
import CoreData

class AddStudentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        course = pickerData[row]
    }
    
    var pickerData = ["Mobile Apps Development", "Computer Graphics", "Technologies for Web Development", "Object Oriented Analysis", "Programming Techniques", "Computer Networking"]
    
    var course: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.coursePicker.dataSource = self
        self.coursePicker.delegate = self
    }
    
    @IBOutlet weak var studentIDField: UITextField!
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var dateOfBirthDP: UIDatePicker!
    @IBOutlet weak var coursePicker: UIPickerView!
    

    @IBAction func touchDone(_ sender: UIBarButtonItem) {
        
        var gender = ""
        if genderSC.selectedSegmentIndex == 0 {
            gender = "Male"
        }
        if genderSC.selectedSegmentIndex == 1 {
            gender = "Female"
        }

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //appDelegate.removeRecords()
        appDelegate.storeStudent(studentID: Int(studentIDField.text!)!, lName: lNameField.text!, fName: fNameField.text!, dateOfBirth: dateOfBirthDP.date, course: course, gender: gender)
    }
}

