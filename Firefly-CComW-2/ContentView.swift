//
//  ContentView.swift
//  Firefly-CComW-2
//
//  Created by Matta, Ralph (PEPW) on 11/06/2024.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newTodo: String = String()
    @State private var todos: [Todo] = [Todo]()
    @State private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    if todos.isEmpty {
                        Text("Add your first todo below")
                    }
                    else {
                        ForEach(todos, id: \.createdAt) { todo in
                            Text(todo.content)
                        }
                        .onDelete(perform: { indexSet in
                            indexSet.forEach { index in
                                firebaseManager.deleteTodo(id: todos[index].id) { error in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                    }
                                }
                                todos.remove(atOffsets: indexSet)
                            }
                        })
                    }
                }
                .listStyle(.plain)
                
                Divider()
                
                TextField("Enter a todo: ", text: $newTodo)
                    .onSubmit {
                        if newTodo.count > 0 {
                            firebaseManager.saveTodo(todo: newTodo)
                            newTodo = String()
                            firebaseManager.getTodos {todos, error in
                                if let error = error {
                                    print("Error: \(error.localizedDescription)")
                                }
                                else {
                                    guard let todos = todos else {
                                        print("Something has gone wrong")
                                        return
                                    }
                                    self.todos = todos.sorted {
                                        $0.createdAt < $1.createdAt
                                    }
                                }
                            }
                        }
                    }
            }
            .padding()
            .navigationTitle("Firefly")
        }
        .onAppear {
            firebaseManager.getTodos {todos, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
                else {
                    guard let todos = todos else {
                        print("Something has gone wrong")
                        return
                    }
                    self.todos = todos.sorted {
                        $0.createdAt < $1.createdAt
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
