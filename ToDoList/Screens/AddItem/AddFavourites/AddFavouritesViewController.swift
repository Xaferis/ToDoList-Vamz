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
        let newItem = FavouriteItem(name: nameTextField.text ?? "Test", description: descriptionTextField.text ?? "Test")
        FavouritesManager.shared.addFavourite(item: newItem) {
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
}
