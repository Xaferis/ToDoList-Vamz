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
    
    
    // MARK: - Static
    static let shared = TodoListManager()
    static let completedDate = Date.from(2100, 12, 31)
    
    
    //MARK: - Variables
    var listOfTasks: [DayTask] = []
    
    
    
    // MARK: - Private
    private let UDkey = "tasks_list"
    private let dateFormatter = DateFormatter.mediumDateFormatter
    
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(listOfTasks) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    
    // MARK: - Tasks methods
    func loadTasks(completion: TodoListCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTasks = try? JSONDecoder().decode([DayTask].self, from: decodedData)
        else { return }
        
        self.listOfTasks = savedTasks
        completion()
    }
    
    
    //MARK: - Add Task
    func addTask(task: Task, completion: TodoListCompletionHandler) {
        if let index = listOfTasks.firstIndex(where: { dateFormatter.string(from: $0.date) == dateFormatter.string(from: task.date)}) {
            listOfTasks[index].tasks.append(task)
        } else {
            listOfTasks.append(DayTask(date: task.date, tasks: [task]))
            listOfTasks.sort(by: { $0.date < $1.date})
        }
        saveTasks()
        completion()
    }
    
    
    //MARK: - Edit Task
    func editTask(newTask: Task, at position: taskPosition, completion: TodoListCompletionHandler) {
        if newTask.completed && newTask.completed != listOfTasks[position.section].tasks[position.row].completed {
            deleteTask(at: position) {}
            moveToCompletedSection(newTask: newTask)
        } else {
            if newTask.date != listOfTasks[position.section].date {
                deleteTask(at: position) {}
                addTask(task: newTask) {}
            } else {
                listOfTasks[position.section].tasks[position.row] = newTask
                saveTasks()
            }
        }
        completion()
    }
    
    
    //MARK: - Delete Task
    func deleteTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        listOfTasks[position.section].tasks.remove(at: position.row)
        if listOfTasks[position.section].tasks.isEmpty {
            listOfTasks.remove(at: position.section)
        }
        saveTasks()
        completion()
    }
    
    
    //MARK: - Change state of Task
    func changeStateOfTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        var taskModel = listOfTasks[position.section].tasks[position.row]
        
        deleteTask(at: position) {}
        taskModel.completed = !taskModel.completed
        
        if taskModel.completed {
            moveToCompletedSection(newTask: taskModel)
        } else {
            addTask(task: taskModel) {}
        }
        completion()
    }
    
    
    //MARK: - Move to completed section
    private func moveToCompletedSection(newTask: Task) {
        if let lastTask = self.listOfTasks.last,
           let completedDate = TodoListManager.completedDate {
            
            if dateFormatter.string(from: lastTask.date) == dateFormatter.string(from: completedDate) {
                let lastIndex = self.listOfTasks.endIndex - 1
                self.listOfTasks[lastIndex].tasks.append(newTask)
            } else {
                self.listOfTasks.append(DayTask(date: completedDate, tasks: [newTask]))
            }
        } else {
            self.listOfTasks.append(DayTask(date: TodoListManager.completedDate!, tasks: [newTask]))
        }
        saveTasks()
    }
}
