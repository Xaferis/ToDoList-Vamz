//
//  AddFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

class AddFavouritesViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    
    @IBAction func saveButton(_ sender: Any) {
        let newItem = FavouriteItem(name: nameTextField.text ?? "Test", description: descriptionTextField.text ?? "Test")
        FavouritesManager.shared.addFavourite(item: newItem) {
            dismiss(animated: true)
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
