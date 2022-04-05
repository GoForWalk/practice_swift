//
//  MainViewController.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/01.
//

import RxSwift
import RxCocoa
import UIKit
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("MainViewController init()")
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ vm: MainViewModel){
        // MARK: MainViewModel -> ViewController
        // 1. cellData
        // 2. presentAlert : ErrorMessage
        // 3. push: category 선택 pop
        
        vm.cellData
            .drive(tableView.rx.items) { tv, row, data in
                switch row { // cell 마다 다른 방식으로 구현
                case 0:
                    let cell = tv.dequeueReusableCell(withIdentifier: "TitleTextInputCell", for: IndexPath(row: row, section: 0)) as! TitleTextFieldCell
                    
                    cell.selectionStyle = .none // 선택했을 때, 회색음영 나타나지 않게 한다.
                    cell.titleInputField.placeholder = data
                    cell.bind(vm.titleTextFieldViewModel)
                    return cell
                    
                case 1:
                    let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                    
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator // 꺽쇠 모양 >
                    return cell
                    
                case 2:
                    let cell = tv.dequeueReusableCell(withIdentifier: "PriceTextFieldCell", for: IndexPath(row: row, section: 0)) as! PriceTextFieldCell
                    
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(vm.priceTextFieldViewModel)
                    return cell
                    
                case 3:
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailWriteFormCell", for: IndexPath(row: row, section: 0)) as! DetailWriteFormCell
                    
                    cell.selectionStyle = .none
                    cell.contentInputView.text = data
                    cell.bind(vm.detailWriteFormCellViewModel)
                    return cell
                    
                default:
                    fatalError()
                    
                }
            }
            .disposed(by: disposeBag)
        
        vm.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: disposeBag)
        
        vm.push
            .drive(onNext: { vm in
                let viewController = CategoryListViewController()
                viewController.bind(vm)
                self.show(viewController, sender: nil)
            })
            .disposed(by: disposeBag)
        
        // MARK: ViewController -> ViewModel
        // 1. itemSelected
        // 2. submitButtonTapped
        tableView.rx.itemSelected
            .map { $0.row } // 선택된 row 전달
            .bind(to: vm.itemSelected)
            .disposed(by: disposeBag)
        
        submitButton.rx.tap
            .bind(to: vm.submitButtonTapped)
            .disposed(by: disposeBag)
        
    }//: bind
    
    private func attribute() {
        // Navigation
        title = "중고거래🥕 글쓰기"
        view.backgroundColor = .white
        
        submitButton.title = "제출"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextInputCell") // index row 0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell") // index row 1
        tableView.register(PriceTextFieldCell.self, forCellReuseIdentifier: "PriceTextFieldCell") // index row 2
        tableView.register(DetailWriteFormCell.self, forCellReuseIdentifier: "DetailWriteFormCell") // index row 3
        
    }//: attribute()
    
    private func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }//: layout()
    
}//: MainViewController

// MARK: Alert
typealias Alert = (title: String, message: String?)

extension Reactive where Base: MainViewController {
    var setAlert: Binder<Alert> {
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertController.addAction(action)
            base.present(alertController, animated: true, completion: nil)
        }
    }
}//: extension Reactive

