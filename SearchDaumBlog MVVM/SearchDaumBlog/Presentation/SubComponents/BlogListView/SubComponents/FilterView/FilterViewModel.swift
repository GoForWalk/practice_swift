//
//  FilterViewModel.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/31.
//

import RxSwift
import RxCocoa

struct FilterViewModel {
    // stream 가져오기
    
    // FilterView 외부에서 관찰
    let sortButtonTapped = PublishRelay<Void>()
    
}
