//
//  MyDataBaseStructer.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation
protocol MyDataBaseStructer:Codable {
    static var tableName:String { get }
    
    static func createTable()->String
}

extension MyDataBaseStructer {
    func getUpdateQuery()->String {
        let mirror = Mirror(reflecting: self)
        var columnInfo = ""
        var valueInfo = ""
        
        for child in mirror.children {
            let label:String = child.label!
            if ( label == "tableName" ) { continue }
            let valueType = "\(type(of: child.value))"
            
            // value 修改
            var value = "\(child.value)"
            if ( value == "nil" ) { value = "" }
            
            if ( valueType.contains("String") ) { // 字串
                if ( value == "~" ) { value = "\"\"" } // 改回空字串
                else { value = "\"\(value)\"" } // 補string \"\"符號
            }
            else {
                if ( value == "-1" ) { // integer default
                    value = "0"
                }
            }
            
            columnInfo = "\(columnInfo)\(label),"
            valueInfo = "\(valueInfo)\(value),"
        }
        
        return """
        REPLACE INTO \(Self.tableName) ( \(String(columnInfo.dropLast())) ) VALUES ( \(String(valueInfo.dropLast())) ) ;
        """
    }
}

struct MyITuneData:MyDataBaseStructer {
    static var tableName: String = "CollectITuneData"
    
    var trackId:Int = 0
    var trackName:String = ""
    var artistName:String = ""
    var collectionName:String = ""
    var long:String = ""
    var imageURL:String = ""
    var trackViewURL:String = ""
    var scription:String = ""
    var type = 0 // 0:Movie , 1:Music
    
    init(detail:ITuneDataDetail,type:MediaType) {
        self.trackId = detail.trackId
        self.trackName = detail.trackName
        self.artistName = detail.artistName
        self.collectionName = detail.collectionName
        self.long = long_doubeToString(timeMillis: detail.trackTimeMillis)
        self.imageURL = detail.artworkUrl100
        self.trackViewURL = detail.trackViewUrl
        self.scription = detail.longDescription ?? ""
        self.type = type.rawValue
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case trackId = "trackId"
        case trackName = "trackName"
        case artistName = "artistName"
        case collectionName = "collectionName"
        case long = "long"
        case imageURL = "imageURL"
        case trackViewURL = "trackViewURL"
        case scription = "scription"
        case type = "type"
    }
    
    static func createTable() -> String {
        return  """
                create table if not exists \(Self.tableName)
                ( trackId integer primary key,
                trackName text,
                artistName text,
                collectionName text,
                long text,
                imageURL text,
                trackViewURL text,
                scription text,
                type integer);
                """
    }
    
    private func long_doubeToString(timeMillis:Double)->String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let str = formatter.string(from: TimeInterval(timeMillis / 1000)) ?? ""
        return str
    }
}

extension MyITuneData {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        trackId = try values.decodeIfPresent(Int.self, forKey: .trackId) ?? -1
        trackName = try values.decodeIfPresent(String.self, forKey: .trackName) ?? ""
        artistName = try values.decodeIfPresent(String.self, forKey: .artistName) ?? ""
        collectionName = try values.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        long = try values.decodeIfPresent(String.self, forKey: .long) ?? ""
        imageURL = try values.decodeIfPresent(String.self, forKey: .imageURL) ?? ""
        trackViewURL = try values.decodeIfPresent(String.self, forKey: .trackViewURL) ?? ""
        scription = try values.decodeIfPresent(String.self, forKey: .scription) ?? ""
        type = try values.decodeIfPresent(Int.self, forKey: .type) ?? -1
    }
}

