//
//  NewsService.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

class NewsService: IFeedService, IPostService {
    
    // MARK: - Dependency
    
    private let requestSender: IRequestSender
    
    // MARK: - Initializer
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    // MARK: - IFeedService
    
    func getNewsFeed(page: Int, completion: @escaping ([FeedItem]?, String?) -> ()) {
        guard page > 0 && page < (.max / 20) + 1 else {
            completion(nil, "Index out of bounds")
            return
        }
        
        let requestConfig = RequestFactory.getNewsFeed(first: calculateOffset(from: page),
                                                       last: 20 * page)
        
        requestSender.send(config: requestConfig) { (result: Result<[FeedItem]>) in
            switch result {
            case .success(let news):
                completion(news, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: - IPostService
    
    func getNewsPost(id: String, completion: @escaping (PostItem?, String?) -> ()) {
        let requestConfig = RequestFactory.getNewsPost(id: id)
        
        requestSender.send(config: requestConfig) { (result: Result<PostItem>) in
            switch result {
            case .success(let post):
                completion(post, nil)
            case .error(let error):
                completion(nil, error)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func calculateOffset(from page: Int) -> Int {
        return (page - 1) * 20
    }
    
}
