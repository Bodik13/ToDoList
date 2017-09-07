//
//  ViewController.swift
//  ToDoList
//
//  Created by Bogdan H. on 9/4/17.
//  Copyright © 2017 Bogdan H. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tasks = [Task]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 100/255, green: 173/255, blue: 142/255, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "To-Do List"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tasks = CoreDataManager.tasksData()
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddTask", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableViewCell
        let task = self.tasks[indexPath.row]
        cell.rightLabel.text = task.isCompleted ? "\u{2705}" : "\u{2B1C}"
        cell.textLabel?.text = task.taskName
        cell.detailTextLabel?.text = task.taskDescription
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tasks[indexPath.row].isCompleted = self.tasks[indexPath.row].isCompleted ? false : true
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.deleteTask(task: self.tasks[indexPath.row])
            self.tasks = CoreDataManager.tasksData()
        }
    }
    
}

