//
//  EditFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

/// Trieda ma na starosti spravu UI elementov obrazovku EditTemplateViewController.storyboard.
class EditTemplateViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //MARK: - Variables
    /// Pozicia sablony v zozname
    var position: Int?
    private let hapticFeedback = UIImpactFeedbackGenerator()

    
    
    //MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla Save. Vytvori sablonu z dat ziskanych z atributov pre UI elementy a nasledne zavola edit funkciu z manazera, ktoremu ako parameter posle novo vytvorenu sablonu a ``position``.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
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
    
    /// Metoda reagujuca na udalost stlacenia tlacidla delete. Zavola delete funkciu z manazera, ktoremu posle ``position`` ako parameter.
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func deleteButton(_ sender: Any) {
        hapticFeedback.impactOccurred()
        if let index = self.position {
            TemplatesManager.shared.deleteTemplate(at: index) {
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
    
    
    //MARK: - Lifecycles
    /// Tato metoda je volana po tom, co sa naloaduje View z ViewControllera. V tejto metode sa nastavia atributy UI elementov na hodnoty, ktore ma sablona v zozname manazera na pozicii ulozenej v ``position``.
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = self.position {
            let item = TemplatesManager.shared.templates[index]
            nameTextField.text = item.name
            descriptionTextField.text = item.description
        }
    }
}
