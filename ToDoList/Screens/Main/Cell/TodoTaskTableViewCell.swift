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
    var position: taskPosition?
    var isChecked: Bool?
    
    
    //MARK: - Actions
    @IBAction func modify(_ sender: Any) {
        guard let position = self.position else { return }
        buttonDelegate?.didModifyButtonPressed(cellForRowAt: position)
    }
    
    @IBAction func checkButton(_ sender: Any) {
        guard let position = self.position,
              let isChecked = self.isChecked
        else { return }
        setupButton(isCompleted: !isChecked)
        buttonDelegate?.didCheckButtonPressed(cellForRowAt: position)
    }
    
    
    //MARK: - Setup
    func setupCell(with task: TaskModel, at position: taskPosition) {
        setupButton(isCompleted: task.completed)
        taskLabel.text = task.name
        self.position = position
    }
    
    private func setupButton(isCompleted: Bool) {
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
    
    func didModifyButtonPressed(cellForRowAt position: taskPosition)
    
    func didCheckButtonPressed(cellForRowAt position: taskPosition)
}
