//
//  PriceTextFieldCellViewModel.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/02.
//

import RxSwift
import RxCocoa
import UIKit

struct PriceTextFieldCellViewModel {
    
    // ViewModel -> View
    let showFreeShareButtonTapped: Signal<Bool>
    let resetPrice: Signal<Void>
    
    // View -> ViewModel
    let priceValue = PublishRelay<String?>()
    let freeShareButtonTapped = PublishRelay<Void>()
    
    init () {
        self.showFreeShareButtonTapped = Observable
            .merge(
                priceValue.map { $0 ?? "" == "0" },
                freeShareButtonTapped.map { _ in false}
            )
            .asSignal(onErrorJustReturn: false)
        
        self.resetPrice = freeShareButtonTapped
            .asSignal(onErrorSignalWith: .empty())
    }//: init()
    
}
