//
//  BountyInfo.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/14.
//

import UIKit

// Model
// - BountyInfo
// > BountyInfo 만들자.
struct BountyInfo {
    let name: String
    let bounty: Int
    
    var image: UIImage? {
        return UIImage(named: "\(name).jpg")
    }
    
    init(name: String, bounty: Int) {
        self.name = name
        self.bounty = bounty
    }
}
