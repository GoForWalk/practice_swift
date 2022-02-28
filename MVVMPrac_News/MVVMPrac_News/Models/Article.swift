//
//  Article.swift
//  MVVMPrac_News
//
//  Created by sae hun chung on 2022/02/21.
//

import Foundation

struct ArticleList: Decodable {
    let articles : [Article]
}

struct Article : Decodable {
    let title : String
    let description : String
}
