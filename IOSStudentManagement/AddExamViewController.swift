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
    
    func createExamFromFields() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //let examID = examIDField.text as! Int
        
        if let examID = Int(examIDField.text!), let title = titleField.text, let examDescription = examDescriptionField.text, let location = locationField.text {
            appDelegate.insertExam(for: examID, title: title, examDescription: examDescription, location: location, date: examDatePicker.date)
        } else {
            print("Fill out all fields")
        }
    }
    
    func clearFields() {
        examDescriptionField.text = ""
        locationField.text = ""
        titleField.text = ""
        examIDField.text = ""
    }
}
