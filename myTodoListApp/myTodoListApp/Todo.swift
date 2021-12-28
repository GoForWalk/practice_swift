//
//  Todo.swift
//  myTodoListApp
//
//  Created by sae hun chung on 2021/12/27.
//

import UIKit

// TODO: codable과 Equatable 추가
struct Todo: Codable, Equatable {
    let id: Int
    let isDone: Bool
    let detail: String
    let isToday: Bool
    
    // id는 생성자에 넣지 않는다.
    mutating func update(isDone: Bool, detail: String, isToday: Bool){
        // TODO: update Logic 추가
        
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool { // TODO: lhs, rhs 가 뭐임? -> Notion!!
        // TODO: 동등 조건 추가
        return true
    }
}

class TodoManager {
    
    // Singleton Pattern
    static let shared = TodoManager()
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(detail: String, isToday: Bool) -> Todo {
        // TODO: create Logic 추가
        return Todo(id: 1, isDone: false, detail: "2", isToday: true)
    }
    
    func addTodo(_ todo: Todo){
        // TODO: add logic 추가
    }
    
    func deleteTodo(_ todo: Todo){
        // TODO: deleteTodo 추가
    }
    
    func updateTodo(_ todo: Todo) {
        // TODO: updateTodo
    }
    
    func saveTodo(){
        // TODO: Storage 작성 이후에 추가 작성
        
    }
    
    func retrieveTodo() {
        // TODO: Storage 작성 이후에 추가 작성
    }
    
}

class ToDoViewModel { // TODO: enum의 역할?
    enum Section: Int, CaseIterable {
        case today
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default: return "Upcoming"
            }
        }
    }
    
    // Singleton Pattern
    private let manager = TodoManager.shared
    
    var todos: [Todo] {
        return manager.todos
    }
    
    var todayTodos: [Todo] {
        return todos.filter {$0.isToday == true}
    }
    
    var upcomingTodos: [Todo] {
        return todos.filter{ $0.isToday == false}
    }
    
    var numOfSection: Int {
        return Section.allCases.count
    }
    
    func addTodo(_ todo: Todo){
        manager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo){
        manager.deleteTodo(todo)
    }
    
    func loadTasks(){
        manager.retrieveTodo()
    }
    
}
