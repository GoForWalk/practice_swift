//
//  CategoryViewModel.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/01.
//

import RxCocoa
import RxSwift

struct CategoryViewModel {
    let disposeBag = DisposeBag()
    
    // ViewModel -> View
    let cellData: Driver<[Category]>
    let pop: Signal<Void>
    
    // View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    // 최신의 카테고리를 갖는 Stream
    // ViewModel -> ParentViewModel
    let selectedCategory = PublishSubject<Category>()
    
    init() {
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected
            .map {
                categories[$0]
            }
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        self.pop = itemSelected
            .map { _ in Void() }
            .asSignal(onErrorSignalWith: .empty())
        
    }//: init()
    
}//: CategoryViewModel
