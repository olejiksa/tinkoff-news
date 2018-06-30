//
//  PresentationAssembly.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IPresentationAssembly {
    var logger: ILoggable { get }
    
    func feedViewController() -> FeedViewController
    func postViewController(newsItem: FeedItem) -> PostViewController
}

class PresentationAssembly: IPresentationAssembly {
    
    // MARK: - Dependency
    
    private let servicesAssembly: IServicesAssembly
    
    // MARK: - Initializer
    
    init(servicesAssembly: IServicesAssembly) {
        self.servicesAssembly = servicesAssembly
    }
    
    // MARK: - ILoggable
    
    lazy var logger: ILoggable = AlertLogger()
    
    // MARK: - FeedViewController
    
    func feedViewController() -> FeedViewController {
        let feedModel: IFeedModel = FeedModel(feedService: servicesAssembly.feedService,
                                              storageService: servicesAssembly.storageService)
        return FeedViewController(model: feedModel, logger: logger, presentationAssembly: self)
    }
    
    // MARK: - PostViewController
    
    func postViewController(newsItem: FeedItem) -> PostViewController {
        let postModel: IPostModel = PostModel(newsItem: newsItem,
                                              postService: servicesAssembly.postService,
                                              storageService: servicesAssembly.storageService)
        return PostViewController(model: postModel, logger: logger)
    }
    
}
