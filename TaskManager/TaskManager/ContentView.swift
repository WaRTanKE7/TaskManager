//
//  ContentView.swift
//  TaskManager
//
//  Created by E7 on 2022/5/31.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var body: some View {
        NavigationView  {
            Home()
                .navigationBarTitle("任務管理器")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
