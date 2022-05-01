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
        
    }
    @IBAction func deleteTask(_ sender: Any) {
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    var task: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
