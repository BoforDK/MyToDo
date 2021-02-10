//
//  TaskListViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/3/21.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var taskRepository = TaskRepository()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    
    var taskDetails: TaskCellViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    var currentFolder: Folder
    
    init(currentFolder: Folder) {
        self.currentFolder = currentFolder
        taskRepository.$tasks
            .map { task in
                task
                    .filter { $0.folderId == self.currentFolder.id }
                    .map { TaskCellViewModel(task: $0) }
            }
            .assign(to: \.taskCellViewModels, on: self)
            .store(in: &cancellables)
    }
    
    init(pinnedFolderType: PinnedFolder) {
        self.currentFolder = Folder(title: pinnedFolderType.rawValue)
        let filter = pinnedFolderType.getFilter
        taskRepository.$tasks
            .map { task in
                task
                    .filter { filter($0) }
                    .map { TaskCellViewModel(task: $0) }
            }
            .assign(to: \.taskCellViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        taskRepository.addTask(task)
    }
    
    func deleteTask(at offsets: IndexSet, tasks: [TaskCellViewModel]) {
        offsets.forEach { index in
            let task = tasks[index]
            task.delete()
        }
    }
}
