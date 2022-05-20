//
//  Task.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

struct Task: Codable {
    var name: String
    var description: String
    var date: Date
    var completed: Bool
}

struct DayTask: Codable {
    var date: Date
    var tasks: [Task]
}

struct SearchModel {
    var section: Int
    var row: Int
    var task: Task
}
