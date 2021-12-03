import UIKit

// collection - Dictionary

// dictionary 선언
var scoreDic: [String: Int] = ["Jason": 80, "Jay": 95, "Jake": 90]
//var scoreDic: Dictionary<String, Int> = ["Jason": 80, "Jay": 95, "Jake": 90]

if let score = scoreDic["Jason"] {
    score
} else {
    //.. score 없음
}
scoreDic["Jay"]

// 없는 사람은 nil
scoreDic["Jerry"]

// dic 비우기
//scoreDic = [:]

scoreDic.isEmpty
scoreDic.count

// 기존 사용자 업데이트
scoreDic["Jason"] = 99
scoreDic

// 사용자 추가
scoreDic["Jack"] = 100
scoreDic

// 사용자 제거
scoreDic["Jack"] = nil
scoreDic

// for loop
for (name, score) in scoreDic {
    print("name : \(name), score : \(score)")
}

// key만 출력하기
for key in scoreDic.keys {
    print(key)
}

// 도전과제
// 1. 이름, 직업, 도시에 대해서 본인의 Dictionary 만들기
// 2. 도시를 부산으로 업데이트하기
// 3. Dictionary를 받아서 이름과 도시 프린트하는 함수 만들기.

var personalInfo_jobDic: [String: String] = ["SH Chung": "Developer"]
var personalInfo_locDic: [String: String] = ["SH Chung": "Seoul"]

personalInfo_locDic["SH Chung"] = "Busan"

personalInfo_locDic

func printNameLoc(_ data: Dictionary<String, String>){
    for (name, location) in data {
        print("\(name), \(location)")
    }
}

printNameLoc(personalInfo_locDic)

var myDic: [String: String] = ["Name": "SH CHUNG", "Job": "iOS Developer", "Location": "Seoul"]

myDic["Location"] = "Busan"
myDic

func printNameAndLoc(dic: [String: String]){
    if let name = myDic["Name"], let loc = myDic["Location"]{
        print(name, loc)
    } else {
        print("---> Cannot Find")
    }
}

print("---- myDic -----")
printNameAndLoc(dic: myDic)
