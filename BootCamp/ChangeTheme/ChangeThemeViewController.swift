//
//  ChangeThemeViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/13.
//

import Foundation
import UIKit
class ChangeThemeViewController:CustomViewController {
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
    }
    
    private func setUp() {
        self.setUpNavigation(title: "主題顏色",backButtonVisit: true)
        
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(ChangeThemeCell.self, forCellReuseIdentifier: "ChangeThemeCell")
        tableView.allowsMultipleSelection = false
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func layout() {
        let margins = view.layoutMarginsGuide
        view.addSubview(tableView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            tableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 40 * Theme.factor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setThemeColor() {
        UIView.animate(withDuration: 0.3, animations: {
            super.setThemeColor()
            self.tableView.reloadData()
        })
    }
}

extension ChangeThemeViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Theme.ThemeStyle.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100 * Theme.factor
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChangeThemeCell") as? ChangeThemeCell else {
            return UITableViewCell()
        }
        let style = Theme.ThemeStyle.allCases[indexPath.row]
        cell.titleLabel.text = style.rawValue
        cell.selectionStyle = .none
        cell.setThemeStyle()
        if ( userData.getThemeType() == style ) {
            cell.selectLogo.isHidden = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChangeThemeCell else {
            return
        }
        if  let text = cell.titleLabel.text,
            let style = Theme.ThemeStyle(rawValue: text) {
            userData.updateThemeType(type: style)
            cell.selectLogo.isHidden = false
            allThemeUpdate()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ChangeThemeCell {
            if ( cell.selectLogo.isHidden == false ) {
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ChangeThemeCell else {
            return
        }
        cell.selectLogo.isHidden = true
    }
    
}

extension ChangeThemeViewController {
    func allThemeUpdate() {
        guard let navigationControllers = tabBarController?.viewControllers else { return }
        for viewControllers in navigationControllers {
            for vc in viewControllers.children {
                if let vc = vc as? CustomViewController {
                    vc.setThemeColor()
                }
            }
        }
    }
}
