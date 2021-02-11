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

            NavigationLink(
                destination: UserView(
                viewModel: UserViewModel(logout: { viewModel.logout() }, storage: viewModel.storage)),
                isActive: $showUserView
            ) {
                EmptyView()
            }
        }
        .navigationTitle("Folders")
        .navigationBarItems(
            leading: Button(action: {self.showUserView.toggle()}, label: { userButton }),
            trailing: Button(action: {self.presentAddNewItem.toggle()}, label: { addFolderButton }))
        .onAppear {
            viewModel.updateImage()
        }
    }

    var userButton: some View {
        ((viewModel.image == nil) ?
            Image(systemName: "person.circle")
            :
            Image(uiImage: viewModel.image!)
        )
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 30.0, height: 30.0)
        .clipShape(Circle())
    }

    var addFolderButton: some View {
        Image(systemName: "plus.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 30.0, height: 30.0)
            .clipShape(Circle())
    }

    var pinnedFolders: some View {
        Section(header: Text("Pinned folders")) {
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .important))) {
                HStack {
                    Image(systemName: "star")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                    Text(PinnedFolder.important.rawValue)
                }
            }
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .today))) {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                    Text(PinnedFolder.today.rawValue)
                }
            }
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .undelivered))) {
                HStack {
                    Image(systemName: "circle")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                    Text(PinnedFolder.undelivered.rawValue)
                }
            }
            NavigationLink(destination: TaskListView(viewModel: TaskListViewModel(pinnedFolderType: .allToDos))) {
                HStack {
                    Image(systemName: "archivebox")
                        .resizable()
                        .frame(width: 25.0, height: 25.0)
                    Text(PinnedFolder.allToDos.rawValue)
                }
            }
        }
    }

    var myFolders: some View {
        Section(header: Text("Your folders")) {
            ForEach(viewModel.folderCellViewModels) { folderCellVM in
                NavigationLink(
                    destination: TaskListView(viewModel: TaskListViewModel(currentFolder: folderCellVM.folder)),
                    label: {
                    FolderCell(folderCellVM: folderCellVM)
                })
            }
            .onDelete(perform: {offsets in
                viewModel.deleteFolders(at: offsets, folders: viewModel.folderCellViewModels)
            })
            if presentAddNewItem {
                NewFolderCell(folderCellVM: FolderCellViewModel(folder: Folder(title: ""))) { folder in
                    self.viewModel.addFolder(folder: folder)
                    self.presentAddNewItem.toggle()
                }
            }
        }
    }

//    var addFolderButton: some View {
//        Button(action: {
//            self.presentAddNewItem.toggle()
//        }){
//            HStack(alignment: .center){
//                Spacer()
//                Text("Add new folder")
//                Image(systemName: "plus.circle.fill")
//                    .resizable()
//                    .frame(width: 20, height: 20)
//            }
//        }
//        .padding(5)
//    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView(viewModel: FolderListViewModel(storage: FBStorage(uid: "")) {})
    }
}

struct FolderCell: View {
    @ObservedObject var folderCellVM: FolderCellViewModel

    var body: some View {
        VStack {
            HStack {
//                Image(systemName: "checkmark.circle.fill")
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 15, height: 15)
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
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 15, height: 15)
                TextField("Enter the folder name", text: $folderCellVM.folder.title, onCommit: {
                    self.onCommit(self.folderCellVM.folder)
                })
            }
        }
    }
}
