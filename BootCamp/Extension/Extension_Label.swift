//
//  Extension_Label.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
extension UILabel {
    static func createLabel(size:CGFloat,color:UIColor? = nil,alignment:NSTextAlignment? = nil,alpha:CGFloat? = nil,text:String = "")->UILabel {
        let label = UILabel()
        label.font = Theme.labelFont.withSize(size)
        if let color = color {
            label.textColor = color
        }
        
        if ( text != "") {
            label.text = text
        }
        
        if let alignment = alignment {
            label.textAlignment = alignment
        }
        if let alpha = alpha {
            label.backgroundColor = UIColor(white:0 ,alpha: alpha)
        }
        return label
    }
}
