//
//  DetailViewController.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MVVM
    
    // Model
    // - BountyInfo
    // > BountyInfo 만들자.
    
    // View
    // - imgView, nameLabel, bountyLabel
    // > View들은 ViewModel를 통해서 구성되기 (정보를 ViewModel 에서 받는다.)
    
    // ViewModel
    // - detailViewModel
    // > 뷰 레이어에서 필요한 메서드 만들기
    // > Model 가지고 있기 ,, BountyInfo 등.
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!

    // Model
//    var name: String?
//    var bounty: Int?
//    var bountyInfo: BountyInfo?
    
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() { // 메모리 올라옴
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        // ViewModel을 통해서 Model data 가져오기.
        if let bountyInfo = viewModel.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = "\(bountyInfo.bounty)"
        }
        
//        if let bountyInfo = self.bountyInfo {
//            imgView.image = bountyInfo.image
//            nameLabel.text = bountyInfo.name
//            bountyLabel.text = "\(bountyInfo.bounty)"
//        }
        
//        if let name = self.bountyInfo?.name, let bounty = self.bountyInfo?.bounty {
//            let img = UIImage(named: "\(name).jpg")
//            imgView.image = bountyInfo?.image
//            nameLabel.text = name
//            bountyLabel.text = "\(bounty)"
//        }
    }
    
    
    // Button을 눌렀을 때,
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

// ViewModel
// - detailViewModel
// > 뷰 레이어에서 필요한 메서드 만들기
// > Model 가지고 있기 , BountyInfo 등.
class DetailViewModel {
    var bountyInfo: BountyInfo?
    
    // sague를 통해서 data를 받는 기능
    func update(model: BountyInfo?) {
        bountyInfo = model
    }
    
}
