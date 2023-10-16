//
//  Theme.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

class Theme {
    enum ThemeStyle:String, CaseIterable {
        case DarkTheme = "深色主題"
        case lightTheme = "淺色主題"
        
        func getTextColor()->UIColor {
            switch ( self ) {
            case .DarkTheme :
                return .white
            case .lightTheme :
                return UIColor(hex: 0x000000, alpha: 0.7)
            }
        }
        
        func getBackColor()->UIColor {
            switch( self ) {
            case .DarkTheme :
                return UIColor(hex: 0x000000, alpha: 0.7)
            case .lightTheme :
                return .white
            }
        }
        
        func setButtonColor(button:UIButton) {
            switch ( self ) {
            case .DarkTheme :
                button.setTitleColor(UIColor(hex: 0x000000, alpha: 0.7), for: .normal)
                button.backgroundColor = .white
            case .lightTheme :
                button.setTitleColor(.white, for: .normal)
                button.backgroundColor = UIColor(hex: 0x000000, alpha: 0.7)
            }
            
        }
    }
    
    static var themeStlye:ThemeStyle = .lightTheme
    static var fullSize = UIScreen.main.bounds.size
    static let factor = UIScreen.main.bounds.width / 720
    static let navigationBtnSize = CGRect(x:0,y:0,width: 50 * factor, height: 50 * factor)
    static let labelFont = UIFont(name: "Helvetica-Light", size: 20)!
}
