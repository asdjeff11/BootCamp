//
//  CollectionModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation
struct CollectionModel:Codable {
    var trackId:Int // privacy key
    var trackName:String
    var artistName:String
    var collectionName:String
    var time:String
    var trackViewUrl:String
    var pictureURL:String
}
