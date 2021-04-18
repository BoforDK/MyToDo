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
            Image(systemName: SystemImageName.person.rawValue)
            :
            Image(uiImage: viewModel.image!)
        )
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 30.0, height: 30.0)
        .clipShape(Circle())
    }

    var addFolderButton: some View {
        Image(systemName: SystemImageName.plus.rawValue)
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
                    icon: Image(systemName: value.getSystemImageName.rawValue),
                    size: .large)
            }
        }
    }

    var myFolders: some View {
        Section(header: Text("Your folders")) {
            ForEach(viewModel.folderCellViewModels) { folderCellVM in
                FolderView(
                    taskListViewModel: TaskListViewModel(currentFolder: folderCellVM.folder),
                    title: folderCellVM.folder.title,
                    icon: Image(systemName: SystemImageName.list.rawValue),
                    size: .medium)
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
                Image(systemName: SystemImageName.list.rawValue)
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

    var icon: Image

    var size: FolderViewSize

    var body: some View {
        NavigationLink(destination: TaskListView(viewModel: taskListViewModel)) {
            HStack {
                icon
                    .resizable()
                    .frame(width: size.rawValue, height: size.rawValue)
                Text(title)
            }
        }
    }

    enum FolderViewSize: CGFloat {
        case large = 25
        case medium  = 15
    }
}
