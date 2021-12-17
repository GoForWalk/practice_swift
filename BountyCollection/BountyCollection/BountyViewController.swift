//
//  BountyViewController.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/12.
//
import UIKit

class BountyViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
    let viewModel = BountyViewModel()
    
    // sagueWay 수행 준비 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // detailViewController 한테 data 넘김
        // segue identifier 지정
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            // sender -> downCast to Int
            if let index = sender as? Int {
                let bountyInfo = viewModel.bountyInfo(at: index)
                vc?.viewModel.update(model: bountyInfo) // data 전송!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // UICollectionViewDataSource
    // 몇 개를 보여줄까요?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numOfBountyInfoList
    }
    
    // 셀은 어떻게 표현 할까요?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else {
            return UICollectionViewCell()
        }
        let bountyInfo = viewModel.bountyInfo(at: indexPath.item)
        cell.update(info: bountyInfo)
        return cell
    }
    
    // UICollectionViewDelegate
    // cell 이 클릭되었을 때 어떻게 할까요?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("--> \(indexPath.item)")
           // 터치하면 modal창으로 변경
           // sagueWay 수행
           performSegue(withIdentifier: "showDetail", sender: indexPath.item) // cell 에 대한 정보
    }
    
    // UICollectionViewDelegateFlowLayout
    // 필수 구현 요소는 아님
    // device 마다 cell의 사이즈를 기기에 맞게 조정해야한다. -> Balance
    // cell size를 계산한다. (목표: 다양한 디바이스에서 일관적인 디자인을 보여주기 위해서.)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSpacing: CGFloat = 10
        let textAreaHeight: CGFloat = 65

        let width: CGFloat = (collectionView.bounds // collectionView의 크기에 대한 method
                                .width - itemSpacing) / 2 // cell들 간의 공간을 뺀 나머지 공간의 절반에 각 cell의 크기를 분배한다.
        let height: CGFloat = width * 10/7 + textAreaHeight

        return CGSize(width: width, height: height)
    }
    
    
}

// ViewModel
// - bountyViewModel
// > bountyViewModel을 만들고, View layer에서 필요한 메서드 만들기
// > Model 가지고 있기 ,, BountyInfo 등.
class BountyViewModel {
    // model을 가지고 있어야 한다.
    // View & ViewController에서 직접 model로 접근 하지 못하고, ViewModel을 통해서만 Model에 접근이 가능하다.
    let bountyInfoList: [BountyInfo] = [
        BountyInfo(name: "brook", bounty: 33000000),
        BountyInfo(name: "chopper", bounty: 50),
        BountyInfo(name: "franky", bounty: 4440000),
        BountyInfo(name: "luffy", bounty: 30000000),
        BountyInfo(name: "nami", bounty: 16000000),
        BountyInfo(name: "robin", bounty: 80000000),
        BountyInfo(name: "sanji", bounty: 77000000),
        BountyInfo(name: "zoro", bounty: 120000000)
    ]
    
    var sortedList: [BountyInfo] {
        let sortedList = bountyInfoList.sorted { prev, next in
            return prev.bounty > next.bounty
        }
        
        return sortedList
    }
    
    var numOfBountyInfoList: Int {
        return bountyInfoList.count
    }
    
    func bountyInfo(at index: Int) -> BountyInfo{
        return sortedList[index]
    }
}

// Custom Cell
// View 역할 담당
// > GridCell 에 필요한 정보를 ViewModel 한테서 받아야 한다.
// > GridCell은 ViewModel로 부터 받은 정보로 뷰를 업데이트 한다.
class GridCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    func update(info: BountyInfo){
        imgView.image = info.image
        nameLabel.text = info.name
        bountyLabel.text = "\(info.bounty)"
    }
}
