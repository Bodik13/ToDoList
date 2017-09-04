//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Bogdan H. on 9/4/17.
//  Copyright © 2017 Bogdan H. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    // MARK: - Core Data stack
    
    static var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ToDoList")
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
        if CoreDataManager.persistentContainer.viewContext.hasChanges {
            do {
                try CoreDataManager.persistentContainer.viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    class func addTask(taskName: String, taskDescription: String, isCompleted: Bool) {
        
        let task = Task(context: persistentContainer.viewContext)
        task.taskName = taskName
        task.taskDescription = taskDescription
        task.isCompleted = isCompleted
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    class func tasksData() -> [Task] {
        var tasks = [Task]()
        do {
            tasks = try persistentContainer.viewContext.fetch(Task.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        return tasks
    }
    
    class func deleteTask(task: Task) {
        do {
            persistentContainer.viewContext.delete(task)
        } catch {
            print("Error with request: \(error)")
        }
        do {
            try persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}
