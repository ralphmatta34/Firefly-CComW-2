//
//  Todo.swift
//  Firefly-CComW-2
//
//  Created by Matta, Ralph (PEPW) on 11/06/2024.
//

import Foundation
import FirebaseFirestore

struct Todo {
    let id: String
    let content: String
    let createdAt: Date
    
    init(data: [String: Any], id: String) {
        self.content = data["content"] as? String ?? String()
        let timestamp = data["createdAt"] as? Timestamp ?? nil
        self.createdAt = timestamp?.dateValue() ?? Date()
        self.id = id
    }
}
