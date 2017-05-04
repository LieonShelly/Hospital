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
import RxDataSources

class NewsHomeVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    fileprivate var newsVM: NewsHomeVM = NewsHomeVM()
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Double>>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

extension NewsHomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsVM.examples.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

