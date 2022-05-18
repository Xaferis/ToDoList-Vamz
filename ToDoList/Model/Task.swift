//
//  Task.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

struct TaskModel : Codable {
    var name: String
    var description: String
    var date: Date
    var completed: Bool
}

struct Task: Codable {
    var date: Date
    var tasks: [TaskModel]
}
