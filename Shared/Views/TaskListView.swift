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
    
    @State var isShowDetails = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(viewModel.taskCellViewModels) { taskCellVM in
                    TaskCell(taskCellVM: taskCellVM) { taskCellVM in
                        isShowDetails = true
                        self.viewModel.taskDetails = taskCellVM
                    }
                }
                .onDelete(perform: {offsets in
                    viewModel.deleteTask(at: offsets, tasks: viewModel.taskCellViewModels)
                })
                if (presentAddNewItem) {
                    TaskCell(
                        taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false, folderId: viewModel.currentFolder.id)),
                        onCommit: { task in
                                self.viewModel.addTask(task: task)
                                self.presentAddNewItem.toggle()
                            },
                        isShowDetails: { _ in }
                    )
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
        .sheet(isPresented: $isShowDetails) {
            TaskDetailsView(taskCellVM: viewModel.taskDetails ?? TaskCellViewModel(task: Task()))
        }
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
    
    var isShowDetails: (TaskCellViewModel) -> Void
    
    @State var isPresented = false
    
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
                Image(systemName: taskCellVM.task.isImportant ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .onTapGesture {
                        self.taskCellVM.task.isImportant.toggle()
                    }
            }
            if let plannedDay = taskCellVM.task.plannedDay {
                Text(plannedDay.dateValue().description)
            }
        }
        .onLongPressGesture(minimumDuration: 0.5) {
                            isShowDetails(taskCellVM)
                        }
    }
}
