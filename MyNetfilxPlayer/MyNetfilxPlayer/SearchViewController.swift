//
//  SearchViewController.swift
//  MyNetfilxPlayer
//
//  Created by sae hun chung on 2022/01/05.
//

import UIKit
import Kingfisher // kingfisher Import
import AVFoundation

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
//  viewController 누르면 키보드 내려가게 구현
//    @IBAction func tapBG (_ sender: Any) {
//        searchBar.resignFirstResponder()
//    }
}

extension SearchViewController: UICollectionViewDataSource {
    // 넘어오는 data 갯수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    // 구현 방법에 대한 코드
    // dequeueReusable
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath)
                as? ResultCell else { return UICollectionViewCell() }
        // cell update
        let movie = movies[indexPath.item]
        let url = URL(string: movie.thumbnailPath)!
        
        // 이미지 path -> image 로 가져오는 작업
        // 직접 구현 해보기 & 외부 코드 가져다 쓰기(서드파티) -> Kingfisher
        // SPM (Swift Package Manager), Cocoa Pod, Carthage -> 외부 코드 가져와서 사용할 수 있다.
        
        // kingfisher 사용
        cell.movieThumbnail.kf.setImage(with: url)
        return cell
    }
    
    
}

extension SearchViewController: UICollectionViewDelegate {
    // tap 했을 경우 작업 수행
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // movie
        // player vc (viewController)
        // player vc + movie
        // presenting Player vc
        let movie = movies[indexPath.item]
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        print("---> movie url \(movie.thumbnailPath)")
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        // modal style (modal default -> custom)
        vc.modalPresentationStyle = .fullScreen
        
        vc.player.replaceCurrentItem(with: item)
        // vc presenting
        present(vc, animated: false, completion: nil)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    // 각 cell 의 Size 조절
    // 3개의 cell 표시
    // cell 간 spacing = 10 / controllView 의 margin = 8
    // width : height = 7 : 10
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2 ) / 3
        let height = width * 10 / 7
        return CGSize(width: width, height: height)
    }
}

class ResultCell: UICollectionViewCell {
    @IBOutlet weak var movieThumbnail: UIImageView!
    
    
    
    
    
}

extension SearchViewController: UISearchBarDelegate {
    // keyborad에서 Search button을 눌렀을 때, 검색하는 기능 구현
    
    private func dismissKeyboard() {
        // searcnBar를 누르면 FirstResponder로 올라간다.
        // 검색 누르면 키보드 내려가게 구현
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // search 버튼 누르는 순간
        
        // 검색 시작
        
        // 키보드 올라와 있을 때, 내려가게 처리
        dismissKeyboard()
        // 검색어가 있는지
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else {return}

        // 네트워킹을 통한 검색
        // - 목표: 서치텀을 가지고 네트워킹을 통해서 영화 검색
        // - 검색 API가 필요
        // - 결과를 받아올 모델 Movie, Response
        // - 결과를 받아와서 CollectionView로 표현하기
        
        // instance method
        
        // type method
        SearchAPI.search(searchTerm) {movies in // netWork Thread
            // collectionView로 표현하기
            print("---> SearchAPI.search / resultCount: \(movies.count), First Movie Title: \(movies.first?.title)")
            
            // 쓰레드 지정
            DispatchQueue.main.async {
                self.movies = movies
                self.resultCollectionView.reloadData() // 화면 새로고침
            }
        }
        
        print("---> 검색어: \(searchTerm)")
    }
}

class SearchAPI {
    // type method vs instance method
    static func search(_ term: String, completion: @escaping ([Movie]) -> Void) {
        // What is @escaping? : 해당 param의 코드 블럭이 현재 method 밖에서 실행된다.
        // swift document 참고
        
        // URLSession 사용
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let itemQuerty = URLQueryItem(name: "term", value: term)
        
        urlComponents.queryItems?.append(itemQuerty)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(mediaQuery)
        let requestURL = urlComponents.url!
        
        let dataTask = session.dataTask(with: requestURL) {data, response, error in
            // TODO: Data 받아와서 Parsing
            let successRange = 200..<300
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                    successRange.contains(statusCode) else {
                        completion([]) // @escaping
                        print("---> NetWork Error\(String(describing: error?.localizedDescription))")
                        return
                    }
            
            guard let resultData = data else {
                completion([])
                return
            }
            
            // data -> [Movie] : Parsing 필요
//            let string = String(data: resultData, encoding: .utf8)
            
            // object parsing
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies) // @escaping 으로 completion 넘겨준다.
            print("---> result: \(movies.count)")
            
        } // end completionHandler closure
        
        //dataTask 실행
        dataTask.resume()
        
    } // end func Search
    
    static func parseMovies(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
            let movies = response.movies
            return movies
        } catch let error{
            print(" ---> Parsing error: \(error.localizedDescription)")
            return []
        }
    } // end func parseMovies
} // end Class SearchAPI

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case resultCount
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let director: String
    let thumbnailPath: String
    let previewURL: String
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case director = "artistName"
        case thumbnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
    }
    
}
