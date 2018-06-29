//
//  PostModel.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol IPostModel {
    var postTitle: String { get }
    var postDate: String { get }
    
    var postItem: PostItem? { get set }
    
    func getNewsPost(useCache: Bool, completion: @escaping (NSAttributedString?, String?) -> ())
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
    
    func getNewsPost(useCache: Bool, completion: @escaping (NSAttributedString?, String?) -> ()) {
        let service = useCache ? storageService : postService
        
        service.getNewsPost(id: newsItem.id) { postItem, error in
            guard let post = postItem else {
                if !useCache {
                    // При неудаче получить текст новости из сети
                    self.getNewsPost(useCache: true, completion: completion)
                    return
                }
                
                completion(nil, error)
                return
            }
            
            self.postItem = postItem
            
            guard let htmlData = NSString(string: post.content).data(using: String.Encoding.unicode.rawValue),
                let htmlText = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
                    completion(nil, "HTML cannot be parsed into NSAttributedString.")
                    return
            }
            
            let font = UIFont.preferredFont(forTextStyle: .body)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSMutableAttributedString(string: htmlText.string, attributes: attributes)
            
            // Возвращается в случае успеха очищенный от HTML-тегов текст
            completion(attributedText, nil)
        }
    }
    
    func saveNewsPost(completion: @escaping ((String?) -> ())) {
        guard let post = postItem else { return }
        storageService.saveNewsPost(post, completion: completion)
    }
    
}
