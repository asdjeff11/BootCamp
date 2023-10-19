//
//  CollectItemViewModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/16.
//

import Foundation

class CollectItemPresenter {
    private var collectType:MediaType = .電影
    var myCollectDatas = [MyITuneData]()
    
    func update(type:MediaType? = nil) {
        // 如果沒傳入就照舊 , 表示單純刷新資料 
        if let type = type {
            collectType = type
        }
        myCollectDatas = userData.getCollectMedia(type: collectType).sorted(by: { $0.trackId < $1.trackId })
    }
}

extension CollectItemPresenter {
    func getItemSize()->Int {
        myCollectDatas.count
    }
    
    func getData(indexPath:IndexPath)->MyITuneData? {
        ( indexPath.row >= myCollectDatas.count && indexPath.row >= 0) ? nil : myCollectDatas[indexPath.row]
    }
    
    func removeData(indexPath:IndexPath) {
        guard ( indexPath.row < myCollectDatas.count ) else { return }
        
        let trackId = myCollectDatas[indexPath.row].trackId
        userData.removeData(type:collectType, trackId: trackId)
        myCollectDatas.remove(at: indexPath.row)
    }
}
