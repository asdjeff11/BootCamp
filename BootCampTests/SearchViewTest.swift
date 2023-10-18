//
//  SearchViewModelTest.swift
//  BootCampTests
//
//  Created by esb23904 on 2023/10/17.
//

import XCTest
@testable import BootCamp

final class SearchViewTest: XCTestCase {
    var presenter:SearchPresenter!
    override func setUp() async throws {
        presenter = SearchPresenter()
        for i in 0..<10 {
            presenter.movies.append(SearchModel(detail: ITuneDataDetail(trackId: 20000 + i,
                                                                        trackName: "movieTrackName_\(i)",
                                                                        artistName: "movieArtistName_\(i)",
                                                                        collectionName: "movieCollectionName_\(i)",
                                                                        trackTimeMillis: Double(20000 + i),
                                                                        trackViewUrl: "",
                                                                        artworkUrl100: ""),
                                                type: .電影))
            if ( i < 9 ) {
                presenter.musics.append(SearchModel(detail: ITuneDataDetail(trackId: 10000 + i,
                                                                            trackName: "musicTrackName_\(i)",
                                                                            artistName: "musicArtistName_\(i)",
                                                                            collectionName: "musicCollectionName_\(i)",
                                                                            trackTimeMillis: Double(10000 + i),
                                                                            trackViewUrl: "",
                                                                            artworkUrl100: ""),
                                                    type: .音樂))
            }
        }
        //userData.removeData(trackId: 200001)
    }
    
    func testGetData() {
        // test Movie
        var data = presenter.getData(type: .電影, row: 1)
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.ITuneData.type == MediaType.電影.rawValue)
        
        // test music
        data = presenter.getData(type: .音樂, row: 1)
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.ITuneData.type == MediaType.音樂.rawValue)
        
        // 錯誤測試
        data = presenter.getData(type: .電影, row: 11)
        XCTAssertNil(data)
        
        data = presenter.getData(type: .音樂, row: -10)
        XCTAssertNil(data)
    }
    
    func testCollect() {
        for item in presenter.musics {
            item.isCollect = true
        }
        presenter.refreshCollect()
        
        for item in presenter.musics {
            XCTAssertFalse( item.isCollect )
        }
    }
    
    func testSaveCollect() {
        // 測試瘋狂點擊 追蹤/取消追蹤 按鈕
        
        // 抓取資料
        var data = presenter.getData(type: .電影, row: 0)
        // 判斷資料存在
        XCTAssertNotNil(data)
        // 紀錄原先追蹤狀態
        let originalCollectStatus = data!.isCollect
        // 瘋狂點擊追蹤按鈕
        let clickTimes = 21 // 連點次數
        for _ in 0..<clickTimes {
            presenter.setCollect(type: .電影, row: 0)
        }
        
        // 判斷userData的追蹤紀錄是否與 SearchModel 相同
        data = presenter.getData(type: .電影, row: 0)
        let nowUserCollect = userData.isCollect(trackId: data!.ITuneData.trackId)
        let dataCollect = data!.isCollect
        XCTAssertEqual(nowUserCollect, dataCollect)
        
        // 判斷 如果是點擊偶數次數 狀態應該跟原先一樣
        // 反之 奇數次數應該狀態不同
        if ( clickTimes % 2 == 0 ) {
            XCTAssertEqual(originalCollectStatus, dataCollect)
        }
        else {
            XCTAssertNotEqual(originalCollectStatus, dataCollect)
        }
    }
    
    func testFetchData() {
        let keyword = "hello"
        let promise = expectation(description: "Completion handler invoked")
        presenter.fetch(keyword, callBack: { (errorMessage) in
            XCTAssertTrue(errorMessage == "") // "" 表示沒有錯誤訊息
            promise.fulfill()
        })
        
        wait(for: [promise], timeout: 10)
        XCTAssertFalse(presenter.movies.isEmpty)
        XCTAssertFalse(presenter.musics.isEmpty)
        
    }
}
