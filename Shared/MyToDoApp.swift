//
//  MyToDoApp.swift
//  Shared
//
//  Created by Alexander on 1/23/21.
//

import SwiftUI
import Firebase

@main
struct MyToDoApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
