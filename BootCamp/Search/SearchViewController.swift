//
//  SearchView.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

class SearchViewController:CustomViewController {
    let searchBar = SearchBar()
    let tableView = UITableView()
    let viewModel = SearchViewModel()
    var isLoading = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.refreshCollect()
        tableView.reloadData() // 確保追蹤的資訊是正常的
    }
    
    
    func setUp() {
        setUpNavigation(title: "ITune")
        searchBar.delegate = self
        
        tableView.backgroundColor = .clear
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = Theme.themeStlye.getTextColor().cgColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
        setThemeColor()
        
        let tapG = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapG.cancelsTouchesInView = false // 防止其他元件的點擊事件失效
        view.addGestureRecognizer(tapG)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func layout() {
        view.addSubviews(searchBar,tableView)
     
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.widthAnchor.constraint(equalTo: view.widthAnchor , multiplier: 0.98),
            searchBar.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20 * Theme.factor),
            searchBar.heightAnchor.constraint(equalToConstant: 70 * Theme.factor),
        
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor,constant: 10 * Theme.factor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -10 * Theme.factor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.98)
        ])
    }
    
    override func setThemeColor() {
        super.setThemeColor()
        searchBar.updateTheme()
        tableView.layer.borderColor = Theme.themeStlye.getTextColor().cgColor
        tableView.reloadData()
    }
    
}

extension SearchViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // movie and music
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? viewModel.getMovieSize() : viewModel.getMusicSize()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50 * Theme.factor
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        let title = ( section == MediaType.電影.rawValue ) ? "電影" : "音樂"
        let titleLabel = UILabel.createLabel(size: 40 * Theme.factor, color: .black, text: title)
        headerView.addSubview(titleLabel)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor , constant: 10 * Theme.factor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalTo: headerView.heightAnchor),
            titleLabel.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 0.98)
        ])
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell,
              let item = viewModel.getData(indexPath: indexPath)
        else { return UITableViewCell() }
        
        cell.IsMovie = ( indexPath.section == MediaType.電影.rawValue )
        cell.setData(searchModel: item)
        cell.readMoreButton.addTarget(self, action: #selector(readMoreClick(_:)), for: .touchUpInside)
        cell.collectButton.addTarget(self, action: #selector(collectClick(_:)), for: .touchUpInside)
        cell.setThemeColor()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.getData(indexPath: indexPath) else { return }
        let url = item.ITuneData.trackViewURL
        let viewController = ITuneDetailViewController()
        viewController.url_string = url
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func readMoreClick(_ sender:UIButton ) {
        guard let cell = sender.superview?.superview as? SearchCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.setFolder(indexPath: indexPath)
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func collectClick(_ sender:UIButton) {
        guard let cell = sender.superview?.superview as? SearchCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.setCollect(indexPath: indexPath)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

extension SearchViewController:SearchBarDelegate {
    func searchAction(_ input: String) {
        if ( input == "" ) {
            showAlert(alertText: "提醒", alertMessage: "請輸入搜尋條件")
            return
        }
        
        for cell in tableView.visibleCells {
            if let cell = cell as? SearchCell {
                cell.cellImageView.sd_cancelCurrentImageLoad()
            }
        }
        
        let taskID = beginBackgroundUpdateTask()
        loading(isLoading: &isLoading)
        tableView.setContentOffset(.zero, animated: false)
        
        viewModel.fetch(input,callBack:{ [weak self](errorMsg) in
            guard let self = self else { return }
            if ( errorMsg != "" ) {
                self.showAlert(alertText: "撈取資料錯誤", alertMessage: errorMsg)
            }
            self.tableView.reloadData()
            self.endBackgroundUpdateTask(taskID: taskID)
            self.removeLoading(isLoading: &self.isLoading)
        })
        print("search input:\(input)")
    }
}
