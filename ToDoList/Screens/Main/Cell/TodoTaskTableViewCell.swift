//
//  TodoTaskTableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

class TodoTaskTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkIconButton: UIButton!
    
    
    //MARK: - Static variables
    static var classString: String { String(describing: TodoTaskTableViewCell.self) }
    static let heightOfCell: CGFloat = 55
    
    
    //MARK: - Variables
    var buttonDelegate: TodoTaskTableViewCellDelegate?
    var index: Int?
    var isChecked: Bool?
    
    
    //MARK: - Actions
    @IBAction func modify(_ sender: Any) {
        guard let index = self.index else { return }
        buttonDelegate?.didModifyButtonPressed(cellForRowAt: index)
    }
    
    @IBAction func checkButton(_ sender: Any) {
        guard let index = self.index,
              let isChecked = self.isChecked
        else { return }
        setupButton(isCompleted: !isChecked)
        buttonDelegate?.didCheckButtonPressed(cellForRowAt: index)
    }
    
    
    //MARK: - Setup
    func setupCell(with task: Task, at index: Int) {
        setupButton(isCompleted: task.completed)
        taskLabel.text = task.name
        self.index = index
    }
    
    func setupButton(isCompleted: Bool) {
        switch isCompleted {
        case true:
            self.checkIconButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            isChecked = false
        case false:
            self.checkIconButton.setImage(UIImage(systemName: "circle"), for: .normal)
            isChecked = true
        }
    }
}


// MARK: - Protocol delegate
protocol TodoTaskTableViewCellDelegate {
    
    func didModifyButtonPressed(cellForRowAt index: Int)
    
    func didCheckButtonPressed(cellForRowAt index: Int)
}
