//
//  MainView.swift
//  MyToDo
//
//  Created by Alexander on 2/4/21.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel = MainViewModel()

    var body: some View {
        NavigationView {
        switch viewModel.state {
        case .authorization:
            AuthorizationView(viewModel: AuthorizationViewModel(sendLoginEvent: { email, password in
                viewModel.send(event: .onAccountEntry(email, password))
            }))
        case .checking:
            ProgressView("Loading...")
        case .successful:
            FolderListView(viewModel: FolderListViewModel(
                storage: FBStorage(uid: UserRepository().user.uid),
                logout: {
                    viewModel.cancelAutoAuth()
                    viewModel.send(event: .onLogout)
                    }))
        case .error:
            AuthorizationView(viewModel: AuthorizationViewModel(error: true, sendLoginEvent: { email, password in
                viewModel.send(event: .onAccountEntry(email, password))
            }))
        }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
