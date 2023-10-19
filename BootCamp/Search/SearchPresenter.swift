//
//  SearchViewModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
import UIKit
import Alamofire
class SearchPresenter {
    private var keyword = "" // 上次搜尋紀錄
    private var searchDatas:[MediaType:[SearchModel]] = [:] // MediaType => [Data]
    private var errorMessages = Array(repeating: "", count: MediaType.allCases.count) // [0]:movie , [1]:music ...
    private let group = DispatchGroup()
    
    init() {
        for type in MediaType.allCases {
            searchDatas[type] = []
        }
    }
}

extension SearchPresenter {
    // 啟動撈取事件
    func fetch(_ keyword:String,callBack:@escaping ((_:String)->())) {
        initData()
        self.keyword = keyword
        
        // fetch
        for mediaType in MediaType.allCases {
            self.fetchKeyword(condition:SearchITuneCondition(term:keyword,media: mediaType))
        }
        self.group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let errorMessage = self.calculateErrorMessage()
            if ( errorMessage != "" ) { self.keyword = "" }
            callBack(errorMessage)
        }
    }
    
    // 根據條件 撈取資訊
    func fetchKeyword(condition:SearchITuneCondition) {
        let errorIndex = condition.media.rawValue
        group.enter()
        self.fetchURLData(url_Str: condition.getUrl(), finishCallBack:{ (result:Result<ITuneResult,Error>) in
            switch ( result ) {
            case .success(let datas) :
                self.searchDatas[condition.media] = datas.results.map({ SearchModel(detail: $0,type: condition.media) })
            case .failure(let error) :
                self.errorMessages[errorIndex] = error.localizedDescription
            }
            self.group.leave()
        })
    }
    
    // URL 撈取資訊
    func fetchURLData<T:Codable>(url_Str:String,finishCallBack: @escaping(Result<T,Error>)->Void) {
        AF.request(url_Str){ $0.timeoutInterval = 30 }
          .responseDecodable(of: T.self) { response in
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
extension SearchPresenter {
    func setFolder(type:MediaType, row:Int) {
        guard let data = searchDatas[type]?[row] else { return }
        data.isFolder = !data.isFolder
    }
    
    func setCollect(type:MediaType, row:Int)  {
        guard let data = searchDatas[type]?[row] else { return }
        let trackId = data.ITuneData.trackId
        if ( userData.isCollect(type: type, trackId: trackId) ) { // 原本追蹤
            userData.removeData(type: type, trackId: trackId)
        }
        else { // 原本沒追蹤
            userData.saveData(data: data.ITuneData)
        }
    }
}

// view 訪問取得資料
extension SearchPresenter {
    func getSize(type:MediaType)->Int {
        searchDatas[type]?.count ?? 0
    }
    
    func getData(type:MediaType, row:Int)->SearchModel? {
        guard let datas = searchDatas[type],
              datas.count > row, // 降低 index out of range 的可能性
              row >= 0
        else { return nil }
        
        return datas[row]
    }
}

// other Tool
extension SearchPresenter {
    // 重置資料
    private func initData() {
        for key in searchDatas.keys {
            searchDatas[key]?.removeAll()
        }
        errorMessages = Array(repeating: "", count: 2)
    }
    
    // 將錯誤訊息轉換
    func calculateErrorMessage()->String {
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
//    func refreshCollect() {
//        for (type,datas) in searchDatas {
//            for data in datas {
//                data.isCollect = userData.isCollect(type: type, trackId: data.ITuneData.trackId)
//            }
//        }
//    }
    
    func getLastKeyword()-> String {
        keyword
    }
}
