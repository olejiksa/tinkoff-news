//
//  PostModel.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol IPostModel {
    var postTitle: String { get }
    var postDate: String { get }
    
    var postItem: PostItem? { get set }
    
    func getNewsPost(usingCache: Bool, completion: @escaping (NSAttributedString?, String?) -> ())
    func saveNewsPost(completion: @escaping ((String?) -> ()))
}

class PostModel: IPostModel {
    
    // MARK: - Dependencies
    
    private let newsItem: FeedItem
    private let postService: IPostService
    private let storageService: IPostService & IStorageService
    
    // MARK: - Initializer
    
    init(newsItem: FeedItem, postService: IPostService, storageService: IPostService & IStorageService) {
        self.newsItem = newsItem
        self.postService = postService
        self.storageService = storageService
    }
    
    // MARK: - IPostModel
    
    var postTitle: String {
        guard let title = newsItem.title else { return String() }
        return title
    }
    
    var postDate: String {
        let time = newsItem.publicationDate.milliseconds
        let date = Date(timeIntervalSince1970: TimeInterval(time / 1000))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        
        return dateFormatter.string(from: date)
    }
    
    var postItem: PostItem?
    
    func getNewsPost(usingCache: Bool, completion: @escaping (NSAttributedString?, String?) -> ()) {
        let service = usingCache ? storageService : postService
        
        service.getNewsPost(id: newsItem.id) { [weak self] postItem, error in
            guard let post = postItem else {
                if !usingCache {
                    self?.getNewsPost(usingCache: true, completion: completion)
                    return
                }
                
                completion(nil, error)
                return
            }
            
            self?.postItem = postItem
            guard let parsedString = String(htmlEncodedString: post.content) else {
                completion(nil, "HTML cannot be parsed into NSAttributedString.")
                return
            }
            
            let font = UIFont.preferredFont(forTextStyle: .body)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSMutableAttributedString(string: parsedString, attributes: attributes)
            
            completion(attributedText, nil)
        }
    }
    
    func saveNewsPost(completion: @escaping ((String?) -> ())) {
        guard let post = postItem else { return }
        storageService.saveNewsPost(post, completion: completion)
    }
    
}
