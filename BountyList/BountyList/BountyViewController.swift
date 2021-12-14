//
//  BountyViewController.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/12.
//
import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MVVM
    
    // Model
    // - BountyInfo
    // > BountyInfo 만들자.
    
    // View
    // - ListCell
    // > ListCell 에 필요한 정보를 ViewModel 한테서 받아야 한다.
    // > ListCell은 ViewModel로 부터 받은 정보로 뷰를 업데이트 한다.
    
    // ViewModel
    // - bountyViewModel
    // > bountyViewModel을 만들고, View layer에서 필요한 메서드 만들기
    // > Model 가지고 있기 ,, BountyInfo 등.
    
    
    // 데이터 추가에 어려움 -> Struct로 교체
//    let nameList = ["brook", "chopper", "franky", "luffy", "nami", "robin", "sanji", "zoro"]
//    let bountyList = [33000000, 50, 4440000, 30000000, 16000000, 80000000, 77000000, 12000000]
    
//    let bountyInfoList: [BountyInfo] = [
//        BountyInfo(name: "brook", bounty: 33000000),
//        BountyInfo(name: "chopper", bounty: 50),
//        BountyInfo(name: "franky", bounty: 4440000),
//        BountyInfo(name: "luffy", bounty: 30000000),
//        BountyInfo(name: "nami", bounty: 16000000),
//        BountyInfo(name: "robin", bounty: 80000000),
//        BountyInfo(name: "sanji", bounty: 77000000),
//        BountyInfo(name: "zoro", bounty: 120000000)
//    ]
    
    let viewModel = BountyViewModel()
    
    // sagueWay 수행 준비 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // detailViewController 한테 data 넘김
        // segue identifier 지정
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            // sender -> downCast to Int
            if let index = sender as? Int {
//                vc?.name = nameList[index]
//                vc?.bounty = bountyList[index]
                
//                let bountyInfo = bountyInfoList[index]
                let bountyInfo = viewModel.bountyInfo(at: index)
                
//                vc?.name = bountyInfo.name
//                vc?.bounty = bountyInfo.bounty
                
//                vc?.bountyInfo = bountyInfo
                
                vc?.viewModel.update(model: bountyInfo) // data 전송!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // UITableViewDataSource
    // 테이블 뷰 셀 몇개 출력할 것인지?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return bountyList.count
//        return bountyInfoList.count
        return viewModel.numOfBountyInfoList
    }
    
    // ViewController
    // 테이블 뷰 어떻게 보여줄 것인지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reusableCell
        // if let으로 변경 가능
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
//        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
//        cell.imgView.image = img
//        cell.nameLabel.text = nameList[indexPath.row]
//        cell.bountyLabel.text = "\(bountyList[indexPath.row])"
        
//        let bountyInfo = bountyInfoList[indexPath.row]
        
        // view를 표현하는 code로 ViewController -> View(ListCell)로 이동.
        let bountyInfo = viewModel.bountyInfo(at: indexPath.row)
//        let img = bountyInfo.image
//        cell.imgView.image = img
//        cell.nameLabel.text = bountyInfo.name
//        cell.bountyLabel.text = "\(bountyInfo.bounty)"
        cell.update(info: bountyInfo)
        return cell
        
//        if let 예시 코드
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell {
//            let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
//            cell.imgView.image = img
//            cell.nameLabel.text = nameList[indexPath.row]
//            cell.bountyLabel.text = "\(bountyList[indexPath.row])"
//            return cell
//        } else {
//            return UITableViewCell()
//        }
        
    }
    
    // UITableViewDelegate
    // 터치 후 반응
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("--> \(indexPath.row)")
        // 터치하면 modal창으로 변경
        // sagueWay 수행
        performSegue(withIdentifier: "showDetail", sender: indexPath.row) // cell 에 대한 정보
    }
}

// Custom Cell
// View 역할 담당
// > ListCell 에 필요한 정보를 ViewModel 한테서 받아야 한다.
// > ListCell은 ViewModel로 부터 받은 정보로 뷰를 업데이트 한다.
class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
    
    func update(info: BountyInfo){
        imgView.image = info.image
        nameLabel.text = info.name
        bountyLabel.text = "\(info.bounty)"
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
    
    var numOfBountyInfoList: Int {
        return bountyInfoList.count
    }
    
    func bountyInfo(at index: Int) -> BountyInfo{
        return bountyInfoList[index]
    }
}
