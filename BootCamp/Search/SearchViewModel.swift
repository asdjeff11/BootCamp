//
//  SearchViewModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
import Alamofire
class SearchViewModel {
//    enum CustomError:Error {
//        case urlError
//        case responseError
//    }
    var movies = [SearchModel]()
    var musics = [SearchModel]()
    var errorMessages = Array(repeating: "", count: 2) // [0]:movie , [1]:music
    let group = DispatchGroup()
    var task:UIBackgroundTaskIdentifier?
    
//    private final let limit = 20 // 一次撈取的數量
//    private var movie_offset = 1 // movie 下次要撈取時起始位置
//    private var music_offset = 1 // music 下次要撈取時起始位置
}

extension SearchViewModel {
    // 啟動撈取事件
    func fetch(_ keyword:String,callBack:@escaping ((_:String)->())) {
        initData()
        DispatchQueue.global(qos: .background).async {
            // fetch
            self.fetchKeyword(condition:SearchITuneCondition(term:keyword,media: .電影))
            self.fetchKeyword(condition: SearchITuneCondition(term:keyword,media: .音樂))
            
            self.group.wait()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                callBack(self.calculateErrorMsg())
            }
        }
    }
    
    // 根據條件 撈取資訊
    private func fetchKeyword(condition:SearchITuneCondition) {
        let errorIndex = condition.media == .電影 ? 0 : 1
        group.enter()
        self.fetchURLData(url_Str: condition.getUrl(), finishCallBack:{ (result:Result<ITuneResult,Error>) in
            switch ( result ) {
            case .success(let datas) :
                switch( condition.media ) {
                case .電影 :
                    self.movies = datas.results.map({ SearchModel(detail: $0,type: condition.media) })
                case .音樂 :
                    self.musics = datas.results.map({ SearchModel(detail: $0,type: condition.media) })
                }
            case .failure(let error) :
                self.errorMessages[errorIndex] = error.localizedDescription
            }
            self.group.leave()
        })
    }
    
    // URL 撈取資訊
    func fetchURLData<T:Codable>(url_Str:String,finishCallBack: @escaping(Result<T,Error>)->Void) {
        AF.request(url_Str).responseDecodable(of: T.self) { response in
            switch ( response.result ) {
            case .success(let data):
                finishCallBack(.success(data))
            case .failure(let error) :
                finishCallBack(.failure(error))
            }
        }
    }
}

// cell 按鈕觸發事件
extension SearchViewModel {
    // 0: movie , 1: music
    func setFolder(indexPath:IndexPath) {
        if ( indexPath.section == 0 ) {
            self.movies[indexPath.row].isFolder = !self.movies[indexPath.row].isFolder
        }
        else {
            self.musics[indexPath.row].isFolder = !self.musics[indexPath.row].isFolder
        }
    }
    
    func setCollect(indexPath:IndexPath) {
        var data:SearchModel
        switch ( indexPath.section ) {
        case 0 :
            data = movies[indexPath.row]
        case 1 :
            data = musics[indexPath.row]
        default :
            return
        }
        
        if ( data.isCollect ) { // 原本追蹤
            userData.removeData(trackId: data.ITuneData.trackId)
        }
        else { // 原本沒追蹤
            userData.saveData(data: data.ITuneData)
        }
        
        data.isCollect = !data.isCollect
    }
}

// view 訪問取得資料
extension SearchViewModel {
    func getMusicSize()->Int {
        musics.count
    }
    
    func getMovieSize()->Int {
        movies.count
    }
    
    func getData(indexPath:IndexPath)->SearchModel? {
        let array = (indexPath.section == MediaType.電影.rawValue) ? movies : musics
        if ( array.count > indexPath.row ) {
            return array[indexPath.row]
        }
        else { // 降低 index out of range 的可能性
            return nil
        }
    }
}

// other Tool
extension SearchViewModel {
    // 重置資料
    private func initData() {
        musics.removeAll()
        movies.removeAll()
        errorMessages = Array(repeating: "", count: 2)
    }
    
    // 將錯誤訊息轉換
    func calculateErrorMsg()->String {
        var errMsg = ""
        if ( !self.errorMessages[0].isEmpty ) {
            errMsg += "fetch movie Error: \(self.errorMessages[0])"
        }
        
        if ( !self.errorMessages[1].isEmpty ) {
            if ( !errMsg.isEmpty ) { errMsg += "\n" }
            errMsg += "fetch music Error: \(self.errorMessages[1])"
        }
        return errMsg
    }
    
    // 刷新所有追蹤資訊
    func refreshCollect() {
        for movie in movies {
            movie.isCollect = userData.isCollect(trackId: movie.ITuneData.trackId)
        }
        for music in musics {
            music.isCollect = userData.isCollect(trackId: music.ITuneData.trackId)
        }
    }
}
