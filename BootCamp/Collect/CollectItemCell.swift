//
//  CollectItemCell.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation
import UIKit
import SDWebImage
class CollectItemCell:UITableViewCell {
    var cellImageView:UIImageView
    var trackLabel:UILabel
    var artistLabel:UILabel
    var collectionLabel:UILabel
    var longLabel:UILabel
    let removeCollectButton:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hex: 0x5F58E1)
        btn.layer.cornerRadius = 5
        btn.setTitle("取消收藏", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        cellImageView = UIImageView()
        trackLabel = UILabel.createLabel(size: 30 * Theme.factor)
        artistLabel = UILabel.createLabel(size: 20 * Theme.factor)
        collectionLabel = UILabel.createLabel(size: 20 * Theme.factor)
        longLabel = UILabel.createLabel(size: 20 * Theme.factor)

        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layer.borderColor = userData.getSecondColor().cgColor
        layer.borderWidth = 1
        backgroundColor = userData.getMainColor()
        layout()
        
    }
    
    func layout() {
        let stackView = UIStackView(arrangedSubviews: [trackLabel,artistLabel,collectionLabel,longLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        
        contentView.addSubviews(cellImageView,stackView,removeCollectButton)
    
        NSLayoutConstraint.useAndActivateConstraints(constraints:[
            cellImageView.widthAnchor.constraint(equalToConstant: 150 * Theme.factor),
            cellImageView.heightAnchor.constraint(equalToConstant: 150 * Theme.factor),
            cellImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10 * Theme.factor),
            cellImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10 * Theme.factor),
            
            stackView.topAnchor.constraint(equalTo: cellImageView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 10 * Theme.factor),
            stackView.trailingAnchor.constraint(equalTo: removeCollectButton.leadingAnchor, constant: -10 * Theme.factor),
            
            removeCollectButton.centerYAnchor.constraint(equalTo: cellImageView.centerYAnchor),
            removeCollectButton.heightAnchor.constraint(equalToConstant: 50 * Theme.factor),
            removeCollectButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10 * Theme.factor),
            removeCollectButton.widthAnchor.constraint(equalToConstant: 180 * Theme.factor)
        ])
    }
    
    func setData(data:MyITuneData) {
        self.trackLabel.text = data.trackName
        self.artistLabel.text = data.artistName
        self.collectionLabel.text = data.collectionName
        self.longLabel.text = data.long
        
        self.cellImageView.sd_setImage(with: URL(string: data.imageURL),
                                       placeholderImage: #imageLiteral(resourceName: "about.png"),
                                       options: [.allowInvalidSSLCertificates])
    }
    
    func setThemeColor() {
        let secondColor = userData.getSecondColor()
        layer.borderColor = secondColor.cgColor
        trackLabel.textColor = secondColor
        artistLabel.textColor = secondColor
        collectionLabel.textColor = secondColor
        longLabel.textColor = secondColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
