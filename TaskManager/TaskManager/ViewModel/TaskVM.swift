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
}
