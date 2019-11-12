//
//  TaskVC.swift
//  TaskList
//
//  Created by Kevin Grzela on 2019-10-12.
//  Copyright © 2019 KG. All rights reserved.
//

import UIKit
import CoreData

class TaskVC: UITableViewController {
    
    var taskList: [NSManagedObject] = []
    
    let taskController = TaskController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "TaskList"
        self.setupLongPressGesture()
//        deleteAllRecords()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TaskEntity")
        
        //3
        do {
            taskList = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell_task", for: indexPath) as! TaskCell
        
//        let allTasks = taskController.getAllTasks()
        
        if indexPath.row < taskList.count
        {
            let task = taskList[indexPath.row]
//            cell.lblTitle?.text = task.title
//            cell.lblSubtitle?.text = task.subtitle
            
//            let task = allTasks![indexPath.row]
            cell.lblTitle?.text = (task.value(forKey: "title") as! String)
            cell.lblSubtitle?.text = (task.value(forKey: "subtitle") as! String)
           // user.value(forKey: "firstname") as! String
            
//            let accessory: UITableViewCell.AccessoryType = task.done ? .checkmark : .none
            let accessory: UITableViewCell.AccessoryType = task.value(forKey: "done") as! Bool ? .checkmark : .none
            cell.accessoryType = accessory
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < taskList.count
        {
            let task = taskList[indexPath.row]
//            task.done = !task.done
            
            var isDone = task.value(forKey: "done") as! Bool
            isDone = !isDone
            task.setValue(isDone, forKey: "done")
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if indexPath.row < taskList.count
        {
            self.deleteTask(indexPath: indexPath)
        }
    }
    
    @IBAction func onAddClick(_ sender: UIBarButtonItem) {
        // Create an alert
        let alert = UIAlertController(
            title: "New task",
            message: "Enter the new task details",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField{(textField : UITextField) in
            textField.placeholder = "What you wanna do ?"
        }
        alert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "More specification"
        }
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.addTask(title: title, subtitle: subtitle)
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        self.tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.displayEditAlert(indexPath: indexPath)
            }
        }
    }
    
    private func displayEditAlert(indexPath: IndexPath){
        
        // Create an alert
        let alert = UIAlertController(
            title: "Edit task",
            message: "Enter the updated task details",
            preferredStyle: .alert)
        
        // Add a text field to the alert for the new item's title
        alert.addTextField{(textField : UITextField) in
//            textField.text = self.taskList[indexPath.row].title
            textField.text = (self.taskList[indexPath.row].value(forKey:"title") as! String)
        }
        alert.addTextField { (textField: UITextField) in
//            textField.text = self.taskList[indexPath.row].subtitle
                        textField.text = (self.taskList[indexPath.row].value(forKey:"subtitle") as! String)
        }
        
        // Add a "cancel" button to the alert. This one doesn't need a handler
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Add a "OK" button to the alert. The handler calls addNewToDoItem()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            if let title = alert.textFields?[0].text, let subtitle = alert.textFields?[1].text
            {
                self.editTask(indexPath: indexPath, title: title, subtitle: subtitle)
            }
        }))
        
        // Present the alert to the user
        self.present(alert, animated: true, completion: nil)
    }
    
    private func addTask(title: String, subtitle: String)
    {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let taskEntity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)
    
        if (taskEntity != nil) {
            let task = NSManagedObject(entity:taskEntity!, insertInto: managedContext)
            
            task.setValue(title, forKey: "title")
            task.setValue(subtitle, forKey: "subtitle")
            task.setValue(false, forKey: "done")
            
            do {
                try managedContext.save()
                taskList.append(task)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        // The index of the new item will be the current item count
//        let newIndex = taskList.count
        
        // Create new item and add it to the task list
//        taskList.append(Task(title: title, subtitle: subtitle)!)
        
        // Tell the table view a new row has been created
//        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
        tableView.reloadData()
        
//        let newTask = Task(title: title, subtitle: subtitle)
        
//        if newTask != nil{
//            taskController.insertTask(newTask: newTask!)
            
//        }
    }
        
        
    
    private func deleteTask(indexPath: IndexPath){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", taskList[indexPath.row].value(forKey: "title") as! String)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let existingTask = result[0] as! NSManagedObject
            
            managedContext.delete(existingTask)
            
            do{
                try managedContext.save()
                print("Task delete Successful")
            }catch{
                print("Task delete unsuccessful")
            }
            
        }catch{
            
        }
        //remove item from task list
        taskList.remove(at: indexPath.row)
        
        //delete the row from table view
        tableView.deleteRows(at: [indexPath], with: .top)
        
        tableView.reloadData()
    }
    
    private func editTask(indexPath: IndexPath, title: String, subtitle: String){
//        taskList[indexPath.row].title = title
//        taskList[indexPath.row].subtitle = subtitle
        
        taskList[indexPath.row].setValue(title, forKey: "title")
        taskList[indexPath.row].setValue(subtitle, forKey: "subtitle")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            let existingTask = result[0] as! NSManagedObject
            
            
            
//            managedContext.delete(existingUser)
            existingTask.setValue(title, forKey: "title")
            existingTask.setValue(subtitle, forKey:"subtitle")
            
            do{
                try managedContext.save()
                print("Task update Successful")
            }catch{
                print("Task update unsuccessful")
            }
            
        }catch{
            
        }
    

            tableView.reloadData()
        
    }
}

