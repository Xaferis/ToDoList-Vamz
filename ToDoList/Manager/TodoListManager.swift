//
//  TodoListManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

typealias TodoListCompletionHandler = () -> Void

class TodoListManager {
    
    
    // MARK: - Variables
    static let shared = TodoListManager()
    
    var tasks: [Task] = [] {
        didSet {
            saveTasks()
        }
    }
    
    
    // MARK: - Private
    private let UDkey = "tasks_list"
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    
    // MARK: - Tasks methods
    func loadTasks(completion: TodoListCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTasks = try? JSONDecoder().decode([Task].self, from: decodedData)
        else { return }
        
        self.tasks = savedTasks
        completion()
    }
    
    func addTask(task: Task, completion: TodoListCompletionHandler) {
        tasks.append(task)
        //print("Task successfully added!")
        completion()
    }
    
    func editTask(newTask: Task, at index: Int, completion: TodoListCompletionHandler) {
        tasks[index] = newTask
        //print("Task successfully edited")
        completion()
    }
    
    func deleteTask(at index: Int, completion: TodoListCompletionHandler) {
        tasks.remove(at: index)
        //print("Task successfully deleted")
        completion()
    }
    
    func changeStateOfTask(at index: Int, completion: TodoListCompletionHandler) {
        tasks[index].completed = !tasks[index].completed
        completion()
    }
    
}
