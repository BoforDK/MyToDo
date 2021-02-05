//
//  TaskRepository.swift
//  MyToDo
//
//  Created by Alexander on 2/3/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class TaskRepository: ObservableObject {
    let db = Firestore.firestore()
    
    @Published var tasks = [Task]()
    
    init() {
        loadData()
    }
    
    func loadData() {
        guard let userId = Auth.auth().currentUser?.uid else {
            fatalError("User does not exist")
        }
        db.collection("tasks")
            .order(by: "createdTime")
            .whereField("userId", isEqualTo: userId)
            .addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot {
                self.tasks = querySnapshot.documents.compactMap{ document in
                    do {
                        let x = try document.data(as: Task.self)
                        return x
                    } catch let error{
                        print(error)
                    }
                    return nil
                }
            }
        }
    }
    
    func addTask (_ task: Task) {
        do {
            var addedTask = task
            addedTask.userId = Auth.auth().currentUser?.uid
            let _ = try db.collection("tasks").addDocument(from: addedTask)
        } catch {
            fatalError("Unable to encode task: \(error.localizedDescription)")
        }
    }
    
    func updateTask(_ task: Task) {
        if let taskID = task.id {
            do {
                try db.collection("tasks")
                    .document(taskID)
                    .setData(from: task)
            } catch {
                fatalError("Unable to encode task: \(error.localizedDescription)")
            }
        }
    }
}
