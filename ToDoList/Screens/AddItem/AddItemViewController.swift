//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class AddItemViewController: UIViewController {

    
    // MARK: - Variables
    @IBOutlet weak var taskNameLabel: UITextField!
    @IBOutlet weak var taskDescriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    // MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        let newTask = Task(name: taskNameLabel.text ?? "New Task",
                           description: taskDescriptionLabel.text ?? "No additional info",
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
