//
//  AddFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovku EditTemplateViewController.storyboard.
class AddTemplateViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //MARK: - Variables
    private let hapticFeedback = UIImpactFeedbackGenerator()

    
    
    //MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla Save. Vytvori sablonu z dat ziskanych z atributov pre UI elementy a nasledne zavola add funkciu z manazera, ktoremu ako parameter posle novo vytvorenu sablonu.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
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
    
    /// Metoda reagujuca na udalost stlacenia tlacidla Cancel. Zavola dismiss nad touto obrazovkou.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func cancel(_ sender: Any) {
        hapticFeedback.impactOccurred()
        dismiss(animated: true)
    }
}
