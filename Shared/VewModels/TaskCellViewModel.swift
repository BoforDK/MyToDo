//
//  TaskCellViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/3/21.
//

import Foundation
import Combine

class TaskCellViewModel: ObservableObject, Identifiable {
    @Published var task: Task
    var id: String = ""
    @Published var taskRepository: TaskRepository

    private var cancellables = Set<AnyCancellable>()

    init(task: Task, taskRepository: TaskRepository = TaskRepository()) {
        self.task = task
        self.taskRepository = taskRepository

        $task
            .compactMap { task in
                task.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)

        $task
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { task in
                self.taskRepository.updateTask(task)
            }
            .store(in: &cancellables)
    }

    func delete() {
        taskRepository.deleteTask(task)
    }

    func onlyDate() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .short
        formatter.timeZone = TimeZone.current
        return formatter.string(from: task.plannedDay?.dateValue() ?? Date())
    }
}
