//
//  TodoTaskTableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class TodoTaskTableViewCell: UITableViewCell {
    
    static var classString: String { String(describing: TodoTaskTableViewCell.self) }
    
    var buttonDelegate: TodoTaskTableViewCellDelegate?

    // MARK: - Outlets
    @IBOutlet weak var taskLabel: UILabel!
    
    var index: Int?
    
    @IBAction func modify(_ sender: Any) {
        buttonDelegate?.didButtonPressed()
//        let storyboard = UIStoryboard(name: "EditItemViewController", bundle: nil)
//        if let navigationController = storyboard.instantiateInitialViewController() {
//            present(navigationController, animated: true)
//            //navigationController.transitioningDelegate = self
//        }
    }
    
    func setupCell(with task: Task, at index: Int) {
        taskLabel.text = task.name
        self.index = index
    }
}

protocol TodoTaskTableViewCellDelegate {
    func didButtonPressed()
}
