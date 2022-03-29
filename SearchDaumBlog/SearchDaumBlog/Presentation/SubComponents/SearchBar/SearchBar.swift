//
//  SearchBar.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/27.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    
    let searchButton = UIButton()
    
    // searchBar 버든 탭 이벤트
    let searchBarButtonTapped = PublishRelay<Void>() // error를 받지 않고, onNext 만 방출하는 PublishSubject()
    
    // searchBar 외부로 내보낼 이벤트
    var shouldLoadResult = Observable<String>.of("")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bind()
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bind() { // merge 사용
        // 1. searchBar search button tapped (키보드 search 버튼)
        // 2. button tapped (UI의 Button)
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(), // 1
                searchButton.rx.tap.asObservable() // 2
            )
            .bind(to: searchBarButtonTapped) // 한 observable에 bind!!
            .disposed(by: disposeBag)
        
        searchBarButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing) // 키보드가 내려감.
            .disposed(by: disposeBag)
        
        // searchBar에 입력된 text를 받는다. -> trigger 역할
        self.shouldLoadResult = searchBarButtonTapped
            .withLatestFrom(self.rx.text) { $1 ?? "" } // text 가 없다면 "" (빈값)을 보낸다.
            .filter { !$0.isEmpty } // 빈 값을 보내지 않도록 필터처리
            .distinctUntilChanged()
    }//: bind
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.systemBlue, for: .normal)
    }//: attribute
    
    private func layout() {
        addSubview(searchButton)
        
        searchTextField.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(12)
            $0.trailing.equalTo(searchButton.snp.leading).offset(-12)
            $0.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }//: layout
}//: SearchBar

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)

        }
    }
}
