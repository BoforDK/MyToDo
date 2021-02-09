//
//  FolderListView.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import SwiftUI

struct FolderListView: View {
    @ObservedObject var viewModel: FolderListViewModel
    
    @State var presentAddNewItem = false
    @State var showSignInForm = false
    @State var showUserView = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List {
                pinnedFolders
                
                myFolders
            }
            
            addFolderButton
            
            NavigationLink(destination: UserView(viewModel: UserViewModel(logout: { viewModel.logout() }, storage: FBStorage(uid: UserRepository().user.uid))), isActive: $showUserView) {
                EmptyView()
            }
        }
        .navigationTitle("Folders")
        .navigationBarItems(trailing: Button(action: {self.showUserView.toggle()}, label: {Image(systemName: "person.circle")}))
    }
    
    var pinnedFolders: some View{
        Section(header: Text("Pinned folders")) {
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .Important)), label: {
                Text(PinnedFolder.Important.rawValue)
            })
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .Today)), label: {
                Text(PinnedFolder.Today.rawValue)
            })
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .Undelivered)), label: {
                Text(PinnedFolder.Undelivered.rawValue)
            })
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .AllToDos)), label: {
                Text(PinnedFolder.AllToDos.rawValue)
            })
        }
    }
    
    var myFolders: some View {
        Section(header: Text("Your folders")) {
            ForEach(viewModel.folderCellViewModels) { folderCellVM in
                NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(currentFolder: folderCellVM.folder)), label: {
                    FolderCell(folderCellVM: folderCellVM)
                })
            }
            if (presentAddNewItem) {
                NewFolderCell(folderCellVM: FolderCellViewModel(folder: Folder(title: ""))) { folder in
                    self.viewModel.addFolder(folder: folder)
                    self.presentAddNewItem.toggle()
                }
            }
        }
    }
    
    var addFolderButton: some View {
        Button(action: {
            self.presentAddNewItem.toggle()
        }){
            HStack{
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("Add new Folder")
            }
        }
        .padding()
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView(viewModel: FolderListViewModel(){})
    }
}

struct FolderCell: View {
    @ObservedObject var folderCellVM: FolderCellViewModel
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(folderCellVM.folder.title)
            }
        }
    }
}

struct NewFolderCell: View {
    @ObservedObject var folderCellVM: FolderCellViewModel
    
    var onCommit: (Folder) -> Void = { _ in }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                TextField("Enter the folder name", text: $folderCellVM.folder.title, onCommit: {
                    self.onCommit(self.folderCellVM.folder)
                })
            }
        }
    }
}
