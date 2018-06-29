//
//  ServicesAssembly.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

typealias IComplexStorageService = IFeedService & IPostService & IStorageService

protocol IServicesAssembly {
    var feedService: IFeedService { get }
    var postService: IPostService { get }
    var storageService: IComplexStorageService { get }
}

class ServicesAssembly: IServicesAssembly {
    
    // MARK: - Dependency
    
    private let coreAssembly: ICoreAssembly
    
    // MARK: - Initializer
    
    init(coreAssembly: ICoreAssembly) {
        self.coreAssembly = coreAssembly
    }
    
    // MARK: - IServicesAssembly
 
    private lazy var newsService = NewsService(requestSender: coreAssembly.requestSender)
    
    lazy var feedService: IFeedService = newsService
    lazy var postService: IPostService = newsService
    lazy var storageService: IComplexStorageService = StorageService(storageManager: coreAssembly.storageManager)
    
}
