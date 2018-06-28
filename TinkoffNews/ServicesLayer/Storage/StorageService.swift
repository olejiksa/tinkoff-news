//
//  StorageService.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IStorageService {
    func isEmpty(for page: Int) -> Bool
    
    func saveNews(_ model: FeedItem, completion: @escaping ((String?) -> ()))
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ()))
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
        //
    }
    
    // MARK: - IStorageService
    
    func isEmpty(for page: Int) -> Bool {
        return storageManager.isEmpty(offset: (page - 1) * 20)
    }
    
    func saveNews(_ model: FeedItem, completion: @escaping ((String?) -> ())) {
        storageManager.saveNews(model, completion: completion)
    }
    
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping ((String?) -> ())) {
        storageManager.saveNews(newsFeed, completion: completion)
    }
    
}
