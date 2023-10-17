//
//  SearchCell.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
import SDWebImage
class SearchCell:UITableViewCell {
    var IsMovie:Bool = true {
        didSet {
            scriptionLabel.isHidden = !IsMovie
            readMoreButton.isHidden = !IsMovie
        }
    }
    
    var isCollect:Bool = false {
        didSet {
            collectButtonWidth.constant = ((isCollect) ? 180 : 100) * Theme.factor
            collectButton.setTitle((isCollect) ? "取消追蹤" : "追蹤", for: .normal)
        }
    }
    
    private let collectButtonWidth:NSLayoutConstraint
    let cellImageView:UIImageView
    let trackLabel:UILabel
    let artistLabel:UILabel
    let collectionLabel:UILabel
    let longLabel:UILabel
    let scriptionLabel:UILabel
    
    let myView:UIView
    
    let readMoreButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .clear
        btn.setTitle("...read more", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        return btn
    }()
    let collectButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hex: 0x5F58E1)
        btn.layer.cornerRadius = 5
        btn.setTitle("收藏", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cellImageView = UIImageView()
        trackLabel = UILabel.createLabel(size: 30 * Theme.factor)
        artistLabel = UILabel.createLabel(size: 20 * Theme.factor)
        collectionLabel = UILabel.createLabel(size: 20 * Theme.factor)
        longLabel = UILabel.createLabel(size: 20 * Theme.factor)
        scriptionLabel = UILabel.createLabel(size: 20 * Theme.factor)
        
        myView = UIView()
        myView.backgroundColor = .clear
        myView.layer.borderWidth = 1
        
        collectButtonWidth = collectButton.widthAnchor.constraint(equalToConstant: 100 * Theme.factor)
        collectButtonWidth.isActive = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        layout()
        
    }
    
    private func layout() {
        
        let stackView = UIStackView(arrangedSubviews: [trackLabel,artistLabel,collectionLabel,longLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        contentView.addSubview(myView)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            myView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10 * Theme.factor),
            myView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -10 * Theme.factor),
            myView.topAnchor.constraint(equalTo: contentView.topAnchor),
            myView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubviews(cellImageView,stackView,collectButton,scriptionLabel,readMoreButton)
        NSLayoutConstraint.useAndActivateConstraints(constraints: [
            cellImageView.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            cellImageView.heightAnchor.constraint(equalToConstant: 150 * Theme.factor),
            cellImageView.leadingAnchor.constraint(equalTo: myView.leadingAnchor, constant: 10 * Theme.factor),
            cellImageView.topAnchor.constraint(equalTo: myView.topAnchor, constant: 10 * Theme.factor),
            
            stackView.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 10 * Theme.factor),
            stackView.trailingAnchor.constraint(equalTo: collectButton.leadingAnchor, constant: -10 * Theme.factor),
            
            collectButton.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor),
            collectButton.heightAnchor.constraint(equalToConstant: 50 * Theme.factor),
            collectButton.trailingAnchor.constraint(equalTo: myView.trailingAnchor, constant: -10 * Theme.factor),
            
            scriptionLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            scriptionLabel.trailingAnchor.constraint(equalTo: collectButton.trailingAnchor),
            scriptionLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10 * Theme.factor),
            
            readMoreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10 * Theme.factor),
            readMoreButton.topAnchor.constraint(equalTo: scriptionLabel.bottomAnchor, constant: 10 * Theme.factor),
            readMoreButton.trailingAnchor.constraint(equalTo: collectButton.trailingAnchor),
        ])
    }
    
    func setData(searchModel:SearchModel) {
        let detail = searchModel.ITuneData
        trackLabel.text = detail.trackName
        artistLabel.text = detail.artistName
        collectionLabel.text = detail.collectionName
        longLabel.text = detail.long
        scriptionLabel.text = detail.scription
        if ( searchModel.isFolder ) {
            scriptionLabel.numberOfLines = 2
            scriptionLabel.lineBreakMode = .byTruncatingTail
            readMoreButton.setTitle("...read more", for: .normal)
        }
        else {
            scriptionLabel.numberOfLines = 0
            scriptionLabel.lineBreakMode = .byCharWrapping
            readMoreButton.setTitle("folder", for: .normal)
        }
        
        self.isCollect = searchModel.isCollect
        
        self.cellImageView.sd_setImage(with: URL(string: detail.imageURL),
                                       placeholderImage: #imageLiteral(resourceName: "about.png"),
                                       options: [.allowInvalidSSLCertificates])
    }
    
    
    func setThemeColor() {
        let textColor = Theme.themeStlye.getTextColor()
        myView.layer.borderColor = textColor.cgColor
        trackLabel.textColor = textColor
        artistLabel.textColor = textColor
        collectionLabel.textColor = textColor
        longLabel.textColor = textColor
        scriptionLabel.textColor = textColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
