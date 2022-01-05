import UIKit
import Foundation

// URLSession

// 1. URLSessionConfiguration
// 2. URLSession
// 3. URLSessionTask 를 이용해서 서버와 네트워킹

// URLSessionTask

// - dataTask
// - upload
// - downloadTask

let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)

// URL
// URL Components
var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")
let termQuery = URLQueryItem(name: "term", value: "자이언티")
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "musicVideo")

urlComponents?.queryItems?.append(termQuery)
urlComponents?.queryItems?.append(mediaQuery)
urlComponents?.queryItems?.append(entityQuery)

let requestUrl = urlComponents?.url


struct Response: Codable { // Codable protocol 준수
    let resultCount: Int
    let tracks: [Track]
    
    enum CodingKeys: String, CodingKey { // 받아오는 JSON data와 만들 object 매칭
        case resultCount
        case tracks = "results"
        
    }
}

struct Track: Codable { // Codable protocol 준수
    let title: String
    let artistName: String
    let thumbnailPath: String
    
    enum CodingKeys: String, CodingKey { // 오타 주의!!
        case title = "trackName"
        case artistName
        case thumbnailPath = "artworkUrl100"
        
    }
}


let dataTask = session.dataTask(with: requestUrl!) {(data, response, error) in
    guard error == nil else { return } // error 가 있을 경우, return
    
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {return}
    // 2XX Success
    let successRange = 200..<300
    
    guard successRange.contains(statusCode) else {
        // handle response error
        return
    }
    
    guard let resultData = data else {
        return
    }
//    let resultString = String(data: resultData, encoding: .utf8)
//    print("---> resultString: \(resultString!)")
    
    // 목표 : 트랙리스트 오브젝트로 가져오기
    
    // 하고싶은 목록
    // - Data - Track 목록으로 가져오고 싶다. [Track]
    // - Track 오브젝트를 만들어야겠다.
    // - Data에서 struct로 parsing 하고 싶다. > Codable 이용해서 만들자.
    //    - Json 형태의 파일, 데이터 -> 오브젝트(struct) `codable`이용하겠다.
    //    - Response, Track 이렇게 두개 만들어야 한다.
    
    // 해야할일
    // - Response, Track, struct
    // - struct의 프로퍼티 이름과 실제 데이터의 키와 맞추기 (Codable 디코딩하게 하기 위해서)
    // - 파싱하기 (Decoding)
    // - TrackList 가져오기
    
    
    
    // parsing 및 data 가져오기
    do {
        print("---> resultData: \(resultData)")
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: resultData)
        
        let tracks = response.tracks
        print("---> tracks: \(tracks.count) -- \(tracks.first?.title) -- \(tracks.first?.thumbnailPath)")
    } catch let error{
        print("---> error: \(error.localizedDescription)") // error 에 대한 설명
    }
} // Networking 할 URL

dataTask.resume() // dataTask 실행
