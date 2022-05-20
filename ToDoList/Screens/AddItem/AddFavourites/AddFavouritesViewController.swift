//
//  AddFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

class AddFavouritesViewController: UIViewController {

    
    //MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    //MARK: - Actions
    @IBAction func saveButton(_ sender: Any) {
        if let text = nameTextField.text {
            let name = text.isEmpty ? NSLocalizedString("new_template", comment: "default name, if the name box wasn't filled") : text
            let newItem = FavouriteItem(name: name, description: descriptionTextField.text ?? "")
            FavouritesManager.shared.addFavourite(item: newItem) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
