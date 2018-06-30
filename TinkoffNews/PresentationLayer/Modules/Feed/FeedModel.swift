//
//  FeedModel.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IFeedModel {
    var data: [FeedItem] { get set }
    
    func getNewsFeed(page: Int, mergePolicy: FeedMergePolicy,
                     usingCache: Bool, completion: @escaping ([FeedItem]?, String?, Bool) -> ())
    func saveNewsFeed(completion: @escaping ((String?) -> ()))
    func saveNewsFeedItem(by index: Int, completion: @escaping ((String?) -> ()))
}

class FeedModel: IFeedModel {
    
    // MARK: - Dependencies
    
    private let feedService: IFeedService
    private let storageService: IFeedService & IStorageService
    
    // MARK: - Initializer
    
    init(feedService: IFeedService, storageService: IFeedService & IStorageService) {
        self.feedService = feedService
        self.storageService = storageService
    }
    
    // MARK: - IFeedModel
    
    var data = [FeedItem]()
    
    func getNewsFeed(page: Int, mergePolicy: FeedMergePolicy,
                     usingCache: Bool, completion: @escaping ([FeedItem]?, String?, Bool) -> ()) {
        let service = !usingCache || storageService.isEmpty(for: page) ? feedService : storageService
        
        service.getNewsFeed(page: page) { [weak self] newsItems, error in
            guard var newsItems = newsItems else {
                completion(nil, error, false)
                
                /* В случае неудачи получить данные из кэша,
                   если обновление было вызвано через pull to refresh */
                if !usingCache && mergePolicy == .overwrite {
                    self?.getNewsFeed(page: page, mergePolicy: mergePolicy, usingCache: true, completion: completion)
                }
                
                return
            }
            
            if !usingCache {
                // Получение данных из кэша для сравнения с данными из сети
                self?.storageService.getViewsCounts(page: page) { [weak self] viewsCounts, error in
                    guard let viewsCounts = viewsCounts else {
                        completion(nil, error, false)
                        return
                    }
                    
                    // Синхронизация счетчиков просмотров
                    for i in 0..<newsItems.count {
                        newsItems[i].viewsCount += viewsCounts[newsItems[i].id]!
                    }
                    
                    self?.completeFetching(service: service, newsItems: newsItems,
                                     mergePolicy: mergePolicy, completion: completion)
                }
            } else {
                self?.completeFetching(service: service, newsItems: newsItems,
                                 mergePolicy: mergePolicy, completion: completion)
            }
        }
    }
    
    func saveNewsFeed(completion: @escaping ((String?) -> ())) {
        storageService.saveNewsFeed(data, completion: completion)
    }
    
    func saveNewsFeedItem(by index: Int, completion: @escaping ((String?) -> ())) {
        storageService.saveNewsFeedItem(data[index], completion: completion)
    }
    
    // MARK: - Private methods
    
    func completeFetching(service: IFeedService,
                          newsItems: [FeedItem],
                          mergePolicy: FeedMergePolicy,
                          completion: @escaping ([FeedItem]?, String?, Bool) -> ()) {
        switch mergePolicy {
        case .overwrite:
            self.data = newsItems
        case .append:
            self.data += newsItems
        }
        
        /* Возвращаются новости, ошибка (если есть) и флаг необходимости сохранения
           Уже закэшированные новости не подлежат повторному добавлению в кэш */
        completion(newsItems, nil, !(service is IStorageService))
    }
    
}
