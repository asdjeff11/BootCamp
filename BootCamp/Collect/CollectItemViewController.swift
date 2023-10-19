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
        let typeTitle = String(MediaType.allCases.reduce("", { "\($0)\($1.getChineseString())," })
                                                 .dropLast()
                              )
        swipeView.commaSeperatedButtonTitles = typeTitle
        swipeView.addTarget(self, action: #selector(swipeChange), for: .valueChanged) // 點擊 則刷新tableview
        return swipeView
    }()
    
    let presenter = CollectItemPresenter()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.update()
        swipeView.updateThemeStyle()
        tableView.reloadData()
    }
    
    @objc func swipeChange() {
        let type = MediaType(rawValue: swipeView.selectIndex) ?? .電影
        presenter.update(type: type)
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
        presenter.getItemSize()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200 * Theme.factor
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectItemCell") as? CollectItemCell,
              let data = presenter.getData(indexPath: indexPath) else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.setData(data: data)
        cell.setThemeColor()
        cell.removeCollectButton.addTarget(self, action: #selector(removeCollectClick(_:)), for: .touchUpInside)
        
        // update image
        cell.cellImageView.sd_setImage(with: URL(string: data.imageURL),
                                       placeholderImage: #imageLiteral(resourceName: "about.png"),
                                       options: [.allowInvalidSSLCertificates,.retryFailed,.continueInBackground])
        { [weak self] (image,error,cache,url) in
            guard let self = self else { return }
            // 撈失敗 -1001 且 是當前顯示的cell
            if let error = error,
               error._code == -1001,
               self.tableView.visibleCells.contains(cell) {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = presenter.getData(indexPath: indexPath),
              let url = URL(string:item.trackViewURL)
        else { return }
    
        UIApplication.shared.open(url)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 ,
            animations: {
                cell.alpha = 1
        })
    }
    
    @objc func removeCollectClick(_ sender:UIButton) {
        guard let cell = sender.superview?.superview as? CollectItemCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            presenter.removeData(indexPath:indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

