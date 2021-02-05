//
//  TaskListView.swift
//  Shared
//
//  Created by Alexander on 1/23/21.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var viewModel: TaskListViewModel
    
    @State var presentAddNewItem = false
    @State var showSignInForm = false
    @State var showUserView = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    Button("tmp", action: { viewModel.logout() })
                    ForEach(viewModel.taskCellViewModels) { taskCellVM in
                        TaskCell(taskCellVM: taskCellVM)
                    }
                    if presentAddNewItem {
                        TaskCell(taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false))) { task in
                            self.viewModel.addTask(task: task)
                            self.presentAddNewItem.toggle()
                        }
                    }
                }
                Button(action: {
                    self.presentAddNewItem.toggle()
                }){
                    HStack{
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("Add new Task")
                    }
                }
                .padding()
                NavigationLink(destination: UserView(viewModel: UserViewModel(logout: { viewModel.logout() })), isActive: $showUserView) {
                    EmptyView()
                }
            }
//            .sheet(isPresented: $showSignInForm, content: {
//                UserView(viewModel: UserViewModel(logout: { viewModel.logout() }))
//            })
            .navigationTitle("Tasks")
            .navigationBarItems(trailing: Button(action: {self.showUserView.toggle()}, label: {Image(systemName: "person.circle")}))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView(viewModel: TaskListViewModel(logout:  {}))
  }
}


struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onComit: (Task) -> Void = { _ in }
    
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
                }
            TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                self.onComit(self.taskCellVM.task)
            })
        }
    }
}
