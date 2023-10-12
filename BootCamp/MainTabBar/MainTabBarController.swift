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
        searchView.tabBarItem.title = nil
        searchView.tabBarItem.image = searchImage
        let searchNavigation = UINavigationController(rootViewController: searchView)
        
        
        let personalDataView = PersonalDataViewController()
        let personalDataImage = UIImage.scaleImage(image:#imageLiteral(resourceName: "user.png") , newSize: iconSize)
        personalDataView.tabBarItem.title = nil
        personalDataView.tabBarItem.image = personalDataImage
        let personalDataNavigation = UINavigationController(rootViewController: personalDataView)
        
        viewControllers = [searchNavigation,personalDataNavigation]
        let customTabBar = UITabBar.appearance()
        if #available(iOS 13.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.backgroundColor = .systemGray5
            customTabBar.standardAppearance = tabBarAppearance
            if #available(iOS 15.0, *) {
                customTabBar.scrollEdgeAppearance = tabBarAppearance
            }
        }
        else {
            tabBar.barTintColor = .systemGray5
        }
    }
}
