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
    var movies = [MyITuneData]()
    var musics = [MyITuneData]()
    func getData() {
        movies = userData.getAllCollectMovies()
        musics = userData.getAllCollectMusic()
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
    
    func getData(indexPath:IndexPath)->MyITuneData? {
        var array = [MyITuneData]()
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
            let trackId = movies[indexPath.row].trackId
            userData.removeData(trackId: trackId)
            movies.remove(at: indexPath.row)
        case .音樂 :
            let trackId = musics[indexPath.row].trackId
            userData.removeData(trackId: trackId)
            musics.remove(at: indexPath.row)
        }
    }
}

extension CollectItemViewModel {
    func updateType(type:CollectType) {
        self.collectType = type
    }
}
