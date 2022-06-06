//
//  Home.swift
//  TaskManager
//
//  Created by E7 on 2022/5/31.
//

import SwiftUI

struct Home: View {
    @StateObject var taskVM: TaskVM = .init()
    @Namespace var animation
    
    @FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.deadline, ascending: false)], predicate: nil, animation: .easeInOut) var tasks: FetchedResults<Task>
    
    @Environment(\.self) var env
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                // MARK: 迎賓詞
                VStack(alignment: .leading, spacing: 10) {
                    Text("歡迎回來")
                        .font(.callout)
                    
                    Text("今天任務做完了嗎？")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
                
                customSegmentedBar()
                    .padding(.top, 5)
                
                TaskView()
            }
            .padding()
        }
        .overlay(alignment: .bottom) {
            // MARK: 新增按鈕
            Button {
                taskVM.openEditTask.toggle()
            } label: {
                Label {
                    Text("新增任務")
                        .font(.callout)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "plus.app.fill")
                }
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal)
                .background(.black, in: Capsule())
            }
            .padding(.top, 10)
            .frame(maxWidth: .infinity)
            .background{
                LinearGradient(colors: [
                    .white.opacity(0.05),
                    .white.opacity(0.4),
                    .white.opacity(0.7),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            }
            
        }
        .fullScreenCover(isPresented: $taskVM.openEditTask) {
            taskVM.resetTaskData()
        } content: {
            AddTask()
                .environmentObject(taskVM)
        }

    }
    
    // MARK: 任務列表
    @ViewBuilder
    func TaskView() -> some View {
        LazyVStack(spacing: 20) {
            DynamicFilter(currentTab: taskVM.currentTab) { (task: Task) in
                TaskRowView(task: task)
            }
        }
        .padding(.top, 20)
    }
    
    // MARK: 單一任務方塊
    @ViewBuilder
    func TaskRowView(task: Task) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                // MARK: 任務種類
                Text(task.type ?? "")
                    .font(.callout)
                    .padding(.vertical, 5)
                    .padding(.horizontal)
                    .background {
                        Capsule()
                            .fill(.white.opacity(0.4))
                    }
                
                Spacer()
                
                if !task.isCompleted && taskVM.currentTab != "失敗" {
                    Button {
                        taskVM.editTask = task
                        taskVM.openEditTask = true
                        taskVM.setupTask()
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.black)
                    }
                }
            }
            
            // MARK: 標題
            Text(task.title ?? "")
                .font(.title2.bold())
                .foregroundColor(.black)
                .padding(.vertical, 10)
            
            HStack(alignment: .bottom, spacing: 0) {
                // MARK: Deadline
                VStack(alignment: .leading, spacing: 10) {
                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .long, time: .omitted))
                    } icon: {
                        Image(systemName: "calendar")
                    }
                    .font(.caption)
                    .foregroundColor(.black)

                    Label {
                        Text((task.deadline ?? Date()).formatted(date: .omitted, time: .shortened))
                    } icon: {
                        Image(systemName: "clock")
                    }
                    .font(.caption)
                    .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // MARK: 完成
                if !task.isCompleted && taskVM.currentTab != "失敗" {
                    Button {
                        task.isCompleted.toggle()
                        try? env.managedObjectContext.save()
                    } label: {
                        Circle()
                            .strokeBorder(.black, lineWidth: 1.5)
                            .frame(width: 25, height: 25)
                            .contentShape(Circle())
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(task.color ?? "Blue"))
        }
    }
    
    // MARK: 客製化 SegmentedBar
    @ViewBuilder
    func customSegmentedBar() -> some View {
        let tabs = ["今天", "未來", "已完成", "失敗"]
        HStack(spacing: 10) {
            ForEach(tabs, id:\.self) { tab in
                Text(tab)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .scaleEffect(0.9)
                    .foregroundColor(taskVM.currentTab == tab ? .white : .black)
                    .padding(.vertical, 6)
                    .frame(maxWidth: .infinity)
                    .background{
                        if taskVM.currentTab == tab {
                            Capsule()
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            taskVM.currentTab = tab
                        }
                    }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
