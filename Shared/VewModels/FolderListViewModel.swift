//
//  FolderListViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import Combine

class FolderListViewModel: ObservableObject {
    @Published var folderRepository = FolderRepository()
    @Published var folderCellViewModels = [FolderCellViewModel]()
    
    var logout: () -> Void
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(logout: @escaping () -> Void) {
        self.logout = logout
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
}
