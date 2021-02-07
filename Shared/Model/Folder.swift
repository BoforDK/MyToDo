//
//  Folder.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Folder: Codable, Identifiable {
    @DocumentID var id: String?
    var title: String
    var userId: String?
}
