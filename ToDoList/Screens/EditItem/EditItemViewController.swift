//
//  EditItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 01/05/2022.
//

import UIKit

class EditItemViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func saveChanges(_ sender: Any) {
        if let index = self.taskIndex {
            let newTask = Task(name: nameTextField.text ?? "New Task",
                               description: descriptionTextField.text ?? "Task Description",
                               date: datePicker.date,
                               completed: false)
            TodoListManager.shared.editTask(newTask: newTask, at: index) {
                navigationController?.popViewController(animated: true)
            }
        }
        
    }
    @IBAction func deleteTask(_ sender: Any) {
        if let index = self.taskIndex {
            TodoListManager.shared.deleteTask(at: index) {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var taskIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = self.taskIndex {
            nameTextField.text = TodoListManager.shared.tasks[index].name
            descriptionTextField.text = TodoListManager.shared.tasks[index].description
            datePicker.date = TodoListManager.shared.tasks[index].date
            
        }
        // Do any additional setup after loading the view.
    }
}
