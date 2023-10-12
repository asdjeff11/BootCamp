//
//  SpinnerViewController.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

let spinner = SpinnerViewController()
class SpinnerViewController: UIViewController {
    var spinner:UIActivityIndicatorView = {
        if #available(iOS 13.0, *) {
            let spinnerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
            spinnerView.color = .white
            return spinnerView
        }
        else {
            return UIActivityIndicatorView(style: .whiteLarge)
        }
    }()
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating() // 齒輪開始轉動
        
        view.addSubview(spinner)
        NSLayoutConstraint.activate([ // 位子置中
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
}
