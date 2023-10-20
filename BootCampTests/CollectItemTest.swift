//
//  CollectItemTest.swift
//  BootCampTests
//
//  Created by esb23904 on 2023/10/17.
//

import XCTest
@testable import BootCamp

final class CollectItemTest: XCTestCase {
    var presenter:CollectItemPresenter!
    override func setUp() async throws {
        presenter = CollectItemPresenter()
        presenter.update()
        
        for data in presenter.myCollectDatas {
            userData.removeData(type: .電影, trackId: data.trackId)
        }
        presenter.update(type: .音樂)
        for data in presenter.myCollectDatas {
            userData.removeData(type: .音樂, trackId: data.trackId)
        }
    
        for i in 0..<3 {
            userData.saveData(data: MyITuneData(detail: ITuneDataDetail(trackId: 10000 + i,
                                                                        trackName: "MovieTrackName_\(i)",
                                                                        artistName: "MovieArtistName_\(i)",
                                                                        collectionName: "MovieCollectName_\(i)",
                                                                        trackTimeMillis: Double(100000 + i),
                                                                        trackViewUrl: "",
                                                                        artworkUrl100: "",
                                                                        longDescription: "Hello world"),
                                                type:.電影))
            if ( i < 2 ) {
                userData.saveData(data: MyITuneData(detail: ITuneDataDetail(trackId: 20000 + i,
                                                                            trackName: "MusicTrackName_\(i)",
                                                                            artistName: "MusicArtistName_\(i)",
                                                                            collectionName: "MusciCollectName_\(i)",
                                                                            trackTimeMillis: Double(200000 + i),
                                                                            trackViewUrl: "",
                                                                            artworkUrl100: "",
                                                                            longDescription: "Hello world"),
                                                    type:.音樂))
            }
        }
    }
    
    // 測試切換電影與音樂 取得資料是否異常
    func testGetData() {
        presenter.update(type:.電影)
        XCTAssertTrue(presenter.getItemSize() == 3)
        
        presenter.update(type: .音樂)
        XCTAssertTrue(presenter.getItemSize() == 2)
        
        presenter.update(type: .電影)
        var indexPath = IndexPath(row: 1, section: 0)
        var data = presenter.getData(indexPath: indexPath)
        
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.trackId == 10001)
        
        indexPath = IndexPath(row:3,section: 0)
        data = presenter.getData(indexPath: indexPath)
        XCTAssertNil(data)
        
        // 切換音樂測試
        presenter.update(type: .音樂)
        indexPath = IndexPath(row: 0, section: 0)
        data = presenter.getData(indexPath: indexPath)
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.trackId == 20000)
        
        indexPath = IndexPath(row:2, section: 0)
        data = presenter.getData(indexPath: indexPath)
        XCTAssertNil(data)
    }
    
    func testRemove() {
        presenter.update(type: .音樂)
        let musicSize = presenter.getItemSize()
        
        presenter.update(type: .電影)
        let indexPath = IndexPath(row: 0, section: 0)
        let size = presenter.getItemSize()
        let data = presenter.getData(indexPath: indexPath)
        XCTAssertNotNil(data)
        presenter.removeData(indexPath: indexPath)
        XCTAssertTrue(presenter.getItemSize() == size - 1)
        let newData = presenter.getData(indexPath: indexPath)
        XCTAssertNotNil(newData)
        XCTAssertFalse( newData!.trackId == data!.trackId)
        
        presenter.update(type: .音樂)
        XCTAssertEqual(presenter.getItemSize(), musicSize)
    }
    
}
