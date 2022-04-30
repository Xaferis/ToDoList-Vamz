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
    @IBOutlet weak var checkButton: UIButton!
    
    
    //MARK: - Actions
    @IBAction func checkedTask(_ sender: Any) {
    }
    
    @IBAction func modify(_ sender: Any) {
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
