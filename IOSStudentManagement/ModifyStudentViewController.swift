//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import UIKit
import CoreData

class ModifyStudentViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // Is set by StudentViewController when user wishes to edit student information.
    // Used by this class to get student values, preload fields and to submit updates.
    var studentToModifyByID: Int?
    
    func preloadFields() {
        if studentToModifyByID == nil {
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let student = appDelegate.getStudent(for: studentToModifyByID!)
        studentIDField.text = String(studentToModifyByID ?? -1)
        fNameField.text = student?.value(forKey: "fName") as? String
        lNameField.text = student?.value(forKey: "lName") as? String
        streetField.text = student?.value(forKey: "street") as? String
        stateField.text = student?.value(forKey: "state") as? String
        cityField.text = student?.value(forKey: "city") as? String
        postCodeField.text = student?.value(forKey: "postCode") as? String
        
        if (student?.value(forKey: "gender") as! String) == "Male" {
            genderSC.selectedSegmentIndex = 0;
        }
        else {
            genderSC.selectedSegmentIndex = 1;
        }
        
        let selectedCourse = student?.value(forKey: "course") as! String
        // Default to the first row if course cannot be determined
        let indexOfSelectedCourse = pickerData.firstIndex(of: selectedCourse) ?? 0
        coursePicker.selectRow(indexOfSelectedCourse, inComponent: 0, animated: true)
        
        dateOfBirthDP.date = student?.value(forKey: "dateOfBirth") as! Date
    }
    
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
        preloadFields()
        
        if studentToModifyByID == nil {
            deleteButton.isEnabled = false
        }
    }
    
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var postCodeField: UITextField!
    @IBOutlet weak var studentIDField: UITextField!
    @IBOutlet weak var fNameField: UITextField!
    @IBOutlet weak var lNameField: UITextField!
    @IBOutlet weak var genderSC: UISegmentedControl!
    @IBOutlet weak var dateOfBirthDP: UIDatePicker!
    @IBOutlet weak var coursePicker: UIPickerView!
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchDelete(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let studentToDeleteByID = studentToModifyByID {
            appDelegate.removeStudent(for: studentToDeleteByID)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func touchDone(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Retrieve text from fields that are not text labels
        var gender = ""
        if genderSC.selectedSegmentIndex == 0 {
            gender = "Male"
        }
        if genderSC.selectedSegmentIndex == 1 {
            gender = "Female"
        }
        
        // If nothing was selected, ensure that the first item shows up as a selected course
        if course.isEmpty {
            course = pickerData[0]
        }
        
        //TODO: check that all fields are full
        // Should we update?
        if studentToModifyByID != nil {
            
            appDelegate.updateStudent(for: Int(studentIDField.text!)!, lName: lNameField.text!, fName: fNameField.text!, dateOfBirth: dateOfBirthDP.date, course: course, gender: gender, postCode: postCodeField.text!, state: stateField.text!, city: cityField.text!, street:  streetField.text!)
            dismiss(animated: true, completion: nil)
            
            // Or be adding new students?
        } else {
            
            appDelegate.storeStudent(for: Int(studentIDField.text!)!, lName: lNameField.text!, fName: fNameField.text!, dateOfBirth: dateOfBirthDP.date, course: course, gender: gender, postCode: postCodeField.text!, state: stateField.text!, city: cityField.text!, street:  streetField.text!)
            clearFields()
        }
    }
    
    func clearFields() {
        studentIDField.text = ""
        fNameField.text = ""
        lNameField.text = ""
        streetField.text = ""
        stateField.text = ""
        cityField.text = ""
        postCodeField.text = ""
    }
}

