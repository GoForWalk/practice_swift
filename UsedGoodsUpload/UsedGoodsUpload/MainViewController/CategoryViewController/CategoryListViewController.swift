//
//  CategoryDetailView.swift
//  UsedGoodsUpload
//
//  Created by sae hun chung on 2022/04/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class CategoryListViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let tabelView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ vm: CategoryViewModel) {
        vm.cellData
            .drive(tabelView.rx.items) { tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                
                cell.textLabel?.text = data.name
                return cell
            }
            .disposed(by: disposeBag)
        
        vm.pop
            .emit(onNext: { [weak self] _ in
                self?.navigationController?
                    .popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        tabelView.rx.itemSelected
            .map { $0.row }
            .bind(to: vm.itemSelected)
            .disposed(by: disposeBag)
        
    }//: bind()
    
    private func attribute() {
        view.backgroundColor = .systemBackground
        
        tabelView.backgroundColor = .white
        tabelView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tabelView.separatorStyle = .singleLine
        tabelView.tableFooterView = UIView()
    }//: attribute()
    
    private func layout() {
        view.addSubview(tabelView)
        
        tabelView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            
        }
    }//: layout()
    
}
