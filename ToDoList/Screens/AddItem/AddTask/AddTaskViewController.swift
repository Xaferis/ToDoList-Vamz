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
    
        if let text = taskNameLabel.text {
            let name = text.isEmpty ? NSLocalizedString("new_task", comment: "default name, if the name box wasn't filled") : text
            let newTask = Task(name: name,
                               description: taskDescriptionLabel.text ?? "",
                               date: datePicker.date,
                               completed: false)
            TodoListManager.shared.addTask(task: newTask) {
                dismiss(animated: true)
            }
        }
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
