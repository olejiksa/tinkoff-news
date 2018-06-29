//
//  StorageService.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IStorageService {
    func getViewsCounts(page: Int, completion: @escaping ([String: Int]?, String?) -> ())
    
    func isEmpty(for page: Int) -> Bool
    
    func saveFeedItem(_ model: FeedItem, completion: @escaping ((String?) -> ()))
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ()))
    func saveNewsPost(_ post: PostItem, completion: @escaping (String?) -> ())
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
        storageManager.fetchNewsFeed(offset: (page - 1) * 20, completion: completion)
    }
    
    // MARK: - IPostService
    
    func getNewsPost(id: String, completion: @escaping (PostItem?, String?) -> ()) {
        storageManager.fetchNewsPost(id: id, completion: completion)
    }
    
    // MARK: - IStorageService
    
    func getViewsCounts(page: Int, completion: @escaping ([String: Int]?, String?) -> ()) {
        storageManager.fetchViewCounts(offset: (page - 1) * 20, completion: completion)
    }
    
    func isEmpty(for page: Int) -> Bool {
        return storageManager.isEmpty(offset: (page - 1) * 20)
    }
    
    func saveFeedItem(_ model: FeedItem, completion: @escaping ((String?) -> ())) {
        storageManager.saveItem(model, completion: completion)
    }
    
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ())) {
        storageManager.saveNewsFeed(newsFeed, completion: completion)
    }
    
    func saveNewsPost(_ post: PostItem, completion: @escaping (String?) -> ()) {
        storageManager.saveItem(post, completion: completion)
    }

}
