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
    @Published var taskRepository = TaskRepository()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(task: Task) {
        self.task = task
        
        $task
            .compactMap { task in
                task.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
        
        //TODO
        $task
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { task in
                self.taskRepository.updateTask(task)
            }
            .store(in: &cancellables)
    }
}
