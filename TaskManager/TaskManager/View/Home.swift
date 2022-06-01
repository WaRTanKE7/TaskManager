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
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    // MARK: 迎賓詞
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
            .padding()
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
            AddTask()
                .environmentObject(taskVM)
        }
    }
    
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
