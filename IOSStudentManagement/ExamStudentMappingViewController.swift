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

class ExamStudentMappingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath)
        
        let titleLabel = cell.contentView.viewWithTag(101) as! UILabel
        
            titleLabel.text = data[indexPath.row]
        
        if let selected = cell.viewWithTag(1) as? UIButton {
            
            let strExamID = data[indexPath.row].split(separator: ",")
            let examID = Int(strExamID[0]) ?? 0
            checkBoxState[examID] = false
            
            selected.tag = examID
        }
        
        return cell;
    }
    
    @IBOutlet weak var taskReminderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isRemovingMapping {
            taskReminderLabel.text = "Removing Exam from Student"
        }
        else {
            taskReminderLabel.text = "Assigning Exam to Student"
        }
        
        loadExamsToData()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func touchDone(_ sender: UIButton) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        var exams = [Exam]()
        let exam = appDelegate.getExam(for: 1) as! Exam
        exams.append(exam)
        appDelegate.createStudentExamMapping(for: studentID!, for: exams)
        
        /*if let student = appDelegate.getStudent(for: studentID!) {
            print("ok")
            if let exam = appDelegate.getExam(for: 1), let exam2 = appDelegate.getExam(for: 2) {
                print("ok")
                var s = student as! Student
                var e = exam as! Exam
                var ee = exam2 as! Exam
                s.addToExams(e)
                s.addToExams(ee)
            }
        }
        if let student = appDelegate.getStudent(for: studentID!) {
            var s = student as! Student
            
            let arr = s.exams?.allObjects as! [Exam]
            
            for exam in arr {
                print("ok")
            }
        }
        
        if let exam = appDelegate.getExam(for: 1) {
            let e = exam as! Exam
            
            let arr = e.students?.allObjects as! [Student]
            for student in arr {
                print("ok")
            }
        }*/
        
        
    }
    
    func loadExamsToData() {
        
        data.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if let exams = appDelegate.getExams() {
            
            for x in exams {
                
                var row = ""
                if let examID = x.value(forKey: "examID") as? Int {
                    row += String(examID)
                }
                row += ", "
                row += x.value(forKey: "title") as! String
                data.append(row)
            }
        }
    }
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxState[sender.tag] = sender.isSelected
        
    }
}
