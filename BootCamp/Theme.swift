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
        case LightTheme = "淺色主題"
        case yellowTheme = "黃色主題"
        case blueTheme = "藍色主題"
        func getSecondColor()->UIColor {
            switch ( self ) {
            case .DarkTheme :
                return .white
            case .LightTheme :
                return .black
            case .yellowTheme :
                return .black
            case .blueTheme :
                return .black
            }
        }
        
        func getMainColor()->UIColor {
            switch( self ) {
            case .DarkTheme :
                return .gray
            case .LightTheme :
                return .white
            case .yellowTheme :
                return UIColor(hex: 0xF5F5DC)
            case .blueTheme :
                return UIColor(hex: 0x87CEEB)
            }
        }
        
    }
 
    static var fullSize = UIScreen.main.bounds.size
    static let factor = UIScreen.main.bounds.width / 720
    static let navigationBtnSize = CGRect(x:0,y:0,width: 50 * factor, height: 50 * factor)
    static let labelFont = UIFont(name: "Helvetica-Light", size: 20)!
}
