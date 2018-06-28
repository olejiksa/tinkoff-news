//
//  PostModel.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol IPostModel {
    var postId: String { get }
    
    func getNewsPost(id: String, completion: @escaping (NSAttributedString?, String?) -> ())
}

class PostModel: IPostModel {
    
    // MARK: - Dependency
    
    private let newsItem: FeedItem
    private let postService: IPostService
    
    // MARK: - Initializer
    
    init(newsItem: FeedItem, postService: IPostService) {
        self.newsItem = newsItem
        self.postService = postService
    }
    
    // MARK: - IPostModel
    
    var postId: String {
        return newsItem.id
    }
    
    func getNewsPost(id: String, completion: @escaping (NSAttributedString?, String?) -> ()) {
        postService.getNewsPost(id: id) { postItem, error in
            guard let post = postItem else {
                completion(nil, error)
                return
            }
            
            guard let htmlData = NSString(string: post.content).data(using: String.Encoding.unicode.rawValue),
                  let htmlText = try? NSAttributedString(data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) else {
                    completion(nil, "HTML cannot be parsed into NSAttributedString.")
                    return
            }
            
            let font = UIFont.preferredFont(forTextStyle: .body)
            let attributes = [NSAttributedStringKey.font: font]
            let attributedText = NSMutableAttributedString(string: htmlText.string, attributes: attributes)
            
           completion(attributedText, nil)
        }
    }
    
}
