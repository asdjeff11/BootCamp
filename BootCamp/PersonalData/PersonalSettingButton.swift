//
//  PersonalSettingButton.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
class PersonalSettingButton:UIView {
    let myTitleLabel:UILabel
    let myContentLabel:UILabel
    let goIcon:UIImageView
    
    init(title:String,content:String) {
        myTitleLabel = UILabel.createLabel(size: 40 * Theme.factor, color: .black,alignment:.right,text:title)
        myContentLabel = UILabel.createLabel(size: 20 * Theme.factor, color: .black,alignment:.right, text:content)
        goIcon = UIImageView()
        goIcon.image = #imageLiteral(resourceName: "goNext.png").withRenderingMode(.alwaysTemplate)
        super.init(frame: .zero)
        
        self.backgroundColor = .clear
        self.layer.borderWidth = 1
        self.layer.borderColor = userData.getSecondColor().cgColor
        layout()
        updateColor()
    }
    
    func layout() {
        self.heightAnchor.constraint(equalToConstant: 60 * Theme.factor).isActive = true
        
        self.addSubviews(myTitleLabel , myContentLabel , goIcon)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            myTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30 * Theme.factor),
            myTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            myTitleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.8),
            myTitleLabel.widthAnchor.constraint(equalToConstant: 200 * Theme.factor),
            
            goIcon.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30 * Theme.factor),
            goIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            goIcon.heightAnchor.constraint(equalTo: myTitleLabel.heightAnchor),
            goIcon.widthAnchor.constraint(equalTo: goIcon.heightAnchor),
            
            myContentLabel.trailingAnchor.constraint(equalTo: goIcon.leadingAnchor, constant: -10 * Theme.factor),
            myContentLabel.centerYAnchor.constraint(equalTo: goIcon.centerYAnchor),
            myContentLabel.heightAnchor.constraint(equalTo: goIcon.heightAnchor),
            myContentLabel.leadingAnchor.constraint(equalTo: myTitleLabel.trailingAnchor, constant: 10 * Theme.factor)
        ])  
    }
    
    func updateContent(content:String) {
        self.myContentLabel.text = content
    }
    
    func updateColor() {
        let secondColor = userData.getSecondColor()
        self.backgroundColor = userData.getMainColor()
        self.layer.borderColor = secondColor.cgColor
        myTitleLabel.textColor = secondColor
        myContentLabel.textColor = secondColor
        goIcon.tintColor = secondColor
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
