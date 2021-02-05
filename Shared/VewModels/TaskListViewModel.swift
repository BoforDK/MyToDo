//
//  TaskListViewModel.swift
//  MyToDo (iOS)
//
//  Created by Alexander on 2/3/21.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var taskRepository = TaskRepository()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    
    var logout: () -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
        taskRepository.$tasks.map { task in
            task.map { task in
                TaskCellViewModel(task: task)
            }
        }
        .assign(to: \.taskCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        taskRepository.addTask(task)
    }
}
