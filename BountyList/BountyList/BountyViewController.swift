//
//  BountyViewController.swift
//  BountyList
//
//  Created by sae hun chung on 2021/12/12.
//
import UIKit

class BountyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let nameList = ["brook", "chopper", "franky", "luffy", "nami", "robin", "sanji", "zoro"]
    let bountyList = [33000000, 50, 4440000, 30000000, 16000000, 80000000, 77000000, 12000000]
    
    // sagueWay 수행 준비 함수
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // detailViewController 한테 data 넘김
        // segue identifier 지정
        if segue.identifier == "showDetail" {
            let vc = segue.destination as? DetailViewController
            
            // sender -> downCast to Int
            if let index = sender as? Int {
                vc?.name = nameList[index]
                vc?.bounty = bountyList[index]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // UITableViewDataSource
    // 테이블 뷰 셀 몇개 출력할 것인지?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bountyList.count
    }
    
    // 테이블 뷰 어떻게 보여줄 것인지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // reusableCell
        // if let으로 변경 가능
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let img = UIImage(named: "\(nameList[indexPath.row]).jpg")
        cell.imgView.image = img
        cell.nameLabel.text = nameList[indexPath.row]
        cell.bountyLabel.text = "\(bountyList[indexPath.row])"
        return cell
        
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
class ListCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bountyLabel: UILabel!
}
