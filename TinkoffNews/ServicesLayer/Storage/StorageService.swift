//
//  StorageService.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IStorageService {
    func getViewsCounts(page: Int, completion: @escaping ([String: Int]?, String?) -> ())
    
    func isEmpty(for page: Int) -> Bool
    
    func saveNewsFeed(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ()))
    func saveNewsFeedItem(_ newsFeedItem: FeedItem, completion: @escaping ((String?) -> ()))
    func saveNewsPost(_ newsPost: PostItem, completion: @escaping (String?) -> ())
}

class StorageService: IFeedService, IPostService, IStorageService {
    
    // MARK: - Dependency
    
    private let storageManager: IStorageManager
    
    // MARK: - Initializer
    
    init(storageManager: IStorageManager) {
        self.storageManager = storageManager
    }
    
    // MARK: - IFeedService
    
    func getNewsFeed(page: Int, completion: @escaping ([FeedItem]?, String?) -> ()) {
        storageManager.fetchNewsFeed(offset: calculateOffset(from: page), completion: completion)
    }
    
    // MARK: - IPostService
    
    func getNewsPost(id: String, completion: @escaping (PostItem?, String?) -> ()) {
        storageManager.fetchNewsPost(id: id, completion: completion)
    }
    
    // MARK: - IStorageService
    
    func getViewsCounts(page: Int, completion: @escaping ([String: Int]?, String?) -> ()) {
        storageManager.fetchViewCounts(offset: calculateOffset(from: page), completion: completion)
    }
    
    func isEmpty(for page: Int) -> Bool {
        return storageManager.isEmpty(offset: calculateOffset(from: page))
    }
    
    func saveNewsFeedItem(_ newsFeedItem: FeedItem, completion: @escaping ((String?) -> ())) {
        storageManager.saveItem(newsFeedItem, completion: completion)
    }
    
    func saveNewsFeed(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ())) {
        storageManager.saveNewsFeed(newsFeed, completion: completion)
    }
    
    func saveNewsPost(_ newsPost: PostItem, completion: @escaping (String?) -> ()) {
        storageManager.saveItem(newsPost, completion: completion)
    }
    
    // MARK: - Private methods
    
    private func calculateOffset(from page: Int) -> Int {
        return (page - 1) * 20
    }

}
