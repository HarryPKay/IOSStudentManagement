//
//  AppDelegate.swift
//  IOSStudentManagement
//
//  Created by Harry Kay on 21/10/18.
//  Copyright © 2018 Harry Kay. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "IOSStudentManagement")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // TODO have things return entity type instead of NS
    
    func createStudentExamMapping(for studentID: Int, for exams: [Exam]) {
        
        let context = getContext()
        let student = getStudent(for: studentID)
        let s = student as! Student
        
        for exam in exams {
            s.addToExams(exam)
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func storeStudent (for studentID: Int, lName: String, fName: String, dateOfBirth: Date, course: String, gender: String, postCode: String, state: String, city: String, street: String) {
        
        let context = getContext()
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        let student = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        student.setValue(studentID, forKey: "studentID")
        student.setValue(lName, forKey: "lName")
        student.setValue(fName, forKey: "fName")
        student.setValue(dateOfBirth, forKey: "dateOfBirth")
        student.setValue(gender, forKey: "gender")
        student.setValue(course, forKey: "course")
        student.setValue(postCode, forKey: "postCode")
        student.setValue(state, forKey: "state")
        student.setValue(street, forKey: "street")
        student.setValue(city, forKey: "city")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func storeExam(for examID: Int, title: String, examDescription: String, location: String, date: Date) {
        
        //retrieve the entity that we just created
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Exam", in: context)
        let exam = NSManagedObject(entity: entity!, insertInto: context)
        
        exam.setValue(examID, forKey: "examID")
        exam.setValue(title, forKey: "title")
        exam.setValue(examDescription, forKey: "examDescription")
        exam.setValue(location, forKey: "location")
        exam.setValue(date, forKey: "date")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func getStudents () -> [NSManagedObject]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Student> = Student.fetchRequest()
        
        do {
        let searchResults = try getContext().fetch(fetchRequest)
            return searchResults as [NSManagedObject]?
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func getExams () -> [NSManagedObject]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Exam> = Exam.fetchRequest()
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults as [NSManagedObject]?
        } catch {
            print("Error with request: \(error)")
        }
        
        return nil
    }
    
    func getStudent(for ID: Int) -> NSManagedObject? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID = %ld", ID)
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults[0] as? NSManagedObject
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    func getExam(for ID: Int) -> NSManagedObject? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Exam")
        fetchRequest.predicate = NSPredicate(format: "examID = %ld", ID)
        
        do {
            let searchResults = try getContext().fetch(fetchRequest)
            return searchResults[0] as? NSManagedObject
        } catch {
            print("Error with request: \(error)")
        }
        return nil
    }
    
    func updateExam(for examID: Int, title: String, examDescription: String, location: String, date: Date) {
        
        //retrieve the entity that we just created
        let context = getContext()
        
        // Get the exam by ID and then set it's values
        // examID should never change.
        if let exam = getExam(for: examID) {
            exam.setValue(examID, forKey: "examID")
            exam.setValue(title, forKey: "title")
            exam.setValue(examDescription, forKey: "examDescription")
            exam.setValue(location, forKey: "location")
            exam.setValue(date, forKey: "date")
        }
        
        // Attempt to update with new values
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func updateStudent(for studentID: Int, lName: String, fName: String, dateOfBirth: Date, course: String, gender: String, postCode: String, state: String, city: String, street: String) {
        
        let context = getContext()
        
        // Get the student by ID and then set it's values
        // studentID should never change.
        if let student = getStudent(for: studentID) {
            student.setValue(lName, forKey: "lName")
            student.setValue(fName, forKey: "fName")
            student.setValue(dateOfBirth, forKey: "dateOfBirth")
            student.setValue(gender, forKey: "gender")
            student.setValue(course, forKey: "course")
            student.setValue(postCode, forKey: "postCode")
            student.setValue(state, forKey: "state")
            student.setValue(street, forKey: "street")
            student.setValue(city, forKey: "city")
        }
        
        // Attempt to update with new values
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    func removeStudent(for ID: Int) {
        
        let context = getContext()
        
        if let studentToDelete = getStudent(for: ID) {
            context.delete(studentToDelete)
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        return
    }
    
    func removeExam(for ID: Int) {
        
        let context = getContext()
        
        if let examToDelete = getExam(for: ID) {
            context.delete(examToDelete)
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
        
        return
    }
    
    /*func removeRecords () {
        
        let context = getContext()
        // delete everything in the table Person
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }*/
}

