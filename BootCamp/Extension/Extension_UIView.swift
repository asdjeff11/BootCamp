//
//  Extension_UIView.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

extension UIView {
    func addSubviews(_ views:UIView...) {
        if let stackView = self as? UIStackView {
            for view in views {
                stackView.addArrangedSubview(view)
            }
        }
        else {
            for view in views {
                addSubview(view)
            }
        }
    }
}

extension NSLayoutConstraint {
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                 view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}
