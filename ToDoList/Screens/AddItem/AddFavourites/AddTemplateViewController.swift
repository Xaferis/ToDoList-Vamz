//
//  AddFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

class AddTemplateViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //MARK: - Variables
    private let hapticFeedback = UIImpactFeedbackGenerator()

    
    
    //MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let text = nameTextField.text {
            let name = text.isEmpty ? NSLocalizedString("new_template", comment: "default name, if the name box wasn't filled") : text
            let newItem = TemplateItem(name: name, description: descriptionTextField.text ?? "")
            TemplatesManager.shared.addTemplate(item: newItem) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        hapticFeedback.impactOccurred()
        dismiss(animated: true)
    }
}
