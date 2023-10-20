//
//  BootCampTestAPI.swift
//  BootCampTests
//
//  Created by esb23904 on 2023/10/17.
//

import XCTest
@testable import BootCamp

final class BootCampTestAPI: XCTestCase {
    var presenter:SearchPresenter!
    override func setUp() async throws {
        presenter = SearchPresenter()
    }
    
    // 測試 Itune url 製作
    func testSearchCondition() {
        var condition = SearchITuneCondition(term: "string")
        XCTAssertNotNil(URL(string: condition.getUrl()))
        // failed default is music
        // XCTAssertTrue( condition.getUrl() == "https://itunes.apple.com/search?term=string")
        XCTAssertTrue( condition.getUrl() == "https://itunes.apple.com/search?term=string&media=music")
        condition = SearchITuneCondition(term: "string",media: .電影)
        XCTAssertNotNil(URL(string: condition.getUrl()))
        XCTAssertTrue( condition.getUrl() == "https://itunes.apple.com/search?term=string&media=movie")
        
        condition = SearchITuneCondition(term: "string", media: .音樂)
        XCTAssertNotNil(URL(string: condition.getUrl()))
        XCTAssertTrue( condition.getUrl() == "https://itunes.apple.com/search?term=string&media=music")
    }
    
    // 測試 API 呼叫
    func testCallITuneAPI() {
        let url_strings = ["https://itunes.apple.com/search?term=One Piece&media=music", // success
                           "https://itunes.apple.com/search?term=One Piece&media=movie", // success
                           "https://itunes.apple.com/search?term=One Piece&media=god", // failed
                           "123" // failed
                          ]
        let chooseURL = url_strings[3].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let promise = expectation(description: "Completion handler invoked")
        var datas:[ITuneDataDetail]?
        presenter.fetchURLData(url_Str: chooseURL, finishCallBack: { (result:Result<ITuneResult,Error>) in
            switch ( result ) {
            case .success(let result) :
                datas = result.results
            case .failure(let error) :
                print(error)
            }
            promise.fulfill()
        })
        
        wait(for: [promise], timeout: 10)
        XCTAssertNotNil(datas)
    }
    
    // 測試輸入"關鍵字:後,是否正常取得資料
    func testFetchKeyword() {
        let condition = SearchITuneCondition(term: "hello world", media: .電影)
        let promise = expectation(description: "Completion handler invoked")
        
        presenter.fetchKeyword(condition: condition)
        presenter.group.notify(queue: .main) {
            promise.fulfill()
        }
       
        wait(for: [promise], timeout: 10)
        let errorMsg = presenter.calculateErrorMessage()
        if ( errorMsg == "" ) {
            XCTAssertTrue(presenter.getSize(type: .電影) != 0)
        }
        else {
            print(errorMsg)
            XCTFail()
        }
    }
}
