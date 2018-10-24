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
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var editLabel: UIButton!
    
    var isInEditingMode = false;
    var data = [String]()
    //var data : String
    
    // return the size of the array to tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    
    // Assign each element in data to it's own cell within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row]
        
        return cell;
    }
    
    // Responds to user selecting specific cells within table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get the studentID that corresponds to this cell.
        let strStudentID = data[indexPath.row].split(separator: ",")
        let studentID = Int(strStudentID[0]) ?? -1
        
        // Retrieve that student's detail and echo it.
        if studentID == -1 {
            return
        }
        let student = appDelegate.getStudent(for: studentID)
        let dateOfBirthDate = student?.value(forKey: "dateOfBirth") as! Date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateOfBirth = formatter.string(from: dateOfBirthDate)
        
        let message = "Student ID:\t" + strStudentID[0]
        + "\nFirst Name:\t" + (student?.value(forKey: "fName") as! String)
        + "\nLast Name:\t" + (student?.value(forKey: "lName") as! String)
        + "\nGender:\t" + (student?.value(forKey: "gender") as! String)
        + "\ncourse:\t" + (student?.value(forKey: "course") as! String)
        + "\ndateOfBirth:\t" + dateOfBirth
        + "\naddress:\t"
        
        let alertController = UIAlertController(title: "Student Details:", message: message, preferredStyle: .alert)
        
       //let alertfName = UIAlertController(
        
        let alertActionCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        //TODO: show exams
        let alertActionAddExam = UIAlertAction(title: "Add Exam", style: .default, handler: { action in self.jumpToAddStudentView() })
        
        let alertActionEditStudent = UIAlertAction(title: "Edit Student", style: .default, handler: { action in self.jumpToAddStudentView() })
        
        alertController.addAction(alertActionAddExam)
        alertController.addAction(alertActionEditStudent)
        alertController.addAction(alertActionCancel)

        present(alertController, animated: true, completion: nil)
        
        /*let alertController = UIAlertController(title: "Hint", message: "You have selected row \(indexPath.row).", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil) */
 
    }
    
    // deletes students
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // Get the studentID for the corresponding cell selected
        let strStudentID = data[indexPath.row].split(separator: ",")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Are we editing students and therefor
        // also able to delete students.
        if editingStyle == .delete {
            
            // Delete the student if found
            if let studentID = Int(strStudentID[0]) {
                
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
    

    @IBAction func editButton(_ sender: UIButton) {
        flipEditMode();
    }
    
    func jumpToAddStudentView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddStudentViewController")
        self.present(controller, animated: true, completion: nil)
        
        // Safe Present
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddStudentViewController") as? AddStudentViewController
        {
            present(vc, animated: true, completion: nil)
        }
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
            
            for x in students {
                
                var row = ""
                
                if let studentID = x.value(forKey: "studentID") as? Int {
                    row += String(studentID)
                }
                
                row += ", "
                row += x.value(forKey: "fName") as! String
                row += ", "
                row += x.value(forKey: "lName") as! String
                data.append(row)
            }
        }
    }
}

