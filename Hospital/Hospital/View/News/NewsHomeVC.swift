//
//  NewsHomeVC.swift
//  Hospital
//
//  Created by lieon on 2017/4/17.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import ObjectMapper
import PromiseKit
import RxSwift
import RxCocoa

class NewsHomeVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var newsVM: NewsHomeVM = NewsHomeVM()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension NewsHomeVC {
    fileprivate func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let numberExample = Example()
        numberExample.name = "Numbers"
        let items = newsVM.loadExamples(vc: self)
        items
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.name ?? ""
            }
            .disposed(by: disposeBag)
        
        tableView.rx
            .modelSelected(Example.self)
            .subscribe(onNext:  { value in
                value.handler?()
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell.subscribe(onNext: { (cell, indexpath) in
            print(indexpath)
        }).disposed(by: disposeBag)
        
    }
}

