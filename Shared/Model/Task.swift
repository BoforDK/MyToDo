//
//  Task.swift
//  MyToDo
//
//  Created by Alexander on 2/3/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


struct Task: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String = ""
    var completed: Bool = true
    @ServerTimestamp var createdTime: Timestamp?
    var userId: String?
}


#if DEBUG
let testDataTasks = [
    Task(title: "Implement the UI", completed: true),
    Task(title: "Connect to Firebase", completed: false),
    Task(title: "????", completed: false),
    Task(title: "Profit????", completed: false)
]
#endif
