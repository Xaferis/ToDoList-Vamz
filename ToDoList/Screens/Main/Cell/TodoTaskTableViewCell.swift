//
//  TodoTaskTableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 29/04/2022.
//

import UIKit

///Trieda ma na starosti spravu UI elementov celly TodoTaskTableViewCell.xib.
class TodoTaskTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkIconButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK: - Static variables
    /// Vrati nazov classy v String
    static var classString: String { String(describing: TodoTaskTableViewCell.self) }
    
    
    //MARK: - Variables
    /// Delegat, ktory ma na starost monitorovanie stlacena tlacidiel
    var buttonDelegate: TodoTaskTableViewCellDelegate?
    
    /// Pozicia tasku v zozname
    var position: taskPosition?
    
    /// Bool, ci uz je task splneny, alebo nie
    var isChecked: Bool?
    
    private let editButtonFeedback = UIImpactFeedbackGenerator();
    private let checkButtonFeedback = UINotificationFeedbackGenerator();
    
    
    //MARK: - Actions
    /// Metoda reagujuca na slacenie tlacidla modify (...). Vysle informaciu o stlaceni delegatovi
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func modify(_ sender: Any) {
        guard let position = self.position else { return }
        editButtonFeedback.impactOccurred()
        buttonDelegate?.didModifyButtonPressed(cellForRowAt: position)
    }
    
    /// Metoda reagujuca na slacenie tlacidla check. Vysle informaciu o stlaceni delegatovi
    /// - Parameter sender: Objekt volajuci tuto funkciu.
    @IBAction func checkButton(_ sender: Any) {
        guard let position = self.position,
              let isChecked = self.isChecked
        else { return }
        setupButton(isCompleted: !isChecked)
        checkButtonFeedback.notificationOccurred(.success)
        buttonDelegate?.didCheckButtonPressed(cellForRowAt: position)
    }
    
    
    //MARK: - Setup
    /// Nastavi UI elemnty storyboardu na hodnoty zo sablony prijatej parametrom.
    /// - Parameter item: Sabolna, ktoru bude cella zobrazovat.
    func setupCell(with task: Task, at position: taskPosition) {
        setupButton(isCompleted: task.completed)
        taskLabel.text = task.name
        descriptionLabel.text = task.description
        self.position = position
    }
    
    /// Nastavi ikonku tlacidla Check
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
    
    
    /// Metoda protokolu TodoTaskTableViewCellDelegate
    /// - Parameter position: Pozicia celly.
    func didModifyButtonPressed(cellForRowAt position: taskPosition)
    
    /// Metoda protokolu TodoTaskTableViewCellDelegate
    /// - Parameter position: Pozicia celly.
    func didCheckButtonPressed(cellForRowAt position: taskPosition)
}
