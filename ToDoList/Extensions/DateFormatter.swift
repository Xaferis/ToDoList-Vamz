//
//  DateFormatter.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation

extension DateFormatter {
    
    /// Naformatovany styl datumu v tvare: DD.MM.YYYY (YYYY predstavuje rok)
    static let dayDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        
        return dateFormatter
    }()
    
    /// Naformatovany styl datumu podla nastavenia systemu
    static let mediumDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter
    }()
}
