//
//  TaskVM.swift
//  TaskManager
//
//  Created by E7 on 2022/5/31.
//

import SwiftUI
import CoreData

class TaskVM: ObservableObject {
    @Published var currentTab: String = "今天"
    
    // MARK: 新增任務 Properties
    @Published var openEditTask: Bool = false
    @Published var taskTitle: String = ""
    @Published var taskColor: String = "Blue"
    @Published var taskDeadline: Date = Date()
    @Published var taskType: String = "一般"
    @Published var showDatePicker: Bool = false
    
    @Published var editTask: Task?
    
    // MARK: 新增任務
    func addTask(context:  NSManagedObjectContext) -> Bool {
        var task: Task!
        if let editTask = editTask {
            task = editTask
        } else {
            task = Task(context: context)
        }
        
        task.title = taskTitle
        task.color = taskColor
        task.deadline = taskDeadline
        task.type = taskType
        task.isCompleted = false
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    // MARK: 恢復預設
    func resetTaskData() {
        taskType = "一般"
        taskColor = "Blue"
        taskTitle = ""
        taskDeadline = Date()
    }
    
    func setupTask() {
        if let editTask = editTask {
            taskType = editTask.type ?? "一般"
            taskColor = editTask.color ?? "Blue"
            taskTitle = editTask.title ?? ""
            taskDeadline = editTask.deadline ?? Date()
        }
    }
}
