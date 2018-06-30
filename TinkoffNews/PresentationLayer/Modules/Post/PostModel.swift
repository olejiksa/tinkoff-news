//
//  PostModel.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol IPostModel {
    var postHeader: (title: String, date: String) { get }
    
    func getNewsPost(usingCache: Bool, completion: @escaping (PostItem?, NSAttributedString?, String?) -> ())
    func saveNewsPost(_ newsPost: PostItem, completion: @escaping ((String?) -> ()))
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
    
    var postHeader: (title: String, date: String) {
        let timeInMilliseconds = newsItem.publicationDate.milliseconds
        let postDate = Date(timeIntervalSince1970: TimeInterval(timeInMilliseconds / 1000))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy"
        let postDateString = dateFormatter.string(from: postDate)
        
        guard let postTitle = newsItem.title else { return (String(), postDateString) }
        return (postTitle, dateFormatter.string(from: postDate))
    }
    
    func getNewsPost(usingCache: Bool, completion: @escaping (PostItem?, NSAttributedString?, String?) -> ()) {
        let service = usingCache ? storageService : postService
        
        service.getNewsPost(id: newsItem.id) { [weak self] postItem, error in
            guard let post = postItem else {
                if !usingCache {
                    self?.getNewsPost(usingCache: true, completion: completion)
                    return
                }
                
                completion(nil, nil, error)
                return
            }
            
            guard let parsedString = String(htmlEncodedString: post.content) else {
                completion(postItem, nil, "HTML cannot be parsed into NSAttributedString.")
                return
            }
            
            let font = UIFont.preferredFont(forTextStyle: .body)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSMutableAttributedString(string: parsedString, attributes: attributes)
            
            completion(postItem, attributedText, nil)
        }
    }
    
    func saveNewsPost(_ newsPost: PostItem, completion: @escaping ((String?) -> ())) {
        storageService.saveNewsPost(newsPost, completion: completion)
    }
    
}
