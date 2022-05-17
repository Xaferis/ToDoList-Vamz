//
//  EditItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 01/05/2022.
//

import UIKit

class EditItemViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    
    // MARK: - Variables
    var taskIndex: Int?
    
    
    // MARK: - Actions
    @IBAction func saveChanges(_ sender: Any) {
        if let index = self.taskIndex {
            let newTask = Task(name: nameTextField.text ?? NSLocalizedString("new_task", comment: "default name, if the name box wasn't filled"),
                               description: descriptionTextField.text ?? NSLocalizedString("task_desc", comment: "default task description, if the description box wasn't filled"),
                               date: datePicker.date,
                               completed: completedSwitch.isOn)
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
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        if let index = self.taskIndex {
            let task = TodoListManager.shared.getTasks()[index]
            nameTextField.text = task.name
            descriptionTextField.text = task.description
            datePicker.date = task.date
            completedSwitch.isOn = task.completed
            
        }
    }
}
