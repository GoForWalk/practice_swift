//
//  BlogListViewModel.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/31.
//

import RxCocoa
import RxSwift

struct BlogListViewModel {
    let filterViewModel = FilterViewModel() // HeaderView
    
    // Stream
    // MainViewController(network data) -> BlogListView
    let blogCellData = PublishSubject<[BlogListCellData]>()
    let cellData: Driver<[BlogListCellData]>
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
}
