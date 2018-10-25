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

class ExamStudentMappingViewController: UIViewController {
    
    var studentID: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
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
    
    
    @IBAction func touchBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
