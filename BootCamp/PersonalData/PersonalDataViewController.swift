//
//  PersonalDataViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

class PersonalDataViewController:CustomViewController {
    lazy var themeView:PersonalSettingButton = {
        let myView = PersonalSettingButton(title: "主題顏色", content: userData.getThemeType().rawValue)
        return myView
    }()
    
    lazy var collectItemView:PersonalSettingButton = {
        let myView = PersonalSettingButton(title: "收藏項目", content: "共有 0項收藏")
        return myView
    }()
    
    lazy var aboutAppleITuneButton:UIButton = {
        let image = UIImage.scaleImage(image:#imageLiteral(resourceName: "about.png") , newSize: CGSize(width: 30 * Theme.factor, height: 30 * Theme.factor))
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = userData.getSecondColor()
        
        btn.setTitle("關於Apple iTunes", for: .normal)
        btn.setTitleColor(userData.getSecondColor(), for: .normal)
        
        btn.addTarget(self, action: #selector(goAppleITunes), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        layout()
        setThemeColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectItemView.myContentLabel.text = "共有 \(userData.getTotalCount())項收藏"
    }
    
    override func setThemeColor() {
        super.setThemeColor()
        themeView.updateColor()
        collectItemView.updateColor()
        aboutAppleITuneButton.tintColor = userData.getSecondColor()
        aboutAppleITuneButton.setTitleColor(userData.getSecondColor(), for: .normal)
    }
    
}

extension PersonalDataViewController {
    func setUp() {
        setUpNavigation(title: "個人資料")
        let themeViewGesture = UITapGestureRecognizer(target: self, action:  #selector(themeViewIsClick))
        themeView.addGestureRecognizer(themeViewGesture)
        
        let collectItemGesture = UITapGestureRecognizer(target: self, action:  #selector(collectViewIsClick))
        collectItemView.addGestureRecognizer(collectItemGesture)
    }
    
    func layout() {
        let margins = view.layoutMarginsGuide
        let stackView = UIStackView(arrangedSubviews: [themeView,collectItemView])
        stackView.axis = .vertical
        stackView.spacing = 40 * Theme.factor
        stackView.distribution = .equalSpacing
        
        view.addSubviews(stackView,aboutAppleITuneButton)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 50 * Theme.factor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            aboutAppleITuneButton.topAnchor.constraint(equalTo: stackView.bottomAnchor,constant: 10 * Theme.factor),
            aboutAppleITuneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10 * Theme.factor),
            aboutAppleITuneButton.heightAnchor.constraint(equalToConstant: 60 * Theme.factor),
        ])
    }
}

extension PersonalDataViewController {
    @objc func themeViewIsClick() {
        let changeThemeViewController = ChangeThemeViewController()
        changeThemeViewController.view.backgroundColor = userData.getMainColor()
        navigationController?.pushViewController(changeThemeViewController, animated: true)
    }
    
    @objc func collectViewIsClick() {
        let collectItemViewController = CollectItemViewController()
        collectItemViewController.view.backgroundColor = userData.getMainColor()
        navigationController?.pushViewController(collectItemViewController, animated: true)
    }
    
    @objc func goAppleITunes() {
        let detailViewController = ITuneDetailViewController()
        detailViewController.url_string = "https://www.apple.com/tw/itunes/"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
