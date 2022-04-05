//
//  MainViewModel.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/31.
//

import RxSwift
import RxCocoa
import UIKit

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let blogListViewModel = BlogListViewModel()
    let searchBarViewModel = SearchBarViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        // Network Logic은 ViewModel에서
        // network setting
        let blogResult = searchBarViewModel.shouldLoadResult // searchBar에서 가져온 text
            .flatMapLatest(model.searchBlog)
            .share() // stream을 공유
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 네트워크를 통해서 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
                
        
        // FilterView를 선택했을 때 나오는 alertSheet를 선택했을 때 type 지정
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime: // 이 두 액션만 기록하고 나머지 event는 무시
                    return true
                default:
                    return false
                }
            }
            .startWith(.title) // default event는 .title
        
        // MainViewController(Network 처리) -> ListView
        Observable
            .combineLatest(sortedType, cellData, resultSelector: model.sort)
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        // MARK: Alert
        // alert popup
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in // 처음에는 void 이지만, tap 되면 Alert 타입으로 변경
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        // Error message
        let alertErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (
                    title: "오류 발생",
                    message: "다음과 같음 오류가 발생하였습니다. \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertErrorMessage,
                alertSheetForSorting
            )
            .asSignal(onErrorSignalWith: .empty())
        
    }//: init()
}
