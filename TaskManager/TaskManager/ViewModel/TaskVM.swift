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
}
