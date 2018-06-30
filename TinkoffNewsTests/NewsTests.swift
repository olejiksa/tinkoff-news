//
//  NewsTests.swift
//  TinkoffNewsTests
//
//  Created by Oleg Samoylov on 30/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import XCTest
@testable import TinkoffNews

class NewsTests: XCTestCase {
    
    /// Possible page numbers as sample
    private let pageNumbers = [.min, -7, 0, 7, 20, .max]
    
    /// Service layer object to test
    private var newsService: (IFeedService & IPostService)!
    
    // MARK: - Setting up of test environment
    
    override func setUp() {
        super.setUp()
        
        let requestSender: IRequestSender = RequestSender()
        newsService = NewsService(requestSender: requestSender)
    }
    
    override func tearDown() {
        newsService = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testNewsFeed() {
        let feedExpectation = XCTestExpectation(description: "News feed is loaded")
        let validError = "Index out of bounds"
        
        for page in pageNumbers {
            newsService.getNewsFeed(page: page) { feed, error in
                XCTAssertTrue(error == nil || error?.description == validError)
                
                if error == nil {
                    XCTAssertNotNil(feed)
                }
                
                feedExpectation.fulfill()
            }
        }
        
        wait(for: [feedExpectation], timeout: 5)
    }
    
    func testNewsPost() {
        let firstExpectation = XCTestExpectation(description: "News post 1 has been loaded")
        
        newsService.getNewsPost(id: "ABC") { _, error in
            XCTAssertNotNil(error)
            firstExpectation.fulfill()
        }
        
        wait(for: [firstExpectation], timeout: 5)
        
        let secondExpectation = XCTestExpectation(description: "News post 2 has been loaded")
        
        newsService.getNewsPost(id: "9744") { post, error in
            XCTAssertNil(error)
            secondExpectation.fulfill()
        }
        
        wait(for: [secondExpectation], timeout: 5)
    }
    
}
