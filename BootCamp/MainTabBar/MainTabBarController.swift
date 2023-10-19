//
//  MainTabBarViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import UIKit
class MainTabBarViewController:UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initTabBar()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // set selectBackGround
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        let selectBackground = UIColor.white.withAlphaComponent(0.8).image(tabBarItemSize)
        tabBar.selectionIndicatorImage = selectBackground
        
        tabBar.itemPositioning = .centered
    }
    
    func initTabBar() {
        let iconSize = CGSize(width: 50 * Theme.factor, height: 50 * Theme.factor)
        //搜尋頁面
        let searchView = SearchViewController()
        let searchImage = UIImage.scaleImage(image: #imageLiteral(resourceName: "search.png"), newSize: iconSize)
        searchView.tabBarItem.image = searchImage
        let searchNavigation = UINavigationController(rootViewController: searchView)
        
        // 個人資料設定頁面
        let personalDataView = PersonalDataViewController()
        let personalDataImage = UIImage.scaleImage(image:#imageLiteral(resourceName: "user.png") , newSize: iconSize)
        personalDataView.tabBarItem.image = personalDataImage
        let personalDataNavigation = UINavigationController(rootViewController: personalDataView)
         
        
        viewControllers = [searchNavigation,personalDataNavigation]
        setTabBarStyle()
    }
    
    private func setTabBarStyle() {
        // 修改 tabBar 風格
        let customTabBar = UITabBar.appearance()
        // set backGround
        let backGroundColor:UIColor = .systemGray5
        let iconColor:UIColor = .gray
        
        if #available(iOS 14.0, *) {
            let appearance = UITabBarAppearance()

            appearance.backgroundColor = backGroundColor
            customTabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                customTabBar.scrollEdgeAppearance = appearance
            }
        }
        else {
            customTabBar.backgroundColor = backGroundColor
            customTabBar.unselectedItemTintColor = iconColor
        }
        
        // icon color
        tabBar.tintColor = iconColor
    }
}
