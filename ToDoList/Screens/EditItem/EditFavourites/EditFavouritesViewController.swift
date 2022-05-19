//
//  EditFavouritesViewController.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 19/05/2022.
//

import UIKit

class EditFavouritesViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    private var position: Int?
    
    
    @IBAction func saveButton(_ sender: Any) {
        if let index = self.position {
            let newItem = FavouriteItem(name: nameTextField.text ?? "Test", description: descriptionTextField.text ?? "Test")
            FavouritesManager.shared.editFavourite(newItem: newItem, at: index) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        if let index = self.position {
            FavouritesManager.shared.deleteFavourite(at: index) {
                dismiss(animated: true)
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let index = self.position {
            let item = FavouritesManager.shared.getFavourites()[index]
            nameTextField.text = item.getName()
            descriptionTextField.text = item.getDescription()
        }
    }
    
}

extension EditFavouritesViewController {

    func setPositionOfCell(at index: Int) {
        self.position = index
    }
}
