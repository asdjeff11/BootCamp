//
//  UserData.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation

class UserData {
    private var collectMovies:[Int:MyITuneData] = [:] // trackId => data
    private var collectMusics:[Int:MyITuneData] = [:]
    private let userDefault = UserDefaults()
    private var themeType:Theme.ThemeStyle = .LightTheme
    
    init() {
        if let themeStyle = userDefault.value(forKey: "ThemeStyle") as? String {
            themeType = themeStyle == "深色主題" ? .DarkTheme : .LightTheme
        }
    }
    
    func getThemeType()->Theme.ThemeStyle {
        themeType
    }
    
    func updateThemeType() {
        userDefault.set(Theme.themeStlye.rawValue, forKey: "ThemeStyle")
    }
    
    func getDbData() {
        let query = "Select * from `CollectITuneData` ;"
        let ITuneDatas:[MyITuneData] = db.read2Object(query: query)
        for data in ITuneDatas {
            if ( data.type == 0 ) { // movie
                collectMovies[data.trackId] = data
            }
            else if ( data.type == 1 ) { // music
                collectMusics[data.trackId] = data
            }
        }
    }
    
    func getAllCollectMovies()->[MyITuneData] {
        Array(collectMovies.values)
    }
    
    func getAllCollectMusic()->[MyITuneData] {
        Array(collectMusics.values)
    }
    
    func saveData(data:MyITuneData) {
        db.executeQuery(query: data.getUpdateQuery())
        switch ( data.type ) {
        case MediaType.電影.rawValue :
            self.collectMovies[data.trackId] = data
        case MediaType.音樂.rawValue :
            self.collectMusics[data.trackId] = data
        default :
            return
        }
    }
    
    func removeData(trackId:Int) {
        let query = """
        DELETE FROM `\(MyITuneData.tableName)` WHERE `trackId` = \(trackId);
        """
        db.executeQuery(query: query)
        
        self.collectMovies.removeValue(forKey: trackId)
        self.collectMusics.removeValue(forKey: trackId)
        
    }
    
    
    func isCollect(trackId:Int) -> Bool {
        return ( collectMovies[trackId] != nil || collectMusics[trackId] != nil )
    }
    
    func getTotalCount()->String {
        let count = collectMovies.count + collectMusics.count
        return count.formatted()
    }
    
}
