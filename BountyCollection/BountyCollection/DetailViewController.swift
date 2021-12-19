//
//  DetailViewController.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/12.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    @IBOutlet weak var nameLabelCenterX: NSLayoutConstraint!
    @IBOutlet weak var bountyLabelCenterX: NSLayoutConstraint!

    // Model
    let viewModel = DetailViewModel()
    
    override func viewDidLoad() { // 메모리 올라옴
        super.viewDidLoad()
        updateUI()
        prepareAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) { // 화면이 구동하는 메서드
        super.viewDidAppear(animated)
        // Label을 이동시킬 애니메이션
        showAnimation()
    }
    
    private func prepareAnimation() {
        // nameLabel의 초기 X 좌표를 view 밖으로 내보낸뒤 안으로 들어오는 애니메이션 생성.
        nameLabelCenterX.constant = view.bounds.width
        bountyLabelCenterX.constant = view.bounds.width
    }
    
    private func showAnimation() {
        nameLabelCenterX.constant = 0
        bountyLabelCenterX.constant = 0

//        // animation 간단 옵션.
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
        
        // animation 풀 옵션
//        UIView.animate(withDuration: 0.3, // 애니매이션의 진행 시간.
//                       delay: 0.1, // 애니메이션의 시간 딜레이
//                       options: .curveEaseIn, // Easing 에 대한 옵션
//                       animations: {
//            self.view.layoutIfNeeded()
//        },
//                       completion: nil // 애니메이션이 끝나고 난 이후 작업에 대해서
//        )
        
        // Easing 값의 속성을 custom할 수 있는 method
        UIView.animate(withDuration: 0.5,
                       delay: 0.2,
                       usingSpringWithDamping: 0.6, // 스프링 반동 애니메이션 추가 가능.
                       initialSpringVelocity: 2,
                       options: .allowAnimatedContent,
                       animations: {
                            self.view.layoutIfNeeded()
                        },
                       completion: nil
        )
        
        // img 회전하는 animation
        UIView.transition(with: imgView, duration: 0.3,
                          options: .transitionFlipFromLeft,
                          animations: nil, completion: nil)
        
    }
    
    func updateUI() {
        // ViewModel을 통해서 Model data 가져오기.
        if let bountyInfo = viewModel.bountyInfo {
            imgView.image = bountyInfo.image
            nameLabel.text = bountyInfo.name
            bountyLabel.text = "\(bountyInfo.bounty)"
        }
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
