//
//  SearchModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
struct SearchModel {
    var isFolder = true
    var isCollect:Bool
    var trackName:String
    var artistName:String
    var collectionName:String
    var longTime:String
    var scription:String
    var trackViewUrl:String
    
    init(detail:ITuneDataDetail) {
        self.trackName = detail.trackName
        self.artistName = detail.artistName
        self.collectionName = detail.collectionName ?? ""
        self.longTime = "" // 等等看
        self.scription = """
        Here's what I'm trying to do. If you've ever played Halo or CoD, you'd know that you could change the name of a weapon load-out.

        What I'm doing is making it so you can change your load-out name using a text field. Here's the problem, the load-out name in the load-out menu is a button (to select and view info about that load-out) and I could just write this:
        """
        self.trackViewUrl = detail.trackViewUrl
        self.isCollect = false
    }
    
}


struct ITuneResult:Codable {
    var resultCount:Int
    var results:[ITuneDataDetail]
}

// 將 music 與 movie 切開來 放一起太亂了

struct ITuneDataDetail:Codable,Hashable {
    //var wrapperType:String
    //var kind:String
    var artistId:Int
    var collectionId:Int? // 有些沒有
    var trackId:Int
    var artistName:String
    var collectionName:String?
    var trackName:String
    //var collectionCensoredName:String
    //var trackCensoredName:String
    var artistViewUrl:String // 歌手預覽
    var collectionViewUrl:String? // 專輯預覽
    var trackViewUrl:String
    var previewUrl:String // 播放按鈕
    //var artworkUrl30:String
    //var artworkUrl60:String
    var artworkUrl100:String // url for pic
    //var collectionPrice:Float
    //var trackPrice:Float
    var releaseDate:String
    //var collectionExplicitness:String
    //var trackExplicitness:String
    //var discCount:Int
    //var discNumber:Int
    //var trackCount:Int
    //var trackNumber:Int
    var trackTimeMillis:Double
    var country:String
    //var currency:String
    //var primaryGenreName:String
    //var isStreamable:Bool
    
    var longDescription:String
    
    static func == (lhs: ITuneDataDetail, rhs: ITuneDataDetail) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
        hasher.combine(trackName)
        hasher.combine(artistId)
    }
}

struct SearchITuneCondition {
    enum SearchType {
        case 電影
        case 音樂
        func getType()->String {
            switch ( self ) {
            case .電影 :
                return "movie"
            case .音樂 :
                return "music"
            }
        }
    }
    
    var term:String
    //var country:String?
    var media:SearchType = .電影
    func getUrl(offset:Int? = nil, limit:Int? = nil)->String {
        var url = "https://itunes.apple.com/search?"
        url += "term=\(term)"
        url += "&media=\(media.getType())"
//        if let country = country {
//            url += "&country=\(country)"
//        }
        
        if let offset = offset {
            url += "&offset=\(offset)"
        }
        
        if let limit = limit {
            url += "&limit=\(limit)"
        }
        
        
        return url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
}
