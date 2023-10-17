//
//  CollectItemViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation
import UIKit
class CollectItemViewController:CustomViewController {
    let tableView = UITableView()
    lazy private var swipeView: SwipeView = {
        let swipeView = SwipeView(frame: CGRect(x: 0, y: 0, width: 500 * Theme.factor, height: 80 * Theme.factor))
        swipeView.commaSeperatedButtonTitles = "電影,音樂"
        swipeView.backgroundColor = .clear
        swipeView.addTarget(self, action: #selector(swipeChange), for: .valueChanged) // 點擊 則刷新tableview
        return swipeView
    }()
    
    let viewModel = CollectItemViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getData()
        tableView.reloadData()
    }
    
    @objc func swipeChange() {
        viewModel.updateType(type: (swipeView.selectIndex == 0) ? .電影 : .音樂)
        tableView.reloadData()
    }
}

// 設定與佈局
extension CollectItemViewController {
    func setUp() {
        setUpNavigation(title: "收藏項目", backButtonVisit: true)
        let secondColor = userData.getSecondColor()
       
        tableView.backgroundColor = .clear
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = secondColor.cgColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CollectItemCell.self, forCellReuseIdentifier: "CollectItemCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubviews(swipeView,tableView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            swipeView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            swipeView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 70 * Theme.factor),
            swipeView.widthAnchor.constraint(equalToConstant: 500 * Theme.factor),
            
            tableView.topAnchor.constraint(equalTo: swipeView.bottomAnchor, constant: 10 * Theme.factor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -30 * Theme.factor)
        ])
    }
}

extension CollectItemViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getItemSize()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 * Theme.factor
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectItemCell") as? CollectItemCell,
              let data = viewModel.getData(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setData(data: data)
        cell.setThemeColor()
        cell.removeCollectButton.addTarget(self, action: #selector(removeCollectClick(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.getData(indexPath: indexPath),
              let url = URL(string:item.trackViewURL)
        else { return }
    
        UIApplication.shared.open(url)
    }
    
    @objc func removeCollectClick(_ sender:UIButton) {
        guard let cell = sender.superview?.superview as? CollectItemCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.removeData(indexPath:indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

