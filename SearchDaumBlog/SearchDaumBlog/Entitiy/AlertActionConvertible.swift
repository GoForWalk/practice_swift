//
//  AlertActionConvertible.swift
//  SearchDaumBlog
//
//  Created by sae hun chung on 2022/03/29.
//

import UIKit

protocol AlertActionConvertible {
    var title: String { get }
    var style: UIAlertAction.Style { get }
    
}
