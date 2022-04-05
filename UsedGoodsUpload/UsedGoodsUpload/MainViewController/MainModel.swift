//
//  MainModel.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/05.
//

import UIKit
import RxSwift

struct MainModel {
    
    func setAlert(errorMessage: [String]) -> Alert {
        let title = errorMessage.isEmpty ? "성공" : "실패"
        let message = errorMessage.isEmpty ? nil : errorMessage.joined(separator: "/n")
        return (title: title, message: message)
        
    }
}
