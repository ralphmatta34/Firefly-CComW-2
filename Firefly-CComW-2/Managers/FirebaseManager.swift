//
//  FirebaseManager.swift
//  Firefly-CComW-2
//
//  Created by Matta, Ralph (PEPW) on 11/06/2024.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

@Observable
class FirebaseManager {
    static let shared = FirebaseManager()
    
    private let db = Firestore.firestore()
    
    private init() {}
    
    func saveTodo(todo: String) {
        let newTodoRef = db.collection("todos").document()
        newTodoRef.setData([
            "content": todo,
            "createdAt": Date()
        ])
    }
    
    func getTodos(completion: @escaping ([Todo]?, Error?) -> Void) {
        db.collection("todos").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil, error)
            }
            else {
                guard let documents = querySnapshot?.documents else {
                    print("Error getting Snapshot documents")
                    completion(nil, nil)
                    return
                }
                
                var todos: [Todo] = [Todo]()
                for document in documents {
                    let id = document.documentID
                    let data = document.data()
                    let todo = Todo(data: data, id: id)
                    todos.append(todo)
                }
                completion(todos, nil)
            }
        }
    }
    
    func deleteTodo(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("todos").document(id).delete {error in
            completion(error)
        }
        
    }
    
}
