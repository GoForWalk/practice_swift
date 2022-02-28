//
//  WebService.swift
//  MVVMPrac_News
//
//  Created by sae hun chung on 2022/02/21.
//

import Foundation

// MARK: API 받아오는 역할
class WebService {
    func getArticles(url : URL, completion: @escaping ([Article]?) -> ()){
        
        URLSession.shared.dataTask(with: url) { articleData, response, error in
            guard error != nil else {
                print("---> URLSession Error: \(String(describing: error?.localizedDescription))")
                completion(nil)
                return
            }
            
            guard articleData != nil else {
                print("have no article data")
                return
            }
            
            let articleList = try? JSONDecoder().decode(ArticleList.self, from: articleData!)
            print(articleList!)
            completion(articleList?.articles)
            
        }.resume()
        
    }
}
