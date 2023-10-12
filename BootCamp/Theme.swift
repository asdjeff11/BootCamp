//
//  Theme.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit

class Theme {
    enum ThemeStyle {
        case DarkTheme
        case lightTheme
        
        func getTextColor()->UIColor {
            switch ( self ) {
            case .DarkTheme :
                return .white
            case .lightTheme :
                return .black
            }
        }
        
        func getBackColor()->UIColor {
            switch( self ) {
            case .DarkTheme :
                return .black
            case .lightTheme :
                return .white
            }
        }
        func getThemeString()->String {
            switch ( self ) {
            case .DarkTheme :
                return "深色主題"
            case .lightTheme :
                return "淺色主題"
            }
        }
    }
    
    static var themeStlye:ThemeStyle = .lightTheme
    static var fullSize = UIScreen.main.bounds.size
    static let factor = UIScreen.main.bounds.width / 720
    static let navigationBtnSize = CGRect(x:0,y:0,width: 50 * factor, height: 50 * factor)
    static let labelFont = UIFont(name: "Helvetica-Light", size: 20)!
}
