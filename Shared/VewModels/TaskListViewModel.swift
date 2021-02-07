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
    
    private var cancellables = Set<AnyCancellable>()
    
    var currentFolder: Folder
    
    init(currentFolder: Folder) {
        self.currentFolder = currentFolder
        taskRepository.$tasks
            .map { task in
                task
                    .filter { $0.folderId == self.currentFolder.id }
                    .map (TaskCellViewModel.init)
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
                    .map (TaskCellViewModel.init)
            }
            .assign(to: \.taskCellViewModels, on: self)
            .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        taskRepository.addTask(task)
    }
}

enum PinnedFolder: String {
    case Important = "Important"
    case Today = "Today"
    case Undelivered = "Undelivered"
    case AllToDos = "All ToDos"
    
    var getFilter: ((Task) -> Bool) {
        switch self {
        case .Important:
            return { task in task.isImportant }
        case .Undelivered:
            return { task in !task.completed }
        case .Today:
            return { task in
                guard let taskDate = task.createdTime?.dateValue() else {
                    return false
                }
                let day = Calendar.current.component(.day, from: taskDate)
                let today = Calendar.current.component(.day, from: Date())
                return day == today
            }
        case .AllToDos:
            return { _ in true }
        }
    }
}
