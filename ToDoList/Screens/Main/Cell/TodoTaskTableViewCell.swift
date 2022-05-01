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
        guard let index = self.index else { return }
        buttonDelegate?.didButtonPressed(cellForRowAt: index)
    }
    
    func setupCell(with task: Task, at index: Int) {
        taskLabel.text = task.name
        self.index = index
    }
}

protocol TodoTaskTableViewCellDelegate {
    func didButtonPressed(cellForRowAt index: Int)
}
