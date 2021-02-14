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
    @State var newFolderTitle = ""

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
            ForEach(PinnedFolder.allCases, id: \.id) { value in
                FolderView(
                    taskListViewModel: TaskListViewModel(pinnedFolderType: value),
                    title: value.rawValue,
                    systemImageName: value.getSystemImageName,
                    size: 25.0)
            }
        }
    }

    var myFolders: some View {
        Section(header: Text("Your folders")) {
            ForEach(viewModel.folderCellViewModels) { folderCellVM in
                FolderView(
                    taskListViewModel: TaskListViewModel(currentFolder: folderCellVM.folder),
                    title: folderCellVM.folder.title,
                    systemImageName: "list.bullet",
                    size: 15.0)
            }
            .onDelete(perform: {offsets in
                viewModel.deleteFolders(at: offsets, folders: viewModel.folderCellViewModels)
            })
            if presentAddNewItem {
                newFolderLine
            }
        }
    }

    var newFolderLine: some View {
        return VStack {
            HStack {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 15, height: 15)
                TextField("Enter the folder name", text: $newFolderTitle, onCommit: {
                    self.viewModel.addFolder(folder: Folder(title: newFolderTitle))
                    self.presentAddNewItem.toggle()
                })
            }
        }
    }
}

struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        FolderListView(viewModel: FolderListViewModel(storage: FBStorage(uid: "")) {})
    }
}

struct FolderView: View {
    var taskListViewModel: TaskListViewModel

    var title: String

    var systemImageName: String

    var size: CGFloat

    var body: some View {
        NavigationLink(destination: TaskListView(viewModel: taskListViewModel)) {
            HStack {
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: size, height: size)
                Text(title)
            }
        }
    }
}
