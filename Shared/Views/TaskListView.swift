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
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(viewModel.taskCellViewModels) { taskCellVM in
                    TaskCell(taskCellVM: taskCellVM)
                }
                if (presentAddNewItem) {
                    TaskCell(taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false, folderId: viewModel.currentFolder.id))) { task in
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
        }
        .navigationTitle(viewModel.currentFolder.title)
    }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    TaskListView(viewModel: TaskListViewModel(currentFolder: Folder(id: "id1", title: "title", userId: "uid1") ))
  }
}


struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onCommit: (Task) -> Void = { _ in }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .onTapGesture {
                        self.taskCellVM.task.completed.toggle()
                    }
                TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                    self.onCommit(self.taskCellVM.task)
                })
            }
            if let createdTime = taskCellVM.task.createdTime{
                Text(createdTime.dateValue().description)
            }
        }
    }
}
