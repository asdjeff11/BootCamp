//
//  SearchBar.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

protocol SearchBarDelegate:AnyObject {
    func searchAction(_ input:String)
}
class SearchBar:UIView {
    weak var delegate:SearchBarDelegate?
    private var textField:MyTextField
    private var button:UIButton
    
    init() {
        textField = MyTextField()
        textField.backgroundColor = .clear
        button = UIButton()
        super.init(frame: .zero)
        button.addTarget(self, action: #selector(clickAct), for: .touchUpInside)
        updateTheme()
        layout()
    }
    
    func layout() {
        self.addSubviews(textField,button)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textField.heightAnchor.constraint(equalTo: self.heightAnchor),
            textField.trailingAnchor.constraint(equalTo: button.leadingAnchor,constant: -10 * Theme.factor),
            
            button.heightAnchor.constraint(equalToConstant: 70 * Theme.factor),
            button.widthAnchor.constraint(equalToConstant: 70 * Theme.factor),
            button.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func updateTheme() {
        let secondColor = userData.getSecondColor()
        let placeHolderColor = secondColor.withAlphaComponent(0.3)
        // set textField
        textField.layer.borderColor = secondColor.cgColor
        textField.layer.borderWidth = 1
        textField.textColor = secondColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "搜尋",
            attributes: [NSAttributedString.Key.foregroundColor: placeHolderColor]
        )

        
        let img = UIImage.scaleImage(image: #imageLiteral(resourceName: "search.png"), newSize: CGSize(width: 70 * Theme.factor, height: 70 * Theme.factor))
        let buttonImg = img.withRenderingMode(.alwaysTemplate)
        button.setImage(buttonImg, for: .normal)
        button.tintColor = secondColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickAct() {
        let keyword = textField.text ?? ""
        delegate?.searchAction(keyword)
    }
    
    
}
