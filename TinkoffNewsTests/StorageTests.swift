//
//  StorageTests.swift
//  TinkoffNewsTests
//
//  Created by Олег Самойлов on 30/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import XCTest
@testable import TinkoffNews

class StorageTests: XCTestCase {
    
    /// Service layer object to test
    private var storageService: IComplexStorageService!
    
    // MARK: - Setting up of test environment
    
    override func setUp() {
        super.setUp()
        
        let coreDataStack: ICoreDataStack = CoreDataStack(resourseName: "TinkoffNews", storeType: .inMemory)
        let storageManager: IStorageManager = StorageManager(coreDataStack: coreDataStack)
        storageService = StorageService(storageManager: storageManager)
    }
    
    override func tearDown() {
        storageService = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testThat_newsFeedCanBeSaved() {
        let isSaved = expectation(description: "Saved")
        let isLoadedPage1 = expectation(description: "0-20")
        let isLoadedPage2 = expectation(description: "20-40")
        
        var newsFeed = [FeedItem]()
        
        for i in 1...10 {
            newsFeed.append(FeedItem(id: "\(i)", text: "\(i)", publicationDate: PublicationDate(milliseconds: i * i), viewsCount: i - 1))
        }
        
        storageService.saveNewsFeed(newsFeed) { error in
            XCTAssertNil(error)
            isSaved.fulfill()
        }
        
        wait(for: [isSaved], timeout: 3)
        
        storageService.getViewsCounts(page: 1) { viewsCounts, error in
            XCTAssertNil(error)
            if let counts = viewsCounts {
                for eachViewsCount in counts {
                    XCTAssertEqual(eachViewsCount.value + 1, Int(eachViewsCount.key)!)
                }
                
                isLoadedPage1.fulfill()
            }
        }
        
        storageService.getViewsCounts(page: 2) { viewsCounts, error in
            XCTAssertNil(error)
            XCTAssertEqual(viewsCounts?.count, 0)
            isLoadedPage2.fulfill()
        }
        
        wait(for: [isLoadedPage1, isLoadedPage2], timeout: 3)
    }
    
    func testThat_newsContentCanBeSaved() {
        let isSavedFeedItem = expectation(description: "isSavedFeedItem")
        let isSavedPostItem = expectation(description: "isSavedPostItem")
        let isLoaded = expectation(description: "Loaded")
        let expectedContent = "This is definitely the new World..."
        
        var newsFeedItem: FeedItem!
        var newsPost: PostItem!
        
        newsFeedItem = FeedItem(id: "\(1)", text: "Hello, World!", publicationDate: PublicationDate(milliseconds: Date().milliseconds()), viewsCount: 0)
        newsPost = PostItem(title: Title(id: newsFeedItem.id), content: expectedContent)
        
        storageService.saveNewsFeedItem(newsFeedItem) { error in
            XCTAssertNil(error)
            isSavedFeedItem.fulfill()
        }
        
        wait(for: [isSavedFeedItem], timeout: 3)
        
        storageService.saveNewsPost(newsPost) { error in
            XCTAssertNil(error)
            isSavedPostItem.fulfill()
        }
        
        wait(for: [isSavedPostItem], timeout: 3)
        
        storageService.getNewsPost(id: "\(1)") { post, error in
            XCTAssertNil(error)
            XCTAssertEqual(post?.content, expectedContent)
            XCTAssertEqual(post?.title.id, "\(1)")
            isLoaded.fulfill()
        }
        
        wait(for: [isLoaded], timeout: 3)
    }
    
    func testThat_isEmptyWorks() {
        
    }
    
}
