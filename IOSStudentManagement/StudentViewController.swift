//
//  ViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import UIKit
import CoreData

class StudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource   {
    
    // Jumps to the page for adding new students.
    // Optionally will edit students if a student
    // id is given instead.
    func jumpToModifyStudentView(with studentID: Int?) {

        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ModifyStudentViewController") as? ModifyStudentViewController
        {
            vc.studentToModifyByID = studentID
            present(vc, animated: true, completion: nil)
        }
    }
    
    func jumpToExamStudentMappingView(with studentID: Int) {
        
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ExamStudentMappingViewController") as? ExamStudentMappingViewController
        {
            vc.studentID = studentID
            present(vc, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var editLabel: UIButton!
    
    var isInEditingMode = false;
    var data = [String]()
    
    // return the size of the array to tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    // Assign each element in data to it's own cell within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row]
        let studentID = Int(data[indexPath.row])
        if let student = appDelegate.getStudent(for: studentID!) {
            cell.detailTextLabel?.text = student.fName! + ", " + student.lName!
        }
        
        return cell;
    }
    
    // Responds to user selecting specific cells within table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get the studentID that corresponds to this cell.
        let strStudentID = data[indexPath.row]
        
        // Get the student
        let studentID = Int(strStudentID) ?? -1
        let student = appDelegate.getStudent(for: studentID)!
    
        // Retrieve the date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOfBirth = formatter.string(from: student.dateOfBirth!)
        
        // Retrive Student details
        let studentDetails = "Student ID: " + strStudentID
            + "\nFirst Name: " + student.fName!
            + "\nLast Name: " + student.lName!
            + "\nGender: " + student.gender!
            + "\ndateOfBirth: " + dateOfBirth
            + "\n\ncourse:\n" + student.course!
        // Retrieve student's address
        let studentAddress = "\n\naddress:\n" + student.street!
            + " " + student.city!
            + " " + student.state!
            + " " + student.postCode!
        let message = studentDetails + studentAddress
        
        // Create the alert to show information and provide additional options.
        let alertController = UIAlertController(title: "Student Details:", message: message, preferredStyle: .alert)
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let alertActionExamManipulation = UIAlertAction(title: "Exam Manipulation", style: .default, handler: { action in self.jumpToExamStudentMappingView(with: studentID) })
        let alertActionShowOnMap = UIAlertAction(title: "Show on Map", style: .default, handler: { action in self.jumpToModifyStudentView(with: nil) })
        let alertActionEditStudent = UIAlertAction(title: "Edit Student", style: .default, handler: { action in self.jumpToModifyStudentView(with: studentID)})
        let alertActionRemoveStudent = UIAlertAction(title: "Remove Student", style: .destructive, handler: {
            action in appDelegate.removeStudent(for: studentID)
            self.loadStudentsToData()
            self.tableView.reloadData() })
        
        alertController.addAction(alertActionExamManipulation)
        alertController.addAction(alertActionEditStudent)
        alertController.addAction(alertActionRemoveStudent)
        alertController.addAction(alertActionShowOnMap)
        alertController.addAction(alertActionCancel)

        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Get the studentID for the corresponding cell selected
        let strStudentID = data[indexPath.row]
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Are we editing students and therefor
        // also able to delete students.
        if editingStyle == .delete {
            
            // Delete the student if found
            if let studentID = Int(strStudentID) {
                
                appDelegate.removeStudent(for: studentID)
                loadStudentsToData()
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentsToData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStudentsToData()
        tableView.reloadData()
    }

    @IBAction func editButton(_ sender: UIButton) {
        flipEditMode();
    }
    
    func flipEditMode() {
        
        isInEditingMode = !isInEditingMode
        
        // If we are editing, show label for finishing
        if isInEditingMode {
            editLabel.setTitle("Done", for: UIControl.State.normal)
            tableView.setEditing(true, animated: true)
        }
        else {
          editLabel.setTitle("Delete", for: UIControl.State.normal)
            tableView.setEditing(false, animated: true)
        }
    }
    
    // Gets all students and puts their data into the data array
    // studentID, fName and lName.
    func loadStudentsToData() {
        
        data.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let students = appDelegate.getStudents() {
            for student in students {
                data.append(String(student.studentID))
            }
        }
    }
}

