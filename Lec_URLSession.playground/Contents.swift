import UIKit

// URL
let urlString = "https://itunes.apple.com/search?term=zion.T&entity=musicVideo" // url 주소
let url = URL(string: urlString)

url?.absoluteString
url?.scheme // Network의 방식
url?.host
url?.path
url?.query
url?.baseURL

let baseURL = URL(string: "https://itunes.apple.com")
let relativeURL =  URL(string: "search?term=zion.T&entity=musicVideo", relativeTo: baseURL)

relativeURL?.absoluteString
relativeURL?.scheme // Network의 방식
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL


// URLComponents
// URL은 서버가 인식할 수 있는 언어로 인코딩해주는 툴 -> 한글은 URL로 인코딩을 해야한다.

var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")
let termQuery = URLQueryItem(name: "term", value: "자이언티")
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "musicVideo")

urlComponents?.queryItems?.append(termQuery)
urlComponents?.queryItems?.append(mediaQuery)
urlComponents?.queryItems?.append(entityQuery)

urlComponents?.url
urlComponents?.string
urlComponents?.queryItems?.first?.value
