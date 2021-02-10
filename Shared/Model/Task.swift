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
    var isImportant: Bool = true
    @ServerTimestamp var createdTime: Timestamp?
    var plannedDay: Timestamp?
    var userId: String?
    var folderId: String?
    var location: GeoPoint?
}

