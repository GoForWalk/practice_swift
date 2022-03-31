//
//  MainViewController.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/26.
//

import RxCocoa
import RxSwift
import UIKit

// 1. Alert popup
class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let listView = BlogListView()
    
    let alertActionTapped = PublishRelay<AlertAction>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super .init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        // network setting
        let blogResult = searchBar.shouldLoadResult // searchBar에서 가져온 text
            .flatMapLatest { query in
                SearchBlogNetwork().searchBlog(query: query)
            }
            .share() // stream을 공유
        
        let blogValue = blogResult
            .compactMap { data -> DKBlog? in
                guard case .success(let value) = data else { return nil }
                
                return value // vaule: DKBlog
            }
        
        let blogError = blogResult
            .compactMap { data -> String? in
                guard case .failure(let error) = data else { return nil }
                
                return error.localizedDescription
            }
        
        // 네트워크를 통해서 가져온 값을 cellData로 변환
        let cellData = blogValue
            .map { blog -> [BlogListCellData] in
                return blog.documents
                    .map { doc in
                        let thumbnailURL = URL(string: doc.thumbnail ?? "") // String -> URL
                        return BlogListCellData(
                            thumbnailURL: thumbnailURL,
                            name: doc.name,
                            title: doc.title,
                            datetime: doc.datetime
                        )
                    }
                
            }
        
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
            .combineLatest(
                sortedType,
                cellData
            ) { type, data -> [BlogListCellData] in
                switch type {
                case .datetime:
                    return data.sorted {
                        $1.datetime ?? Date() < $0.datetime ?? Date()
                    }
                case .title:
                    return data.sorted {
                        $0.title ?? "" < $1.title ?? ""
                    }
                default:
                    return data
                }
            }
            .bind(to: listView.cellData)
            .disposed(by: disposeBag)
        
        
        // alert popup
        let alertSheetForSorting = listView.headerView.sortButtonTapped
            .map { _ -> Alert in // 처음에는 void 이지만, tap 되면 Alert 타입으로 변경
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        // Error message
        let alertErrorMessage = blogError
            .map { message -> Alert in
                return (
                    title: "오류 발생",
                    message: "다음과 같음 오류가 발생하였습니다. \(message)",
                    actions: [.confirm],
                    style: .alert
                )
            }
        
        Observable
            .merge(
                alertErrorMessage,
                alertSheetForSorting
            )
            .asSignal(onErrorSignalWith: .empty())
            .flatMapLatest { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: alertActionTapped)
            .disposed(by: disposeBag)
            
    }
    
    // view의 attribution 에 해당하는 코드
    private func attribute() {
        title = "다음 블로그 검색"
        view.backgroundColor = .white
        
    }
    
    // snapkit을 사용하여 autoLayout 설정
    private func layout() {
        [searchBar, listView].forEach { view.addSubview($0) }
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        listView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: Alert popup
extension MainViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title, datetime, cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "DateTime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }//: enum AlertAction
    
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty()}
        return Observable
            .create{[weak self] observer in
                guard let self = self else { return Disposables.create() }
                for action in actions {
                    alertController.addAction(
                        UIAlertAction(title: action.title, style: action.style, handler: { _ in
                            observer.onNext(action)
                            observer.onCompleted()
                        })
                    )
                }
                self.present(alertController, animated: true, completion: nil)
                
                return Disposables.create {
                    alertController.dismiss(animated: true, completion: nil)
                }
            }
            .asSignal(onErrorSignalWith: .empty())
    }//: presentAlertController()
    
}//: extension MainViewController
