//
//  SearchModel.swift
//  BootCamp
//
//  Created by esb23904 on 2023/10/12.
//

import Foundation
class SearchModel {
    var isFolder:Bool
    var ITuneData:MyITuneData
    init(detail:ITuneDataDetail, type:MediaType) {
        isFolder = true
        ITuneData = MyITuneData(detail:detail,type:type)
    }
}
