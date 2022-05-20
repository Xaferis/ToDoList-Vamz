//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import UIKit

class FavouritesTableViewCell: UITableViewCell {
    
    
    //MARK: - Variables
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    //MARK: - Static
    static var classString: String { String(describing: FavouritesTableViewCell.self) }
    static let heightOfCell: CGFloat = 55
    
    
    //MARK: - Setup
    func setupCell(with item: FavouriteItem) {
        nameLabel.text = item.getName()
        descriptionLabel.text = item.getDescription()
    }
    
}
