//
//  ChangeThemeCell.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/13.
//

import Foundation
import UIKit
class ChangeThemeCell:UITableViewCell {
    let titleLabel = UILabel.createLabel(size: 40 * Theme.factor, color: .black)
    var selectLogo:UIImageView = UIImageView()
    var myStyle:Theme.ThemeStyle!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        selectLogo.image = #imageLiteral(resourceName: "select.png").withRenderingMode(.alwaysTemplate)
        selectLogo.tintColor = Theme.themeStlye.getTextColor()
        selectLogo.isHidden = true
        self.layer.borderWidth = 1
        self.backgroundColor = .clear
        
        contentView.addSubviews(titleLabel,selectLogo)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant:10 * Theme.factor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: selectLogo.leadingAnchor, constant:10 * Theme.factor),
            
            selectLogo.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10 * Theme.factor),
            selectLogo.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            selectLogo.heightAnchor.constraint(equalToConstant: 40 * Theme.factor),
            selectLogo.widthAnchor.constraint(equalToConstant: 40 * Theme.factor)
        ])
    }
    
    func setThemeStyle() {
        let textColor = Theme.themeStlye.getTextColor()
        selectLogo.tintColor = textColor
        self.layer.borderColor = textColor.cgColor
        titleLabel.textColor = textColor
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
