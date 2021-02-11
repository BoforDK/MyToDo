//
//  FolderCellViewModel.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import Combine

class FolderCellViewModel: ObservableObject, Identifiable {
    @Published var folder: Folder
    var id: String = ""
    @Published var folderRepository = FolderRepository()

    private var cancellables = Set<AnyCancellable>()

    init(folder: Folder) {
        self.folder = folder

        $folder
            .compactMap { task in
                task.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)

        $folder
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { task in
                self.folderRepository.updateFolder(task)
            }
            .store(in: &cancellables)
    }

    func delete() {
        folderRepository.deleteFolder(folder)
    }
}
