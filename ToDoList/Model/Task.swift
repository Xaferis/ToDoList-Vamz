//
//  Task.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

struct Task : Codable {
    var name: String
    var description: String
    var date: Date
    var completed: Bool
}
