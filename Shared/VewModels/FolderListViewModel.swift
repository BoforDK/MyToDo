//
//  FolderListViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import Combine
import SwiftUI

class FolderListViewModel: ObservableObject {
    @Published var folderRepository = FolderRepository()
    @Published var folderCellViewModels = [FolderCellViewModel]()
    
    @Published var image: UIImage?
    @Published var storage: FBStorage
    
    var logout: () -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(storage: FBStorage, logout: @escaping () -> Void) {
        self.logout = logout
        self.storage = storage
        folderRepository.$folders.map { folder in
            folder
                .map { folder in
                    FolderCellViewModel(folder: folder)
                }
        }
        .assign(to: \.folderCellViewModels, on: self)
        .store(in: &cancellables)
    }
    
    private func findFolder(name: String) -> FolderCellViewModel {
        guard let result = folderCellViewModels.first(where: { folderCellVM in
            folderCellVM.folder.title == name
        }) else {
            let newFolder = Folder(title: name)
            addFolder(folder: newFolder)
            return FolderCellViewModel(folder: newFolder)
        }
        
        folderCellViewModels = folderCellViewModels.filter { folderCellVM in
            folderCellVM.folder.title != name
        }
        
        return result
    }
    
    func addFolder(folder: Folder) {
        folderRepository.addFolder(folder)
    }
    
    func deleteFolders(at offsets: IndexSet, folders: [FolderCellViewModel]) {
        offsets.forEach { index in
            let folder = folders[index]
            folder.delete()
        }
    }
    
    func updateImage() {
        self.storage.downloadImage()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("ImageCellViewModel: \(error)")
                default:
                    return
                }
            }, receiveValue: { output in
                self.image = output
            })
            .store(in: &cancellables)
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
                guard let taskDate = task.plannedDay?.dateValue() else {
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
