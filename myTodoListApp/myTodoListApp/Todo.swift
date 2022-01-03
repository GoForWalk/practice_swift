//
//  Todo.swift
//  myTodoListApp
//
//  Created by sae hun chung on 2021/12/27.
//

import UIKit

// TODO: codable과 Equatable 추가
struct Todo: Codable, Equatable {
    let id: Int // 구분자
    var isDone: Bool
    var detail: String
    var isToday: Bool
    
    // id는 생성자에 넣지 않는다.
    mutating func update(isDone: Bool, detail: String, isToday: Bool){
        // TODO: update Logic 추가
        // 값을 변경시킨다. (id 는 변경 X)
        self.isDone = isDone
        self.detail = detail
        self.isToday = isToday
    }
    
    // Protocal Equatable
    // == : 여러개의 Todo 중에서 무엇을 업데이트 시킬 것인지 구분자를 찾아서 판별하는 방법
    // 객체 간의 동등 비교를 통해서 Todo를 비교한다.
    static func == (lhs: Self, rhs: Self) -> Bool { // TODO: lhs, rhs 가 뭐임? -> Notion!!
        // TODO: 동등 조건 추가
        // right hand side(lhs) & right hand side(rhs)
        return lhs.id == rhs.id
    }
}

//
class TodoManager {
    
    // Singleton Pattern
    // 앱 내에서 전반적으로 Data를 관리하는 객체
    static let shared = TodoManager()
    
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(detail: String, isToday: Bool) -> Todo {
        // lastId를 기준으로 ++
        let nextId = TodoManager.lastId + 1
        TodoManager.lastId = nextId
        return Todo(id: nextId, isDone: false, detail: detail, isToday: isToday)
    }
    
    func addTodo(_ todo: Todo){
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo){
//        todos = todos.filter{ existingTodo in
//            return existingTodo.id != todo.id
//        }
        
        todos = todos.filter{ $0.id != todo.id}
        // better algorism
//        if let index = todos.firstIndex(of: todo) {
//            todos.remove(at: index)
//        }
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo) {
        // TODO: updateTodo
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, detail: todo.detail, isToday: todo.isToday)
        saveTodo()
    }
    
    func saveTodo(){
        Storage.store(todos, to: .documets, as: "todos.json")
    }
    
    func retrieveTodo() {
        todos = Storage.retrive("todos.json", from: .documets, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
    }
    
}

class TodoViewModel { // TODO: enum의 역할?
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
    
    func updateTodo(_ todo: Todo){
        manager.updateTodo(todo)
    }
    
    func loadTasks(){
        manager.retrieveTodo()
    }
    
    
}
