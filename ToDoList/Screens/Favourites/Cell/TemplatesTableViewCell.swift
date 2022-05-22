//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import UIKit

///Trieda ma na starosti spravu UI elementov celly TemplatesTableViewCell.xib.
class TemplatesTableViewCell: UITableViewCell {
    
    
    //MARK: - Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK: - Static
    /// Vrati nazov classy v String
    static var classString: String { String(describing: TemplatesTableViewCell.self) }
    
    
    //MARK: - Setup
    /// Nastavi UI elemnty storyboardu na hodnoty zo sablony prijatej parametrom.
    /// - Parameter item: Sabolna, ktoru bude cella zobrazovat.
    func setupCell(with item: TemplateItem) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
    }
    
}
