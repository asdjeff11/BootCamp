//
//  CollectItemTest.swift
//  BootCampTests
//
//  Created by esb23904 on 2023/10/17.
//

import XCTest
@testable import BootCamp

final class CollectItemTest: XCTestCase {
    var viewModel:CollectItemViewModel!
    override func setUp() async throws {
        viewModel = CollectItemViewModel()
        for data in userData.getAllCollectMovies() {
            userData.removeData(trackId: data.trackId)
        }
        
        for data in userData.getAllCollectMusic() {
            userData.removeData(trackId: data.trackId)
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
    
    func testGetData() {
        viewModel.getData()
        XCTAssertTrue(viewModel.movies.count == 3)
        XCTAssertTrue(viewModel.musics.count == 2)
        
        var indexPath = IndexPath(row: 1, section: 0)
        var data = viewModel.getData(indexPath: indexPath)
        
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.trackId == 10001)
        
        indexPath = IndexPath(row:3,section: 0)
        data = viewModel.getData(indexPath: indexPath)
        XCTAssertNil(data)
        
        // 切換音樂測試
        viewModel.updateType(type: .音樂)
        indexPath = IndexPath(row: 0, section: 0)
        data = viewModel.getData(indexPath: indexPath)
        XCTAssertNotNil(data)
        XCTAssertTrue(data!.trackId == 20000)
        
        indexPath = IndexPath(row:2, section: 0)
        data = viewModel.getData(indexPath: indexPath)
        XCTAssertNil(data)
    }
    
    func testRemove() {
        viewModel.getData()
        viewModel.updateType(type: .音樂)
        let musicSize = viewModel.getItemSize()
        
        viewModel.updateType(type: .電影)
        let indexPath = IndexPath(row: 0, section: 0)
        let size = viewModel.getItemSize()
        var data = viewModel.getData(indexPath: indexPath)
        XCTAssertNotNil(data)
        viewModel.removeData(indexPath: indexPath)
        XCTAssertTrue(viewModel.getItemSize() == size - 1)
        var newData = viewModel.getData(indexPath: indexPath)
        XCTAssertNotNil(newData)
        XCTAssertFalse( newData!.trackId == data!.trackId)
        
        viewModel.updateType(type: .音樂)
        XCTAssertEqual(viewModel.getItemSize(), musicSize)
    }
    
}
