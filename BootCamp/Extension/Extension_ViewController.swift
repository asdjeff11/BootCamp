//
//  Extension_ViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

extension UIViewController {
    
    
    func setUpNavigation(title:String,backButtonVisit:Bool = false) {
        self.title = title
        
        let textColor:UIColor = Theme.themeStlye.getTextColor()
        let backColor:UIColor = UIColor(hex:0xAECFCC)
        let fontStyle = UIFont(name:"Helvetica Neue", size:25) ?? UIFont()
        
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithDefaultBackground()
            
            
            navigationBarAppearance.backgroundColor = backColor
            navigationBarAppearance.titleTextAttributes = [
               .foregroundColor: textColor,
               .font: fontStyle
            ]
           
            navigationItem.setHidesBackButton(true, animated: true)
            navigationItem.scrollEdgeAppearance = navigationBarAppearance
            navigationItem.standardAppearance = navigationBarAppearance
            navigationItem.compactAppearance = navigationBarAppearance
            navigationController?.setNeedsStatusBarAppearanceUpdate()
        }
        else {
            self.navigationController?.navigationBar.barTintColor = backColor
            self.navigationController?.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: textColor,
                NSAttributedString.Key.font: fontStyle
            ]
        }
        
        let backButton = UIButton(frame: Theme.navigationBtnSize)
        let img = UIImage.scaleImage(image: UIImage(named: "back")!, newSize: Theme.navigationBtnSize.size)
            .withRenderingMode(.alwaysTemplate)
        backButton.tintColor = textColor
        backButton.setImage(img, for: .normal)
        backButton.addTarget(self, action: #selector(leftButtonAction), for: .touchUpInside)
       
        
        var array:[UIBarButtonItem] = []
        
        if ( backButtonVisit == true ) {
            array.append(UIBarButtonItem(customView: backButton))
        }
       
        self.navigationItem.leftBarButtonItems = array
       
    }
    
    
    @objc func viewWillTerminate() {
        
    }
    
    @objc func leftButtonAction() {
        viewWillTerminate()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loading(isLoading:inout Bool) { // 參數是給有需要的使用 不需要的 無視即可
        if( isLoading ) { return }
        spinner.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.addSubview(spinner.view)
        addChild(spinner)
        spinner.didMove(toParent: self)
        isLoading = true
    }
    
    func removeLoading(isLoading:inout Bool) {
        if ( isLoading == false ) { return }
        spinner.willMove(toParent: nil)
        spinner.view.removeFromSuperview()
        spinner.removeFromParent()
        isLoading = false
    }
    
    func addViewToPresent(viewController: UIViewController) {
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true)
    }
 
    func showAlert(alertText: String, alertMessage: String, dissmiss: Bool = false, alertAction: UIAlertAction? = nil) {
        #if DEBUG
            let mes = alertMessage
        #else
            let mes = (alertText.hasSuffix("錯誤") || alertText == "建立失敗" || alertText == "儲存失敗" ) ? "連線錯誤" : alertMessage
        #endif
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: alertText, message: mes, preferredStyle: UIAlertController.Style.alert)
            if let alertAction = alertAction {
                alert.addAction(alertAction)
            }
            else {
                let closeAction = UIAlertAction(title: "確定", style: .default){ [unowned self] (_) in
                    if ( dissmiss == true ) {
                        self.dismiss(animated: true)
                    }
                }
                alert.addAction(closeAction)
            }
            
            guard let _ = self.viewIfLoaded?.window,self.presentedViewController == nil else { return }
            self.present(alert, animated: true, completion: nil)
//            print("self:\(self)")
//            print("self.presentedVC:\(String(describing: self.presentedViewController))\n")
        }
    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: ({}))
    }

    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier?) {
        if let taskID = taskID {
            UIApplication.shared.endBackgroundTask(taskID)
        }
    }
    
    // 重載整個頁面
    func reloadViewFromNib() {
        NotificationCenter.default.removeObserver(self)
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
}

