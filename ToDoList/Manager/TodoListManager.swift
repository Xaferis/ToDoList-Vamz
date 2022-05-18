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
    
    private let dateFormatter = DateFormatter.mediumDateFormatter
    
    static let completedDate = Date.from(2100, 12, 31)
    
    
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
    
    
    //MARK: - Add Task
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
    
    
    //MARK: - Edit Task
    func editTask(newTask: TaskModel, at position: taskPosition, completion: TodoListCompletionHandler) {
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
        //print("Task successfully edited")
        completion()
        
    }
    
    
    //MARK: - Delete Task
    func deleteTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        listOfTasks[position.section].tasks.remove(at: position.row)
        if listOfTasks[position.section].tasks.isEmpty {
            listOfTasks.remove(at: position.section)
        }
        saveTasks()
        //print("Task successfully deleted")
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
    private func moveToCompletedSection(newTask: TaskModel) {
//        let task = listOfTasks[position.section].tasks.remove(at: position.row)
//        if listOfTasks[position.section].tasks.isEmpty {
//            listOfTasks.remove(at: position.section)
//        }
        if let lastTask = self.listOfTasks.last,
           let completedDate = TodoListManager.completedDate {
            
            if dateFormatter.string(from: lastTask.date) == dateFormatter.string(from: completedDate) {
                let lastIndex = self.listOfTasks.endIndex - 1
                self.listOfTasks[lastIndex].tasks.append(newTask)
            } else {
                self.listOfTasks.append(Task(date: completedDate, tasks: [newTask]))
            }
        }
        saveTasks()
    }
    
    func getTasks() -> [Task] {
        return listOfTasks;
    }
    
}
