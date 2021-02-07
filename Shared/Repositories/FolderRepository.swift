//
//  FolderRepository.swift
//  MyToDo
//
//  Created by Alexander on 2/6/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class FolderRepository: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var folders = [Folder]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("User does not exist")
        }
        db.collection("folders")
            .order(by: "title")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.folders = querySnapshot.documents.compactMap{ document in
                    do {
                        let x = try document.data(as: Folder.self)
                        return x
                    } catch let error{
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func addFolder (_ folder: Folder) {
        do {
            var addedFolder = folder
            addedFolder.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("folders").addDocument(from: addedFolder)
        } catch {
            fatalError("Unable to encode folder: \(error.localizedDescription)")
        }
    }
    
    func updateFolder(_ folder: Folder) {
        if let folderID = folder.id {
            do {
                try db.collection("folders")
                    .document(folderID)
                    .setData(from: folder)
            } catch {
                fatalError("Unable to encode folder: \(error.localizedDescription)")
            }
        }
    }
}
