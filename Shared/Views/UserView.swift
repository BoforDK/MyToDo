//
//  UserView.swift
//  MyToDo
//
//  Created by Alexander on 2/5/21.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: UserViewModel
//    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Section {
            Text("User image")
            Text("Email")
            Text("Setting")
            Toggle("Auto login", isOn: $viewModel.autoLogin)
            Text("Change password")
            Button("Logout", action: {
//                self.presentationMode.wrappedValue.dismiss()
                viewModel.logout()
            })
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(viewModel: UserViewModel(logout: {}))
    }
}
