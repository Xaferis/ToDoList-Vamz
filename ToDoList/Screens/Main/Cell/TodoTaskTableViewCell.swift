//
//  TodoTaskTableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class TodoTaskTableViewCell: UITableViewCell {
    
    static var classString: String { String(describing: TodoTaskTableViewCell.self) }

    // MARK: - Outlets
    @IBOutlet weak var taskLabel: UILabel!
    
    
    func setupCell(with task: Task) {
        taskLabel.text = task.name
    }
}
