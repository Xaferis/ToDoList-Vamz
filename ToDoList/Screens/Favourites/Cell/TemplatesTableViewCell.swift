//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import UIKit

class TemplatesTableViewCell: UITableViewCell {
    
    
    //MARK: - Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK: - Static
    static var classString: String { String(describing: TemplatesTableViewCell.self) }
    
    
    //MARK: - Setup
    func setupCell(with item: TemplateItem) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
    }
    
}
