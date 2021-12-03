import UIKit

// 도전과제
// 1. 강의 이름, 강사 이름, 학생 수를 가지는 Struct 만들기 (Lecture)
// 2. 강의 Array와 강사 이름을 받아서, 해당 강사의 강의 이름을 출력하는 함수 만들기
// 3. 강의 3개를 만들고, 강사 이름으로 강의 찾기.

// Protocol 추가 : CustomStringConvertible

//struct Lecture {
//    let lecName: String
//    let teacherName: String
//    let studentNum: Int
//}

// --- protocol 추가
struct Lecture: CustomStringConvertible {
    var description: String {
        // 이 Lecture 에 대해서 설명하는 내용
        return "Title: \(lecName), Teacher: \(teacherName)"
    }
    
    let lecName: String
    let teacherName: String
    let studentNum: Int
}

let lecture1 = Lecture(lecName: "iOS code", teacherName: "Kevin", studentNum: 15)
let lecture2 = Lecture(lecName: "Java code", teacherName: "Jason", studentNum: 10)
let lecture3 = Lecture(lecName: "python code", teacherName: "Soo", studentNum: 7)

//func printLecNameByTeacherName (lectures: [Lecture], teacherName: String) {
//    var teacherBool = false
//    for lecture in lectures {
//        if lecture.teacherName.contains(teacherName) {
//            let lectureName = lecture.lecName
//            teacherBool = true
//            print("\(teacherName) 선생님의 강의 이름은 \(lectureName)")
//        }
//    }
//
//    if teacherBool == false {
//        print("선생님의 이름을 확인해주세요.")
//    }
//}

// using Closrue
func printLecNameByTeacherName (lectures: [Lecture], teacherName: String) {
//    var teacherBool = false
    let lectureName = lectures.first{ (lec) -> Bool in
                        return lec.teacherName == teacherName
    }?.lecName ?? "선생님의 이름을 확인해주세요."
    print("강의명: \(lectureName)")
}

printLecNameByTeacherName(lectures: [lecture1, lecture2, lecture3], teacherName: "Kevin")
printLecNameByTeacherName(lectures: [lecture1, lecture2, lecture3], teacherName: "Joo")

// CustomStringConvertible 의 protocol을 사용하여 description 설정 -> 사용
print(lecture1)
