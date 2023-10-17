//
//  SearchModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
class SearchModel {
    var isFolder:Bool
    var isCollect:Bool
    var ITuneData:MyITuneData
    init(detail:ITuneDataDetail, type:MediaType) {
        isFolder = true
        isCollect = userData.isCollect(trackId: detail.trackId)
        ITuneData = MyITuneData(detail:detail,type:type)
    }
}

//class SearchModel {
//    var isFolder = true
//    var isCollect:Bool
//    var trackId:Int
//    var trackName:String
//    var artistName:String
//    var collectionName:String
//    var time:String
//    var scription:String
//    var trackViewUrl:String
//    var pictureURL:String
//    init(detail:ITuneDataDetail) {
//        self.trackId = detail.trackId
//        self.trackName = detail.trackName
//        self.artistName = detail.artistName
//        self.collectionName = detail.collectionName
//        self.time = "" // 所有參數必須要先初始化後 才能呼叫函數 由下面計算
//        self.scription = detail.longDescription ?? ""
//        self.trackViewUrl = detail.trackViewUrl
//        self.pictureURL = detail.artworkUrl100
//        self.isCollect = false
//        
//        // 時間轉換
//        self.time = long_doubeToString(timeMillis: detail.trackTimeMillis)
//        
//        // 判斷是否已經追蹤
//        self.isCollect = userData.isCollect(trackId: detail.trackId)
//    }
//    
//    private func long_doubeToString(timeMillis:Double)->String {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute, .second]
//        formatter.unitsStyle = .positional
//        let str = formatter.string(from: TimeInterval(timeMillis / 1000)) ?? ""
//        return str
//    }
//}
