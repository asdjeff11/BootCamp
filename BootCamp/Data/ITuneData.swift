//
//  ITuneData.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/13.
//

import Foundation
struct ITuneResult:Codable {
    var resultCount:Int
    var results:[ITuneDataDetail]
}

struct ITuneDataDetail:Codable,Hashable {
    var trackId:Int
    var trackName:String // 電影
    var artistName:String // 作者
    var collectionName:String //
    var trackTimeMillis:Double // 長度
    var trackViewUrl:String // url 連結
    var artworkUrl100:String // 圖片連結
    var longDescription:String? // 描述
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case trackId = "trackId"
        case trackName = "trackName"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case trackTimeMillis = "trackTimeMillis"
        case trackViewUrl = "trackViewUrl"
        case artworkUrl100 = "artworkUrl100"
        case longDescription = "longDescription"
    }
    
    
    static func == (lhs: ITuneDataDetail, rhs: ITuneDataDetail) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackId)
        hasher.combine(trackName)
    }
}

extension ITuneDataDetail {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackId = try values.decodeIfPresent(Int.self, forKey: .trackId) ?? -1
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName) ?? ""
        collectionName = try values.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        trackTimeMillis = try values.decodeIfPresent(Double.self, forKey: .trackTimeMillis) ?? 0
        
        trackViewUrl = try values.decodeIfPresent(String.self, forKey: .trackViewUrl) ?? ""
        artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        longDescription = try values.decodeIfPresent(String.self, forKey: .longDescription)
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

/*
 struct ITuneMusicData:Codable {
     var trackId:Int
     var trackName:String // 音樂名稱
     var artistName:String // 作者
     var collectionName:String //
     var trackTimeMillis:Double // 音樂長度 到毫秒
     var trackViewUrl:String // url 連結
     var artworkUrl100:String // 圖片連結
 }

 struct ITuneMovieData:Codable {
     var trackId:Int
     var trackName:String // 電影名稱
     var artistName:String // 作者
     var collectionName:String //
     var trackTimeMillis:Double // 長度
     var trackViewUrl:String // url 連結
     var artworkUrl100:String // 圖片連結
     var longDescription:String // 描述
 }
 */
