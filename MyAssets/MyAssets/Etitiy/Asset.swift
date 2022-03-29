//
//  Asset.swift
//  MyAssets
//
//  Created by sae hun chung on 2022/03/11.
//

import Foundation

class Asset: Identifiable, ObservableObject, Decodable {
    let id: Int
    let type: AssetMenu
    let data: [AssetData]
    
    init(id: Int, type: AssetMenu, data:[AssetData]){
        self.id = id
        self.type = type
        self.data = data
    }
}//: Asset

class AssetData: Identifiable, ObservableObject, Decodable {
    let id: Int
    let title: String
    let amount: String
    let creditCardAmounts: [CreditCardAmounts]? // 없을 경우 parsing error 를 방지하기 위해서.
    
    init(id: Int, title: String, amount: String, creditCardAmounts: [ CreditCardAmounts]? = nil) { // creditCardAmounts 가 없을 경우, nil
        self.id = id
        self.title = title
        self.amount = amount
        self.creditCardAmounts = creditCardAmounts
    }
}//: AssetData

enum CreditCardAmounts : Identifiable, Decodable {
    case previousMonth(amount: String)
    case currentMonth(amount: String)
    case nextMonth(amount: String)
    
    var id: Int {
        switch self {
        case .previousMonth:
            return 0
        case .currentMonth:
            return 1
        case .nextMonth:
            return 2
        }
    }
    
    var amount: String {
        switch self {
        case .previousMonth(let amount),
                .currentMonth(let amount),
                .nextMonth(let amount):
            return amount
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case previousMonth
        case currentMonth
        case nextMonth
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        if let value = try? values.decode(String.self, forKey: .previousMonth) {
            self = .previousMonth(amount: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .currentMonth) {
            self = .currentMonth(amount: value)
            return
        }
        
        if let value = try? values.decode(String.self, forKey: .nextMonth) {
            self = .nextMonth(amount: value)
            return
        }
        
        throw fatalError("ERROR: CreditCardAmounts JSON Decoding")
    }
}//: CreditCardAmounts
