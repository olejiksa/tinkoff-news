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
    
    /// Core layer object
    private var requestSender: (IRequestSender & Nameable)!
    
    // MARK: - Setting up of test environment
    
    override func setUp() {
        super.setUp()
        
        requestSender = FakeRequestSender()
        newsService = NewsService(requestSender: requestSender)
    }
    
    override func tearDown() {
        newsService = nil
        requestSender = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testNewsFeed() {
        requestSender.resourseName = "FakeNewsFeed"
        
        var feedExpectations = [XCTestExpectation]()
        
        for page in pageNumbers {
            let postExpectation = XCTestExpectation(description: "News post on page \(page) has been loaded")
            feedExpectations.append(postExpectation)
            
            newsService.getNewsFeed(page: page) { feed, error in
                XCTAssertTrue(error == nil || error?.description == "Index out of bounds")
                
                if error == nil {
                    XCTAssertNotNil(feed)
                }
                
                postExpectation.fulfill()
            }
        }
        
        wait(for: feedExpectations, timeout: 8)
    }
    
    func testNewsPost() {
        requestSender.resourseName = "FakeNewsPost"
        
        let expectation = XCTestExpectation(description: "News post has been loaded")
        let expectationModel = (id: "9746",
                                contentStartsWith: "Москва, Россия — 20 ноября 2017")
        
        newsService.getNewsPost(id: expectationModel.id) { post, error in
            guard let post = post else {
                XCTFail()
                return
            }
            
            XCTAssertNil(error)
            
            XCTAssertEqual(post.id, expectationModel.id)
            
            let decodedString = String(htmlEncodedString: post.content)
            let prefixedDecodedString = decodedString?.prefix(expectationModel.contentStartsWith.count).description
            XCTAssertEqual(prefixedDecodedString, expectationModel.contentStartsWith)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
}
