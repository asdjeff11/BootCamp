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
        let myView = PersonalSettingButton(title: "主題顏色", content: Theme.themeStlye.getThemeString())
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
        btn.tintColor = Theme.themeStlye.getTextColor()
        
        btn.setTitle("關於Apple iTunes", for: .normal)
        btn.setTitleColor(Theme.themeStlye.getTextColor(), for: .normal)
        
        btn.addTarget(self, action: #selector(goAppleITunes), for: .touchUpInside)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.contents = Theme.themeStlye.getBackColor()
        setUp()
        layout()
    }
    
    override func setThemeColor() {
        super.setThemeColor()
        themeView.updateColor()
        collectItemView.updateColor()
        aboutAppleITuneButton.tintColor = Theme.themeStlye.getTextColor()
        aboutAppleITuneButton.setTitleColor(Theme.themeStlye.getTextColor(), for: .normal)
    }
    
}

extension PersonalDataViewController {
    func setUp() {
        setUpNav(title: "個人資料")
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
    @objc func goAppleITunes() {
        let detailViewController = ITuneDetailViewController()
        detailViewController.url_str = "https://www.apple.com/tw/itunes/"
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
