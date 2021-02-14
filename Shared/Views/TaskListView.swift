//
//  TaskListView.swift
//  MyToDo
//
//  Created by Alexander on 1/23/21.
//

import SwiftUI

struct TaskListView: View {

    @ObservedObject var viewModel: TaskListViewModel

    @State var presentAddNewItem = false
    @State var showSignInForm = false
    @State var showDetails = false

    var body: some View {
        VStack(alignment: .leading) {
            List {
                ForEach(viewModel.taskCellViewModels) { taskCellVM in
                    TaskCell(taskCellVM: taskCellVM, showDetailsAction:  { taskCellVM in
                        showDetails = true
                        self.viewModel.taskDetails = taskCellVM
                    })
                }
                .onDelete(perform: {offsets in
                    viewModel.deleteTask(at: offsets, tasks: viewModel.taskCellViewModels)
                })

                if presentAddNewItem {
                    creatingNewTask
                }
            }
            Button(action: {
                self.presentAddNewItem.toggle()
            }) {
                newTaskButton
            }
            .padding()
        }
        .navigationTitle(viewModel.currentFolder.title)
        .sheet(isPresented: $showDetails) {
            TaskDetailsView(taskCellVM: viewModel.taskDetails ?? TaskCellViewModel(task: Task()))
        }
    }

    var newTaskButton: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .resizable()
                .frame(width: 20, height: 20)
            Text("Add new Task")
        }
    }
    var creatingNewTask: some View {
        TaskCell(
            taskCellVM: TaskCellViewModel(
                task: Task(title: "", completed: false, folderId: viewModel.currentFolder.id)
            ),
            onCommit: { task in
                    self.viewModel.addTask(task: task)
                    self.presentAddNewItem.toggle()
                }
        )
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

    var showDetailsAction: ((TaskCellViewModel) -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                checkmarkImage

                TextField("Enter the task title", text: $taskCellVM.task.title, onCommit: {
                    self.onCommit(self.taskCellVM.task)
                })

                importantImage

                editImage
            }
            if taskCellVM.task.plannedDay != nil {
                Text(taskCellVM.onlyDate())
            }
        }
    }

    var checkmarkImage: some View {
        Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 20, height: 20)
            .onTapGesture {
                self.taskCellVM.task.completed.toggle()
            }
    }

    var importantImage: some View {
        Image(systemName: taskCellVM.task.isImportant ? "star.fill" : "star")
            .resizable()
            .frame(width: 20, height: 20)
            .onTapGesture {
                self.taskCellVM.task.isImportant.toggle()
            }
    }

    var editImage: some View {
        Image(systemName: "pencil.tip")
            .resizable()
            .frame(width: 20, height: 20)
            .onTapGesture {
                showDetailsAction?(taskCellVM)
            }
    }
}
