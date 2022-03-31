//
//  SearchBlogNetwork.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/30.
//

import Foundation
import RxSwift
import RxCocoa

enum SearchNetworkError: Error {
    case invalidJSON
    case networkError
}

class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> { // result type을 갖는 observable return
        // result type은 성공시, 실패시 return하는 타입을 지정할 수 있다. 
        guard let url = api.searchBlog(query: query).url else {
            return .just(.failure(.invalidJSON))
        }
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK 5c0099e6e22bd1a91ac91ac1e650c165", forHTTPHeaderField: "Authorization")
    
        return session.rx.data(request: request as URLRequest)
            .map { data in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
                
            }
            .catch { _ in
                    .just(.failure(.networkError))
            }
            .asSingle()
    }
        
}
