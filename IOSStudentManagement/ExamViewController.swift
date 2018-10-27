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
        }
        
        if let selected = cell.viewWithTag(1) as? UIButton {
            checkBoxState[examID] = false
            selected.tag = examID
        }
        
        return cell;
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadExamsToData()
        tableView.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExamsToData()
        tableView.reloadData()
    }
    
    
    @IBAction func touchDelete(_ sender: UIButton) {
        removeCheckedExams()
        loadExamsToData()
        tableView.reloadData()
    }
    
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
    
    func removeCheckedExams() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for (id, isChecked) in checkBoxState {
            print(String(id))
            if isChecked {
                print("Removing Exam for ID" + String(id))
                appDelegate.removeExam(for: id)
                checkBoxState[ id] = nil
            }
        }
        loadView()
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxState[sender.tag] = sender.isSelected
    }
}
