//
//  AddItemViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovku AddTaskViewController.storyboard.
class AddTaskViewController: UIViewController {

    
    // MARK: - Outlets
    @IBOutlet weak var taskNameLabel: UITextField!
    @IBOutlet weak var taskDescriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    //MARK: - Variables
    private let hapticFeedback = UIImpactFeedbackGenerator()
    
    
    // MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla Save. Vytvori task z dat ziskanych z atributov pre UI elementy a nasledne zavola add funkciu z manazera, ktoremu ako parameter posle novo vytvoreny task.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func saveButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
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

    /// Metoda reagujuca na udalost stlacenia tlacidla Cancel. Zavola dismiss nad touto obrazovkou.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func cancel(_ sender: Any) {
        hapticFeedback.impactOccurred()
        dismiss(animated: true)
    }
    
    /// Metoda reagujuca na udalost stlacenia tlacidla Choose template. Pushne novu obrazovku TemplatePickViewController. Ak sa v nom vyberie nejaka sablona, jej hodnoty atributov nastavi do ``taskNameLabel`` a ``taskDescriptionLabel``.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func chooseTemplate(_ sender: Any) {
        hapticFeedback.impactOccurred()
        let storyboard = UIStoryboard(name: "TemplatePickViewController", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "TemplatePickViewController") as? TemplatePickViewController {
            navigationController?.pushViewController(viewController, animated: true)
            viewController.completionHandler = { template in
                self.taskNameLabel.text = template.name
                self.taskDescriptionLabel.text = template.description
            }
        }
    }
}
