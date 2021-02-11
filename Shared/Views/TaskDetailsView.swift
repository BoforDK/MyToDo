//
//  TaskDetailsView.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import SwiftUI
import Firebase
import MapKit

struct TaskDetailsView: View {
    @Environment(\.presentationMode) var presentationMode

    var taskCellVM: TaskCellViewModel

    @State var date: Date = Date()

    var body: some View {
        NavigationView {
            List {
                DatePicker(
                    "Set date",
                    selection: $date,
                    in: Date()...,
                    displayedComponents: [.date]
                )
                Button("Save date") {
                    taskCellVM.task.plannedDay = Timestamp(date: date)
                    self.presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                Button("Delete date") {
                    taskCellVM.task.plannedDay = nil
                    self.presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                if taskCellVM.task.location != nil {
                    LocationView(viewModel: LocationViewModel(taskCellVM: taskCellVM, visible: false))
                        .frame(height: 200)
                }
                NavigationLink(destination: LocationView(
                                viewModel: LocationViewModel(taskCellVM: taskCellVM, visible: true)),
                               label: { Text("Location") }
                )
            }
            .navigationBarTitle(taskCellVM.task.title)
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(taskCellVM: TaskCellViewModel(task: Task()))
    }
}
