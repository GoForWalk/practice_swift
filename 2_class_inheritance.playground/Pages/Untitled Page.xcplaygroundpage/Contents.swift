import UIKit

// 처음 주어진 코드
//struct Grade {
//    var letter: Character
//    var points: Double
//    var credits: Double
//}
//
//class Person {
//    var firstName: String
//    var lastName: String
//
//    init(firstName: String, lastName: String) {
//        self.firstName = firstName
//        self.lastName = lastName
//    }
//
//    func printMyName() {
//        print("My name is \(firstName) \(lastName)")
//    }
//}
//
//class Student {
//    var grades: [Grade] = []
//
//    var firstName: String
//    var lastName: String
//
//    init(firstName: String, lastName: String) {
//        self.firstName = firstName
//        self.lastName = lastName
//    }
//
//    func printMyName() {
//        print("My name is \(firstName) \(lastName)")
//    }
//}

// Start Lecture
struct Grade {
    var letter: Character // A B C D F
    var points: Double
    var credits: Double
}

class Person { // class
    var firstName: String
    var lastName: String

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

    func printMyName() { // method
        print("My name is \(firstName) \(lastName)")
    }
}

// person을 상속 받는다.
class Student: Person {
    var grades: [Grade] = []

    // 중복되는 내용 최소화 -> 상속 사용
//    var firstName: String
//    var lastName: String
//
//    init(firstName: String, lastName: String) {
//        self.firstName = firstName
//        self.lastName = lastName
//    }
//
//    func printMyName() {
//        print("My name is \(firstName) \(lastName)")
//    }
}

let jay = Person(firstName: "Jay", lastName: "Lee")
let jason = Student(firstName: "Jason", lastName: "Lee")

jay.firstName
jason.firstName

jay.printMyName()
jason.printMyName()

let math = Grade(letter: "B", points: 8.5, credits: 3)
let history = Grade(letter: "A", points: 10.0, credits: 3)

jason.grades.append(math)
jason.grades.append(history)

jason.grades[0].letter
jason.grades.count

// 상속의 깊이

// 학생 & 운동선수
class StudentAthelete: Student { // Person -> Student를 상속 받음
    var minimumTraningTime: Int = 2
    var trainedTime: Int = 0
    
    func train() {
        trainedTime += 1
    }
}

// 운동선수인데 축구선수
class FootballPlayer: StudentAthelete { // person -> Student -> StudentAthelete
    var footballTeam = "FC Swift"
    
    // 상속 받는 class의 method를 수정할 때
    // override 사용
    override func train() {
        trainedTime += 2
    }
}

var athelete1 = StudentAthelete(firstName: "Yuna", lastName: "Kim")
var athelete2 = FootballPlayer(firstName: "Heung", lastName: "Son")

// Person
athelete1.firstName
athelete2.firstName

// Student
athelete1.grades.append(math)
athelete2.grades.append(math)

// Athelete
athelete1.minimumTraningTime
athelete2.minimumTraningTime

// Football
athelete2.footballTeam

athelete1.train()
athelete2.train()

athelete1.trainedTime
athelete2.trainedTime

// 재 할당 가능
// upper casting
athelete1 = athelete2 as StudentAthelete
athelete1.train()
athelete1.trainedTime

//athelete1 은 footballteam에 접근 할 수 없다.
// down casting
if let son = athelete1 as? FootballPlayer {
    print("--> \(son.footballTeam)")
    //
}

