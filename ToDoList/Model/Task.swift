//
//  Task.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

/// Predstavuje model pre Task
struct Task: Codable {
    var name: String
    var description: String
    var date: Date
    var completed: Bool
}

/// Predstavuje model sekcii (datumov), ktore si drzia zoznam Taskov
struct DayTask: Codable {
    var date: Date
    var tasks: [Task]
}


/// Predstavuje model taskov pri vyladavani. Mapuje tasky zo zonamu DayTask pomocou atributov section a row, ktore predstavuju poziciu v danom zozname
struct SearchModel {
    var section: Int
    var row: Int
    var task: Task
}
