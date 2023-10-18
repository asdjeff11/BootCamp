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
    let selectBGView = UIView()
    var commaSeperatedButtonTitles: String = "" {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        selectBGView.backgroundColor = .systemGray5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateView() {
        buttons.removeAll()
        subviews.forEach{ view in
            view.removeFromSuperview()
        }
        
        let buttonsTitles = commaSeperatedButtonTitles.components(separatedBy: ",")
        for title in buttonsTitles {
            let button = UIButton.init(type:.system)
            button.layer.borderWidth = 1
            button.titleLabel?.font = Theme.labelFont
            button.backgroundColor = .clear
            button.setTitle(title, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        self.addSubview(selectBGView)
        
        let stackView = UIStackView.init(arrangedSubviews: buttons)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            selectBGView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            selectBGView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            selectBGView.heightAnchor.constraint(equalTo:self.heightAnchor ),
            selectBGView.widthAnchor.constraint(equalToConstant:self.frame.width / CGFloat(buttonsTitles.count)),
            
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.rightAnchor)
        ])
    }
    
    func updateThemeStyle() {
        let mainColor = userData.getMainColor()
        let secondColor = userData.getSecondColor()
        for button in buttons {
            button.layer.borderColor = secondColor.cgColor
            button.setTitleColor(secondColor, for: .normal)
        }
        
        backgroundColor = mainColor
    }
    
    @objc func buttonTapped(_ button:UIButton) {
        
        for (buttonIndex,myButton) in buttons.enumerated() {
            myButton.backgroundColor = .clear
            if ( myButton == button ) {
                selectIndex = buttonIndex
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.selectBGView.center = myButton.center
                })
            }
        }
        sendActions(for:.valueChanged) // 通知外部 內部已修改
    }
}
