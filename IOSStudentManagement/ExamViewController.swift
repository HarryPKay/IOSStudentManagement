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

// Allows the user to view, remove exams and navigate to a page to add new exams.
class ExamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Flip the state of the switch when clicked.
    @IBAction func checkBox(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxState[sender.tag] = sender.isSelected
    }
    
    @IBAction func touchDelete(_ sender: UIButton) {
        removeCheckedExams()
        loadExamsToData()
        tableView.reloadData()
    }
    
    // Stores the ID's of exams that should be loaded into the table view
    var data = [String]()
    
    // Stores the state of the checkbox for it's corresponding examID
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
        
        // Get exam details and put them into their corresponding labels
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
            
            // Determine if exam has past, due today or upcomming and.
            if Calendar.current.isDate(Date(), inSameDayAs: exam.date!) {
                flagLabel.text = "Flag: TODAY"
            } else if exam.date! > Date() {
                flagLabel.text = "Flag: UPCOMMING"
            } else {
                flagLabel.text = "Flag: PAST"
            }
        }
        
        // Assign ID to the tag that corresponds to this cell's checkbox so we
        // can determine which checkbox is checked and for which ID's to delete.
        if let selected = cell.viewWithTag(1) as? UIButton {
            checkBoxState[examID] = false
            selected.tag = examID
        }
        
        return cell;
    }
    
    // Show additional details upon clicking an exam.
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadExamsToData()
        tableView.reloadData()
    }
    
    // Retrieve exam IDs and put them into the data array.
    func loadExamsToData() {
        // Ensure that old data is removed
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
    
    // For all checkbox's checked, rempove the corresponding exams by examID
    func removeCheckedExams() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        for (id, isChecked) in checkBoxState {
            if isChecked {
                print("Removing Exam for ID " + String(id))
                appDelegate.removeExam(for: id)
                checkBoxState[id] = nil
            }
        }
        loadView()
    }
}
