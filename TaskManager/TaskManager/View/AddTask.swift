//
//  AddTask.swift
//  TaskManager
//
//  Created by E7 on 2022/6/1.
//

import SwiftUI

enum TaskColors: String, CaseIterable {
    case blue = "Blue"
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case purple = "Purple"
}

enum TaskTypes: String, CaseIterable {
    case basic = "一般"
    case urgent = "急迫"
    case important = "重要"
}

struct AddTask: View {
    @EnvironmentObject var taskVM: TaskVM
    @Environment(\.self) var env
    @Namespace private var animation
    
    @State var dataSaveIsFail: Bool = false
    
    var body: some View {
        GeometryReader { gr in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 12) {
                    Text(taskVM.editTask == nil ? "新增任務" : "編輯任務")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                        .overlay(alignment: .leading) {
                            Button {
                                taskVM.editTask = nil
                                env.dismiss()
                            } label: {
                                Image(systemName: "arrow.left")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                        .overlay(alignment: .trailing) {
                            Button {
                                if let editTask = taskVM.editTask {
                                    env.managedObjectContext.delete(editTask)
                                    try? env.managedObjectContext.save()
                                    env.dismiss()
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title3)
                                    .foregroundColor(.red)
                            }
                            .opacity(taskVM.editTask == nil ? 0 : 1)
                        }
                    
                    // MARK: 顏色
                    VStack(alignment: .leading, spacing: 12) {
                        Text("顏色")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 15) {
                            ForEach(TaskColors.allCases, id: \.rawValue) { color in
                                Circle()
                                    .fill(Color(color.rawValue))
                                    .frame(width: 25, height: 25)
                                    .background {
                                        if taskVM.taskColor == color.rawValue {
                                            Circle()
                                                .strokeBorder(.gray)
                                                .padding(-3.5)
                                                .matchedGeometryEffect(id: "COLOR", in: animation)
                                        }
                                    }
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        withAnimation {
                                            taskVM.taskColor = color.rawValue
                                        }
                                        closeKeyboard()
                                    }
                            }
                        }
                        .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: 標題
                    VStack(alignment: .leading, spacing: 12) {
                        Text("標題")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        TextField("", text: $taskVM.taskTitle)
                            .font(.callout.bold())
                            .submitLabel(.done)
                            .frame(maxWidth: .infinity)
                            .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)

                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: Deadline
                    VStack(alignment: .leading, spacing: 12) {
                        Text("最後期限")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        Text(taskVM.taskDeadline.formatted(date: .abbreviated, time: .omitted) + ", " + taskVM.taskDeadline.formatted(date: .omitted, time: .shortened))
                            .font(.callout)
                            .fontWeight(.semibold)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay(alignment: .bottomTrailing, content: {
                        Button {
                            taskVM.showDatePicker.toggle()
                        } label: {
                            Image(systemName: "calendar")
                                .font(.title2)
                                .foregroundColor(.black)
                        }
                    })
                    .padding(.top, 10)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: 種類
                    VStack(alignment: .leading, spacing: 12) {
                        Text("任務種類")
                            .font(.callout)
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 12) {
                            ForEach(TaskTypes.allCases, id: \.rawValue) { type in
                                Text(type.rawValue)
                                    .font(.callout)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(taskVM.taskType == type.rawValue ? .white : .black)
                                    .background {
                                        if taskVM.taskType == type.rawValue {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "TYPE", in: animation)
                                        } else {
                                            Capsule()
                                                .strokeBorder(.black)
                                        }
                                    }
                                    .contentShape(Capsule())
                                    .onTapGesture {
                                        withAnimation {
                                            taskVM.taskType = type.rawValue
                                        }
                                        closeKeyboard()
                                    }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                    
                    Divider()
                        .padding(.vertical, 10)
                    
                    // MARK: 保存
                    Button {
                        if taskVM.addTask(context: env.managedObjectContext) {
                            env.dismiss()
                        } else {
                            dataSaveIsFail = true
                        }
                    } label: {
                        Text("保存")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background {
                                Capsule()
                                    .fill(.black)
                            }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.bottom, 10)
                    .disabled(taskVM.taskTitle == "")
                    .opacity(taskVM.taskTitle == "" ? 0.6 : 1)
                    .alert(isPresented: $dataSaveIsFail) {
                        Alert(
                            title: Text("儲存失敗"),
                            message: Text("請再試一次"),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                }
                .frame(minHeight: gr.size.height, maxHeight: .infinity, alignment: .top)
                .padding()
                .onTapGesture {
                    closeKeyboard()
                }
                .overlay {
                    ZStack {
                        if taskVM.showDatePicker {
                            Rectangle()
                                .fill(.ultraThinMaterial)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    taskVM.showDatePicker = false
                                }
                            
                            DatePicker.init("", selection: $taskVM.taskDeadline, in: Date.now...Date.distantFuture)
                                .datePickerStyle(.graphical)
                                .labelsHidden()
                                .padding()
                                .background(.white, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                                .padding()
                                .onAppear {
                                    closeKeyboard()
                                }
                        }
                    }
                    .animation(.easeInOut, value: taskVM.showDatePicker)
                }
            }
        }
    }
}

struct AddTask_Previews: PreviewProvider {
    static var previews: some View {
        AddTask()
            .environmentObject(TaskVM())
    }
}

extension View {
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
