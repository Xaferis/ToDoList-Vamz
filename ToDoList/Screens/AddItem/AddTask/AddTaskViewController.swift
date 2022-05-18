//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    
    // MARK: - Variables
    @IBOutlet weak var taskNameLabel: UITextField!
    @IBOutlet weak var taskDescriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        let newTask = TaskModel(name: taskNameLabel.text ?? NSLocalizedString("new_task", comment: "default name, if the name box wasn't filled"),
                           description: taskDescriptionLabel.text ?? NSLocalizedString("task_desc", comment: "default task description, if the description box wasn't filled"),
                           date: datePicker.date, completed: false)
        TodoListManager.shared.addTask(task: newTask) {
            dismiss(animated: true)
        }
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
