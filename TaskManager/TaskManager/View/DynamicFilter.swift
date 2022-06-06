//
//  DynamicFilter.swift
//  TaskManager
//
//  Created by E7 on 2022/6/6.
//

import SwiftUI
import CoreData

struct DynamicFilter<Content: View,T>: View where T: NSManagedObject {
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    init(currentTab: String, @ViewBuilder content: @escaping (T) -> Content) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        
        var predicate: NSPredicate!
 
        if currentTab == "今天" {
            let today = calendar.startOfDay(for: Date())
            let tommorow = calendar.date(byAdding: .day, value: 1, to: today)!
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
        } else if currentTab == "未來" {
            let today = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: Date())!)
            let tommorow = Date.distantFuture
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [today, tommorow, 0])
        } else if currentTab == "失敗" {
            let today = calendar.startOfDay(for: Date())
            let past = Date.distantPast
            
            let filterKey = "deadline"
            
            predicate = NSPredicate(format: "\(filterKey) >= %@ AND \(filterKey) < %@ AND isCompleted == %i", argumentArray: [past, today, 0])
        } else {
            predicate = NSPredicate(format: "isCompleted == %i", argumentArray: [1])
        }
        
        
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [.init(keyPath: \Task.deadline, ascending: false)], predicate: predicate)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("沒有任何任務！")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}
