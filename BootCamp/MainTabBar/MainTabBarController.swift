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
    
    func initTabBar() {
        let iconSize = CGSize(width: 50 * Theme.factor, height: 50 * Theme.factor)
        let searchView = SearchViewController()
        let searchImage = UIImage.scaleImage(image: #imageLiteral(resourceName: "search.png"), newSize: iconSize)
        searchView.tabBarItem.image = searchImage
        let searchNavigation = UINavigationController(rootViewController: searchView)
        
        
        let personalDataView = PersonalDataViewController()
        let personalDataImage = UIImage.scaleImage(image:#imageLiteral(resourceName: "user.png") , newSize: iconSize)
        personalDataView.tabBarItem.image = personalDataImage
        let personalDataNavigation = UINavigationController(rootViewController: personalDataView)
        
        viewControllers = [searchNavigation,personalDataNavigation]
        
        setTabBarStyle()
    }
    
    private func setTabBarStyle() {
        let customTabBar = UITabBar.appearance()
        // set backGround
        let backGroundColor:UIColor = .systemGray5
        let iconColor:UIColor = .gray
        
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()

            appearance.backgroundColor = backGroundColor
            appearance.stackedLayoutAppearance.normal.iconColor = iconColor
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: iconColor]

            customTabBar.standardAppearance = appearance
            customTabBar.scrollEdgeAppearance = appearance
        }
        else {
            customTabBar.backgroundColor = backGroundColor
            customTabBar.unselectedItemTintColor = iconColor
        }
        
        // set selectBackGround
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        let selectBackground = UIColor.white.withAlphaComponent(0.8).image(tabBarItemSize)
        tabBar.selectionIndicatorImage = selectBackground
        
        tabBar.tintColor = .gray
    }
}
