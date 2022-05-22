//
//  EditItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 01/05/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovku EditTaskViewController.storyboard.
class EditTaskViewController: UIViewController {
    
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completedSwitch: UISwitch!
    
    
    // MARK: - Variables
    /// Pozicia tasku v zozname
    var position: taskPosition?
    private let hapticFeedback = UIImpactFeedbackGenerator()

    
    
    // MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla Save. Vytvori task z dat ziskanych z atributov pre UI elementy a nasledne zavola edit funkciu z manazera, ktoremu ako parameter posle novo vytvoreny task a ``position``.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func saveChanges(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let position = self.position,
           let text = nameTextField.text {
            let name = text.isEmpty ? NSLocalizedString("new_task", comment: "default name, if the name box wasn't filled") : text
            let newTask = Task(name: name,
                               description: descriptionTextField.text ?? "",
                               date: datePicker.date,
                               completed: completedSwitch.isOn)
            TodoListManager.shared.editTask(newTask: newTask, at: position) {
                dismiss(animated: true)
            }
        }
        
    }
    
    /// Metoda reagujuca na udalost stlacenia tlacidla delete. Zavola delete funkciu z manazera, ktoremu posle ``position`` ako parameter.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func deleteTask(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let index = self.position {
            TodoListManager.shared.deleteTask(at: index) {
                dismiss(animated: true)
            }
        }
    }
    
    /// Metoda reagujuca na udalost stlacenia tlacidla Choose template. Pushne novu obrazovku TemplatePickViewController. Ak sa v nom vyberie nejaka sablona, jej hodnoty atributov nastavi do ``nameTextField`` a ``descriptionTextField``.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func chooseTemplate(_ sender: Any) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "TemplatePickViewController", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "TemplatePickViewController") as? TemplatePickViewController {
            navigationController?.pushViewController(viewController, animated: true)
            viewController.completionHandler = { template in
                self.nameTextField.text = template.name
                self.descriptionTextField.text = template.description
            }
        }
    }
    
    /// Metoda reagujuca na udalost stlacenia tlacidla Cancel. Zavola dismiss nad touto obrazovkou.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func cancel(_ sender: Any) {
        hapticFeedback.impactOccurred()
        dismiss(animated: true)
    }
    
    // MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa naloaduje View z ViewControllera. V tejto metode sa nastavia atributy UI elementov na hodnoty, ktore ma task v zozname manazera na pozicii ulozenej v ``position``.
    override func viewDidLoad() {
        super.viewDidLoad()
        if let position = self.position {
            let task = TodoListManager.shared.listOfTasks[position.section].tasks[position.row]
            nameTextField.text = task.name
            descriptionTextField.text = task.description
            datePicker.date = task.date
            completedSwitch.isOn = task.completed
        }
    }
}
