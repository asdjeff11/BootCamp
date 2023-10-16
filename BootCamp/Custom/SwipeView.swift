//
//  SwipeView.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation
import UIKit
class SwipeView:UIControl {
    // 字串傳入以 "," 做切割
    // 判斷有幾個按鈕
    var buttons = [UIButton]()
    var selectIndex:Int = 0
    var commaSeperatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    let selectColor:UIColor = .systemGray
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach{ view in
            view.removeFromSuperview()
        }
        
        let detailColor = Theme.themeStlye.getTextColor()
        let buttonsTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        for title in buttonsTitles {
            let button = UIButton.init(type:.system)
            button.layer.borderColor = detailColor.cgColor
            button.layer.borderWidth = 1
            button.titleLabel?.font = Theme.labelFont
            button.backgroundColor = .clear
            button.setTitle(title, for: .normal)
            button.setTitleColor(detailColor, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[0].backgroundColor = selectColor // default 選擇
                
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 0.0
        addSubview(stackView)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    @objc func buttonTapped(_ button:UIButton) {
        
        for (buttonIndex,myButton) in buttons.enumerated() {
            myButton.backgroundColor = .clear
            if ( myButton == button ) {
                selectIndex = buttonIndex
                UIView.animate(withDuration: 0.3, animations: {
                    myButton.backgroundColor = self.selectColor
                })
            }
        }
        sendActions(for:.valueChanged) // 通知外部 內部已修改
    }
    
    
}
