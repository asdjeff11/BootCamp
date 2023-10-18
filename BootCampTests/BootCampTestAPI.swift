//
//  BootCampTestAPI.swift
//  BootCampTests
//
//  Created by esb23904 on 2023/10/17.
//

import XCTest
@testable import BootCamp

final class BootCampTestAPI: XCTestCase {
    var viewModel:SearchViewModel!
    override func setUp() async throws {
        viewModel = SearchViewModel()
    }
    
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
    
    
    func testCallITuneAPI() {
        let url_strings = ["https://itunes.apple.com/search?term=HelloWorld", // success
                           "https://itunes.apple.com/search?term=HelloWorld&media=music", // success
                           "https://itunes.apple.com/search?term=HelloWorld&media=movie", // success
                           "https://itunes.apple.com/search?term=HelloWorld&media=god", // failed
                           "123" // failed
                          ]
        
        let chooseURL = url_strings[0]
        let promise = expectation(description: "Completion handler invoked")
        var datas:[ITuneDataDetail]?
        viewModel.fetchURLData(url_Str: chooseURL, finishCallBack: { (result:Result<ITuneResult,Error>) in
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
    
    func testFetchKeyword() {
        let condition = SearchITuneCondition(term: "hello world", media: .電影)
        let promise = expectation(description: "Completion handler invoked")
        
        viewModel.fetchKeyword(condition: condition)
        viewModel.group.notify(queue: .main) {
            promise.fulfill()
        }
       
        wait(for: [promise], timeout: 10)
        XCTAssert(viewModel.movies.isEmpty == false)
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
