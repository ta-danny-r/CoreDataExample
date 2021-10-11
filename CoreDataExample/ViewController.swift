//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Danny on 10/11/21.
//


/*
 SQL, MYSQL uses relational database. It consist of tables, rows, columns, and unique keys.
 
 Core Data uses relational database as an Object Database.
 Core Data uses SQLite
 
 */

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // NSManagedObject represents a single object stored in Core Data
    // A base class that implements the behavior required of a Core Data model object.
    // NSManagedObject is used to create, delete, edit, and save from your Core Data persistent store.
    var student = [NSManagedObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStudentAgeToCoreData()
        fetchFromCoreData()
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    // This function is an example of how to store data attributes to Core Data
    func addStudentAgeToCoreData() {
        
        // Get instance of App Delegate
        // so we can have access to App Delegate properties and functions
        // we will be using persistentContainer from App Delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //  First we need to get instance of NSManaged Object Context.
        // NSManaged Object Context is read only.
        let managedContent = appDelegate.persistentContainer.viewContext
        
        
        // Next we need to get instance of Entity by using NSEntityDescription.entity()
        // Please make sure that the entity name is the same as the entity name in the data model (.xcdatamodel) file.
        // Why? The name we set for the Entity has to be connected to the Entity name from (.xcdatamodel) file.
        // In this example. The entity name is Student. In my (.xcdatamodel) file the Entity name is also Student
        let entity = NSEntityDescription.entity(forEntityName: "Student", in: managedContent)!
    
        
        // Get instance of NSManagedObject
        let studentName = NSManagedObject(entity: entity, insertInto: managedContent)
        
        
        // Core Data uses Key-Value Coding for its attributes in (.xcdatamodel) file.
        // We set value to for certain key that is shown from our (.xcdatamodel) file
        studentName.setValue(getRandomInt(), forKey: "age")
        
        
        // Last we need to save the data to Core Data.
        // To do this we need to call the saveContext() function from AppDelegate
        appDelegate.saveContext()
        student.append(studentName)
    }
    
    func fetchFromCoreData() {
        // Get instance of App Delegate
        // so we can have access to App Delegate properties and functions
        // we will be using persistentContainer from App Delegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        //  First we need to get instance of NSManaged Object Context.
        // NSManaged Object Context is read only.
        let managedContent = appDelegate.persistentContainer.viewContext
        
        // NSFetchRequest is used to fetch data from Core Data
        // A fetch request must contain an entity description or an entity name that specifies which entity to search.
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Student")
        
        
        // now we need to fetch data from Core Data
        // This can be done by calling fetch() from NSManaged Object Context
        // But fetch() can throw an error. This is why we are using a try/catch block
        do {
            student = try managedContent.fetch(fetchRequest)
        } catch {
            print("Something went wrong. Could not save. Error: \(error)")
        }
        
    }
    
    // A function that returns a random Integer from 1 - 50
    func getRandomInt() -> Int {
        return Int.random(in: 1...50)
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        let currentStudent = student[indexPath.row] // getting student from every row in table view cell
        cell.textLabel?.text = String(currentStudent.value(forKeyPath: "age") as! Int64)
        print("\(currentStudent)")
        return cell
    }
    
}

