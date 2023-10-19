//
//  SearchModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
class SearchModel {
    var isFolder:Bool
//    var isCollect:Bool
    var ITuneData:MyITuneData
    init(detail:ITuneDataDetail, type:MediaType) {
        isFolder = true
//        isCollect = userData.isCollect(type: type, trackId: detail.trackId)
        ITuneData = MyITuneData(detail:detail,type:type)
    }
}
