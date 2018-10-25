//
//  ExamViewController.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 25/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = [String]()
    var checkBoxState = [Int: Bool]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // Assign each element in data to it's own cell within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt
        indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "examCell", for: indexPath)
        cell.textLabel!.text = data[indexPath.row]
        
        if let selected = cell.viewWithTag(1) as? UIButton {
            
            let strExamID = data[indexPath.row].split(separator: ",")
            let examID = Int(strExamID[0]) ?? 0
            checkBoxState[examID] = false
            
            selected.tag = examID
        }
        
        return cell;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExamsToData()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func touchDelete(_ sender: UIButton) {
        removeCheckedExams()
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
    
    func removeCheckedExams() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for (id, isChecked) in checkBoxState {
            if isChecked {
                print("Removing Exam for ID" + String(id))
                appDelegate.removeExam(for: id)
            }
        }
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxState[sender.tag] = sender.isSelected
        
    }
}
