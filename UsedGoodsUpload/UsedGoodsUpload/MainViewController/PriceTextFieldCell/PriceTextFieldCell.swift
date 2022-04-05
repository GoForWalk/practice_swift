//
//  PriceTextFieldCellViewController.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/03.
//

import RxCocoa
import RxSwift
import UIKit

class PriceTextFieldCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    let priceInputField = UITextField()
    let freeShareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attirbute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ vm: PriceTextFieldCellViewModel) {
        // ViewModel -> View
        vm.showFreeShareButtonTapped
            .map { !$0 }
            .emit(to: freeShareButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        vm.resetPrice
            .map { _ in "" }
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        // View -> ViewModel
        priceInputField.rx.text
            .bind(to: vm.priceValue)
            .disposed(by: disposeBag)
        
        freeShareButton.rx.tap
            .bind(to: vm.freeShareButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attirbute() {
        // freeShareButton
        freeShareButton.setTitle("무료나눔  ", for: .normal)
        freeShareButton.setTitleColor(.orange, for: .normal)
        freeShareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeShareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeShareButton.tintColor = .orange
        freeShareButton.backgroundColor = .white
        freeShareButton.layer.borderColor = UIColor.orange.cgColor
        freeShareButton.layer.borderWidth = 1.0
        freeShareButton.layer.cornerRadius = 10.0
        freeShareButton.clipsToBounds = true
        freeShareButton.isHidden = true
        freeShareButton.semanticContentAttribute = .forceRightToLeft
        
        // priceInputField
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
    }
    
    private func layout() {
        [ priceInputField, freeShareButton].forEach {
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeShareButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
    }
}
