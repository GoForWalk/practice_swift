import Foundation

struct Developer {
    let name: String
}

struct Company {
    let name: String
    var developer: Developer?
}

var company = Company(name: "Gunter", developer: nil)
print(company.developer) // result: nil

var developer = Developer(name: "han")
company.developer = developer
print(company.developer) // result: Optional(__lldb_expr_6.Developer(name: "han"))
print(company.developer?.name) // result: Optional("han")
// ?로 optional chaining 할 경우, 접근한 property의 값은 항상 optional에 감싸져 있다.
// 값이 nil 이 될 수도 있다.
print(company.developer!.name) // result: han
// !로 optional chaining 할 경우, property를 강제 unwrapping 하여 값이 optinal로 감싸져 있지 않다.
