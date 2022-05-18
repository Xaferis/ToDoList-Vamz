//
//  File.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation

class FavouriteItem : Codable {
    private var name: String
    private var description: String
    
    init (name: String, description: String) {
        self.name = name
        self.description = description
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getDescription() -> String {
        return self.description
    }
}
