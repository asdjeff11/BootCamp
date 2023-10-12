//
//  CustomViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

class CustomViewController:UIViewController {
    
    // 修改主題色
    func setThemeColor() {
        var backButtonVisit = false
        if let leftItems = navigationController?.navigationItem.leftBarButtonItems ,
           !leftItems.isEmpty {
            backButtonVisit = true
        }
        setUpNav(title: title ?? "" ,backButtonVisit: backButtonVisit)
        
        self.view.layer.contents = Theme.themeStlye.getBackColor() // 背景色
        // for override 各頁面去修改需要的顏色設定
    }
    
}
