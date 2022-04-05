//
//  DetailWriteFormCell.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/04.
//

import UIKit
import RxSwift
import RxCocoa

class DetailWriteFormCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    let contentInputView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ vm: DetailWriteFormCellViewModel) {
        contentInputView.rx.text
            .bind(to: vm.contentValue)
            .disposed(by: disposeBag)
            
    }//: bind()
    
    private func attribute() {
        contentInputView.font = .systemFont(ofSize: 17)
    }//: attribute()
    
    private func layout() {
        contentView.addSubview(contentInputView)
        
        contentInputView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(15)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(300)
        }
    }// : layout()
}

extension DetailWriteFormCell: UITextViewDelegate {
    
}
