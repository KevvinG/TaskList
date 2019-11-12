//
//  TaskController.swift
//  TaskList
//
//  Created by Kevin Grzela on 2019-10-12.
//  Copyright © 2019 KG. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class TaskController {
    func insertTask(newTask: Task) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext

        let taskEntity : NSEntityDescription? = NSEntityDescription.entity(forEntityName: "TaskEntity", in: managedContext)
        
        if (taskEntity != nil) {
            let task = NSManagedObject(entity:taskEntity!, insertInto: managedContext)
            
            task.setValue(newTask.title, forKey: "title")
            task.setValue(newTask.subtitle, forKey: "subtitle")
            
            do {
                try managedContext.save()
                
            } catch let error as NSError {
                print("Insert task failed...\(error)")
            }
        }
        
    }//insertTask
    
    func updateTask(task: Task){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", task.title)

        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            let existingTask = result[0] as! NSManagedObject
            
            existingTask.setValue(task.title, forKey: "title")
            existingTask.setValue(task.subtitle, forKey: "subtitle")
            existingTask.setValue(task.done, forKey: "done")
            do{
                try managedContext.save()
                print("Task update Successful")
            }catch{
                print("Task update unsuccessful")
            }
            
        } catch {
            print("task update unsuccessful")
        }

    }//updateTask
    
    func deleteTask(title: String){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)

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
        
        
    }//deleteTask
    
    func getAllTasks() -> [NSManagedObject]?{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskEntity")
        
        do{
            let result = try managedContext.fetch(fetchRequest)
            return result as? [NSManagedObject]
        }catch{
            print("Data fetching Unsuccessful")
        }
        return nil
    }
    
    
    
    
}
