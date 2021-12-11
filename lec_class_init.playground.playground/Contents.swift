import UIKit
import Foundation

// 처음 코드
struct Grade {
    var letter: Character
    var points: Double
    var credits: Double
}

class Person {
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    func printMyName() {
        print("My name is \(firstName) \(lastName)")
    }
}

class Student: Person {
    var grades: [Grade] = []
    
    override init(firstName: String, lastName: String) {
        super.init(firstName: firstName, lastName: lastName)
    }
    
    // student를 받아서 새로운 student를 받게 할 수 있다.
    convenience init(student: Student){
        self.init(firstName: student.firstName, lastName: student.lastName)
    }
    
}

// 학생인데 운동선수
class StudentAthlete: Student {
    var minimumTrainingTime: Int = 2
    var trainedTime: Int = 0
    var sports: [String]
    
    // class에서 store property를 생성하면, 반드시 initalize 된 값을 부여해야 한다.
    // 선언만 해놓으면 에러 발생!!
    init(firstName: String, lastName: String, sports: [String]) {
        // 생성자를 만들 때, 규칙이 있다.
        // 1. subclass에 해당하는 init 을 먼저 작성한다.
        // 2. superclass에 있는 init에 해당하는 것을 나중에 작성한다.
        // -> super.init 을 사용한다.
        
        // two phase initializaion
        // Phase 1 -> property Setting
        self.sports = sports
        super.init(firstName: firstName, lastName: lastName) // 상속 받고 있는 내용에 대해서는 super를 사용하여 initalize 할 수 있다.
        
        // Phase 2 -> method 호출 가능
        self.train()
    }
    
    // 너무 많은 proprety가 존재 할때, 모두 init 시키기 어려울 수 있다.
    // 따라서, 간소화 시키는 방법에 대해 알아본다.
    //  convenience init
    //   init 시키지 않아도 되는 parameter는 제외 시킬 수 있다.
    convenience init(name: String) {
        self.init(firstName: name, lastName: "", sports: [])
    }

    func train() {
        trainedTime += 1
    }
}

// 운동선수인데 축구선수
class FootballPlayer: StudentAthlete {
    var footballTeam = "FC Swift"

    override func train() {
        trainedTime += 2
    }
}

//lecture Start
let student1 = Student(firstName: "Jason", lastName: "Lee")
let student2 = StudentAthlete(firstName: "Jay", lastName: "Kim", sports: ["FootBall"])
// convenience init 사용
let student3 = StudentAthlete(name: "Mike")
let student1_1 = Student(student: student1)
