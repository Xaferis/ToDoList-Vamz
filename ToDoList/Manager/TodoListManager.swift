//
//  TodoListManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

typealias TodoListCompletionHandler = () -> Void
typealias taskPosition = (section: Int, row: Int)

class TodoListManager {
    
    
    // MARK: - Variables
    static let shared = TodoListManager()
    
    private var listOfTasks: [Task] = []
    
    let dateFormatter = DateFormatter.mediumDateFormatter
    
    
    // MARK: - Private
    private let UDkey = "tasks_list"
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(listOfTasks) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    
    // MARK: - Tasks methods
    func loadTasks(completion: TodoListCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTasks = try? JSONDecoder().decode([Task].self, from: decodedData)
        else { return }
        
        self.listOfTasks = savedTasks
        completion()
    }
    
    func addTask(task: TaskModel, completion: TodoListCompletionHandler) {
        if let index = listOfTasks.firstIndex(where: { dateFormatter.string(from: $0.date) == dateFormatter.string(from: task.date)}) {
            listOfTasks[index].tasks.append(task)
        } else {
            listOfTasks.append(Task(date: task.date, tasks: [task]))
            listOfTasks.sort(by: { $0.date < $1.date})
        }
        saveTasks()
        //print("Task successfully added!")
        completion()
    }
    
    func editTask(newTask: TaskModel, at position: taskPosition, completion: TodoListCompletionHandler) {
        if newTask.date != listOfTasks[position.section].date {
            deleteTask(at: position) {}
            addTask(task: newTask) {}
        } else {
            listOfTasks[position.section].tasks[position.row] = newTask
            saveTasks()
        }
        //print("Task successfully edited")
        completion()
        
    }
    
    func deleteTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        listOfTasks[position.section].tasks.remove(at: position.row)
        if listOfTasks[position.section].tasks.isEmpty {
            listOfTasks.remove(at: position.section)
        }
        saveTasks()
        //print("Task successfully deleted")
        completion()
    }
    
    func changeStateOfTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        listOfTasks[position.section].tasks[position.row].completed = !listOfTasks[position.section].tasks[position.row].completed
        completion()
    }
    
    func getTasks() -> [Task] {
        return listOfTasks;
    }
    
}
