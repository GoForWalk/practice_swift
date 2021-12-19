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
        // 해당 Label 위치 이동
        nameLabel.transform = CGAffineTransform(translationX: view.bounds.width, // X 축 이동
                                                y: 0 // Y 이동
        ).scaledBy(
            x: 3, y: 3
        ).rotated(by: 180)
        bountyLabel.transform = CGAffineTransform(translationX: view.bounds.width, y: 0).scaledBy(x: 3, y: 3).rotated(by: 180)
    
        // alpha setting (투명도)
        nameLabel.alpha = 0
        bountyLabel.alpha = 0
    }
    
    private func showAnimation() {
        // Animation 부여
        UIView.animate(withDuration: 1,
                               delay: 0,
                               usingSpringWithDamping: 0.6, // 스프링 반동 애니메이션 추가 가능.
                               initialSpringVelocity: 2,
                               options: .allowAnimatedContent,
                               animations: {
                                    self.nameLabel.transform = CGAffineTransform.identity
                                    self.nameLabel.alpha = 1
                                },
                               completion: nil
                )
        
        UIView.animate(withDuration: 1,
                               delay: 0.1,
                               usingSpringWithDamping: 0.6, // 스프링 반동 애니메이션 추가 가능.
                               initialSpringVelocity: 2,
                               options: .allowAnimatedContent,
                               animations: {
                                    self.bountyLabel.transform = CGAffineTransform.identity
                                    self.bountyLabel.alpha = 1
                                },
                               completion: nil
                )
        
        // StoryBoard에서 설정 해 놓은 값
        nameLabel.transform = CGAffineTransform.identity
        bountyLabel.transform = CGAffineTransform.identity
        
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
