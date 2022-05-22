//
//  TodoListManager.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 30/04/2022.
//

import Foundation

typealias TodoListCompletionHandler = () -> Void
typealias taskPosition = (section: Int, row: Int)

/// Tato trieda je singleton. Ma na starosti spravu vytvorenych uloh (taskov), t.j. ich modifikaciu, pridavanie, mazanie, ukladanie do pamati ...
class TodoListManager {
    
    
    // MARK: - Static
    /// Vrati instanciu triedy
    static let shared = TodoListManager()
    
    /// Tento datum sluzi ako datum splnenych taskov.
    static let completedDate = Date.from(2100, 12, 31)
    
    
    //MARK: - Variables
    /// Zoznam aktualne ulozenych taskov
    var listOfTasks: [DayTask] = []
    
    
    
    // MARK: - Private
    private let UDkey = "tasks_list"
    private let dateFormatter = DateFormatter.mediumDateFormatter
    
    /// Funkcia ulozi do pamate aktualne tasky.
    private func saveTasks() {
        if let encodedData = try? JSONEncoder().encode(listOfTasks) {
            UserDefaults.standard.set(encodedData, forKey: UDkey)
        }
    }
    
    
    // MARK: - Tasks methods
    /// Funkcia nacita z pamate ulozene tasky do atributu `listOfTasks`.
    /// - Parameter completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func loadTasks(completion: TodoListCompletionHandler) {
        guard
            let decodedData = UserDefaults.standard.data(forKey: UDkey),
            let savedTasks = try? JSONDecoder().decode([DayTask].self, from: decodedData)
        else { return }
        
        self.listOfTasks = savedTasks
        completion()
    }
    
    
    //MARK: - Add Task
    /// Funkcia prida na spravne miesto v zozname task, ktory mu bol poslany parametrom, nasledne novy stav zoznamu ulozi do pamate.
    /// - Parameters:
    ///   - task: Nova uloha, ktora ma byt pridana do zoznamu.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
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
    /// Funkcia upraveny task bud zaradi na miesto stareho, alebo ho utriedi na novu poziciu v zozname, ak sa zmenil datum. Novy stav zoznamu nasledne ulozi do pamate.
    /// - Parameters:
    ///   - newTask: Upraveny task.
    ///   - position: Pozicia v zozname upravovaneho tasku.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
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
    /// Funkcia vymaze zo zoznamu task na pozicii zadanej v parametri. Nasledne sa novy stav zoznamu ulozi do pamate.
    /// - Parameters:
    ///   - position: Pozicia mazaneho tasku.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
    func deleteTask(at position: taskPosition, completion: TodoListCompletionHandler) {
        listOfTasks[position.section].tasks.remove(at: position.row)
        if listOfTasks[position.section].tasks.isEmpty {
            listOfTasks.remove(at: position.section)
        }
        saveTasks()
        completion()
    }
    
    
    //MARK: - Change state of Task
    /// Funkcia zmeni stav splnenia tasku a zaradi ho na spravnu poziciu v zozname. Nasledne sa novy stav zoznamu ulozi do pamate.
    /// - Parameters:
    ///   - position: Pozicia meneneho tasku.
    ///   - completion: Closure bez parametrov a navratovej hodnoty, predsatuvje prikazy, ktore sa maju este dodatocne uskutocnit.
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
    /// Funkcia prida task prijaty parametrom do sekcie splnenych v zozname. Ak taka sekcia este neexistuje, tak ju vytvori. Nasledne stav zoznamu ulozi do pamate.
    /// - Parameter newTask: Task, ktory sa ma ulozit do sekcie splnenych.
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
