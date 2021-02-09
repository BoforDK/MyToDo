//
//  TaskDetailsView.swift
//  MyToDo
//
//  Created by Alexander on 2/9/21.
//

import SwiftUI
import Firebase

struct TaskDetailsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var taskCellVM: TaskCellViewModel
    
    @State var date: Date = Date()
    
    var body: some View {
        Section {
            DatePicker(
                "Start Date",
                selection: $date,
                in: Date()...,
                displayedComponents: [.date]
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            Button("Save date") {
                taskCellVM.task.plannedDay = Timestamp(date: date)
                self.presentationMode.wrappedValue.dismiss()
            }
            Button("Delete date") {
                taskCellVM.task.plannedDay = nil
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct TaskDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        TaskDetailsView(taskCellVM: TaskCellViewModel(task: Task()))
    }
}

struct DatePickerView: View {
    @State var date: Date = Date()

    var body: some View {
        DatePicker(
            "Start Date",
            selection: $date,
            in: Date()...,
            displayedComponents: [.date]
        )
        .datePickerStyle(GraphicalDatePickerStyle())
    }
}
