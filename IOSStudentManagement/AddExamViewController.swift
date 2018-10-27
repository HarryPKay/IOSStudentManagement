//
//  AddExamViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 25/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Allows the user to add new exams.
class AddExamViewController: UIViewController {
    
    @IBOutlet weak var examDatePicker: UIDatePicker!
    @IBOutlet weak var examDescriptionField: UITextView!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var examIDField: UITextField!
    
    @IBAction func touchDone(_ sender: UIButton) {
        createExamFromFields()
        clearFields()
    }
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //  Takes information entered into the fields and inserts a new student record.
    func createExamFromFields() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let examID = Int(examIDField.text!), let title = titleField.text, let examDescription = examDescriptionField.text, let location = locationField.text {
            appDelegate.insertExam(for: examID, title: title, examDescription: examDescription, location: location, date: examDatePicker.date)
        } else {
            print("Fill out all fields")
        }
    }
    
    // Clears all the fields for add new exams.
    func clearFields() {
        examDescriptionField.text = ""
        locationField.text = ""
        titleField.text = ""
        examIDField.text = ""
    }
}
