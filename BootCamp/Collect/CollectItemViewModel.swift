//
//  CollectItemViewModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation

class CollectItemViewModel {
    enum CollectType {
        case 電影
        case 音樂
    }
    
    private var collectType:CollectType = .電影
    var movies = [CollectionModel]()
    var musics = [CollectionModel]()
    func getData() {
        movies.append(CollectionModel(trackId: 123321, trackName: "測試Movie", artistName: "測試artist", collectionName:"測試collectionName",  time: "10:00:00", trackViewUrl: "", pictureURL: ""))
        musics.append(CollectionModel(trackId: 4433, trackName: "測試Music", artistName: "測試artist", collectionName:"測試collectionName",  time: "10:00:00", trackViewUrl: "", pictureURL: ""))
    }
}

extension CollectItemViewModel {
    func getItemSize()->Int {
        switch ( collectType ) {
        case .電影 :
            return movies.count
        case .音樂 :
            return musics.count
        }
    }
    
    func getData(indexPath:IndexPath)->CollectionModel? {
        var array = [CollectionModel]()
        switch( collectType ) {
        case .電影 :
            array = movies
            
        case .音樂 :
            array = musics
        }
        
        return ( indexPath.row >= array.count ) ? nil : array[indexPath.row]
    }
    
    func removeData(indexPath:IndexPath) {
        switch ( collectType ) {
        case .電影 :
            movies.remove(at: indexPath.row)
        case .音樂 :
            musics.remove(at: indexPath.row)
        }
    }
}

extension CollectItemViewModel {
    func updateType(type:CollectType) {
        self.collectType = type
    }
}
