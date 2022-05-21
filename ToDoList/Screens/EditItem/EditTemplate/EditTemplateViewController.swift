//
//  EditFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

class EditTemplateViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //MARK: - Variables
    var position: Int?
    private let hapticFeedback = UIImpactFeedbackGenerator()

    
    
    //MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let index = self.position,
           let text = nameTextField.text {
            let name = text.isEmpty ? NSLocalizedString("new_template", comment: "default name, if the name box wasn't filled") : text
            let newItem = TemplateItem(name: name, description: descriptionTextField.text ?? "")
            TemplatesManager.shared.editTemplate(newItem: newItem, at: index) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let index = self.position {
            TemplatesManager.shared.deleteTemplate(at: index) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        hapticFeedback.impactOccurred()
        dismiss(animated: true)
    }
    
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = self.position {
            let item = TemplatesManager.shared.templates[index]
            nameTextField.text = item.name
            descriptionTextField.text = item.description
        }
    }
}
