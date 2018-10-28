//
//  ExamStudentMappingViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 26/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Allows assigning/deassigning exams to a student. Also provides navigation to a page to add additional exams.
class ExamStudentMappingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var taskReminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExamsToData()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExamsToData()
        tableView.reloadData()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func touchDeassign(_ sender: UIButton) {
        deassignExamToStudent()
        loadExamsToData()
        tableView.reloadData()
        //loadView()
    }
    
    @IBAction func touchAssign(_ sender: UIButton) {
        assignExamToStudent()
        loadExamsToData()
        tableView.reloadData()
        //loadView()
    }
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxState[sender.tag] = sender.isSelected
    }
    
    var data = [String]()
    var checkBoxState = [Int: Bool]()
    var studentID: Int?
    var isRemovingMapping = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // Assign each element in data to it's own cell within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath)
        let examID = Int(data[indexPath.row]) ?? 0
        
        if let exam = appDelegate.getExam(for: examID) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy hh:mm:ss"
            let IDLabel = cell.contentView.viewWithTag(10001) as! UILabel
            IDLabel.text = String(examID)
            let titleLabel = cell.contentView.viewWithTag(10002) as! UILabel
            titleLabel.text = exam.title
            let dateLabel = cell.contentView.viewWithTag(10003) as! UILabel
            dateLabel.text = dateFormatter.string(from: exam.date!)
            let locationLabel = cell.contentView.viewWithTag(10004) as! UILabel
            locationLabel.text = exam.location
            let flagLabel = cell.contentView.viewWithTag(10005) as! UILabel
            
           // Determine if exam has past.
            if Calendar.current.isDate(Date(), inSameDayAs: exam.date!) {
                flagLabel.text = "Flag: Exam Happens Today"
            } else if exam.date! > Date() {
                flagLabel.text = "Flag: Upcomming Exam"
            } else {
                flagLabel.text = "Flag: Past Exam"
            }
            
            // Determine if student is already assigned to the exam and display accordingly.
            let isAssignedLabel = cell.contentView.viewWithTag(10006) as! UILabel
            let student = appDelegate.getStudent(for: studentID!)
            if appDelegate.doesRelationshipExist(student: student!, exam: exam) {
                isAssignedLabel.text = "Assigned"
            } else {
                isAssignedLabel.text = ""
            }
        }
        
        // Assign examID to the checkbox tag.
        if let selected = cell.viewWithTag(1) as? UIButton {
            checkBoxState[examID] = false
            selected.tag = examID
        }
        
        return cell;
    }
    
    // Show additional information when exam is selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let examID = Int(data[indexPath.row]) ?? 0
        let exam = appDelegate.getExam(for: examID)
        let message = exam?.examDescription
        let alertController = UIAlertController(title: "Exam Details:", message: message, preferredStyle: .alert)
        let alertActionCancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(alertActionCancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func assignExamToStudent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for (id, isChecked) in checkBoxState {
            if isChecked {
                print("Assigning Exam for ID " + String(id) + " to student ID " + String(studentID!))
                let exam = appDelegate.getExam(for: id)!
                var exams = [Exam]()
                exams.append(exam)
                appDelegate.createStudentExamMapping(for: studentID!, for: exams)
                checkBoxState[id] = false
            }
        }
    }
    
    func deassignExamToStudent() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for (id, isChecked) in checkBoxState {
            if isChecked {
                print("Deassigning Exam for ID " + String(id) + " to student ID " + String(studentID!))
                let exam = appDelegate.getExam(for: id)!
                var exams = [Exam]()
                exams.append(exam)
                appDelegate.removeStudentExamMapping(for: studentID!, for: exams)
                checkBoxState[id] = false
            }
        }
    }
    
    //
    func loadExamsToData() {
        
        data.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let exams = appDelegate.getExams() {
            for x in exams {
                var row = ""
                if let examID = x.value(forKey: "examID") as? Int {
                    row = String(examID)
                    data.append(row)
                }
            }
        }
    }
}
