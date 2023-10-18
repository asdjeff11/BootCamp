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
    let tableView = UITableView(frame: .zero,style: .grouped)
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
        tableView.layer.borderColor = userData.getSecondColor().cgColor
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "blank")
        
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
        tableView.backgroundColor = userData.getMainColor()
        tableView.layer.borderColor = userData.getSecondColor().cgColor
        tableView.reloadData()
    }
    
}

extension SearchViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return MediaType.allCases.count // movie and music
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0 ? viewModel.getMovieSize() : viewModel.getMusicSize()) * 2 // * 2 is space
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ( indexPath.row % 2 == 0 ) { // space
            return 10 * Theme.factor
        }
        else {
            return UITableView.automaticDimension
        }
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
        if ( indexPath.row % 2 == 0 ) { // 間隔
            let spaceCell = UITableViewCell(style: .default, reuseIdentifier: "blank")
            spaceCell.backgroundColor = UIColor.clear
            spaceCell.isUserInteractionEnabled = false
            return spaceCell
        }
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell,
              let item = viewModel.getData(type: ( indexPath.section == 0 ) ? .電影 : .音樂 , row: indexPath.row / 2)
        else { return UITableViewCell() }
        
        cell.IsMovie = ( indexPath.section == MediaType.電影.rawValue )
        cell.setData(searchModel: item)
        cell.readMoreButton.addTarget(self, action: #selector(readMoreClick(_:)), for: .touchUpInside)
        cell.collectButton.addTarget(self, action: #selector(collectClick(_:)), for: .touchUpInside)
        cell.setThemeColor()
        
        // update image
        cell.cellImageView.sd_setImage( with: URL(string: item.ITuneData.imageURL),
                                        placeholderImage: #imageLiteral(resourceName: "about.png"),
                                        options: [.allowInvalidSSLCertificates,.retryFailed,.continueInBackground])
         { [weak self] (image,error,cache,url) in
             guard let self = self else { return }
             if error != nil && self.tableView.visibleCells.contains(cell) { // 當前顯示的重撈就好  未來如果有需要 會再次呼叫到 cellForRowAt 撈取
                 self.tableView.reloadRows(at: [indexPath], with: .none)
             }
         }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = viewModel.getData(type: ( indexPath.section == 0 ) ? .電影:.音樂, row: indexPath.row / 2),
              let url = URL(string:item.ITuneData.trackViewURL)
        else { return }
    
        UIApplication.shared.open(url)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func readMoreClick(_ sender:UIButton ) {
        guard let cell = sender.superview?.superview as? SearchCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.setFolder(type: ( indexPath.section == 0 ) ? .電影:.音樂, row: indexPath.row / 2)
            tableView.scrollToRow(at: indexPath, at: .none, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func collectClick(_ sender:UIButton) {
        guard let cell = sender.superview?.superview as? SearchCell else { return }
        if let indexPath = tableView.indexPath(for: cell) {
            viewModel.setCollect(type: ( indexPath.section == 0 ) ? .電影:.音樂, row: indexPath.row / 2)
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
        
        if ( input == viewModel.getLastKeyword() ) { return } // 與上次相同關鍵字
        
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
