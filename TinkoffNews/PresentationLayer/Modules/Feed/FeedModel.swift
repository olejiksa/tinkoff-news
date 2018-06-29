//
//  FeedModel.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol IFeedModel {
    var data: [FeedItem] { get set }
    
    func getNewsFeed(page: Int, mergePolicy: FeedMergePolicy,
                     manually: Bool, completion: @escaping ([FeedItem]?, String?, Bool) -> ())
    func saveFeedItem(index: Int, completion: @escaping ((String?) -> ()))
    func saveNews(completion: @escaping ((String?) -> ()))
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
    
    private var useCache: Bool = true
    var data = [FeedItem]()
    
    func getNewsFeed(page: Int, mergePolicy: FeedMergePolicy,
                     manually: Bool, completion: @escaping ([FeedItem]?, String?, Bool) -> ()) {
        /* Проверка наличия новостей в кэше для соответствующей "страницы"
           и выбор подходящего сервиса */
        let service: IFeedService
        
        if manually {
            useCache = false
            service = feedService
        } else {
            if !useCache {
                service = feedService
            } else {
                service = storageService.isEmpty(for: page) ? feedService : storageService
            }
        }
        
        service.getNewsFeed(page: page) { [unowned self] newsItems, error in
            guard var newsItems = newsItems else {
                completion(nil, error, false)
                
                /* В случае неудачи получить данные из кэша,
                   если обновление было вызвано через pull to refresh */
                if manually {
                    self.useCache = true
                    self.getNewsFeed(page: page, mergePolicy: mergePolicy, manually: false, completion: completion)
                }
                
                return
            }
            
            if !self.useCache {
                // Получение данных из кэша для сравнения с данными из сети
                self.storageService.getViewsCounts(page: page) { [unowned self] viewsCounts, error in
                    guard let viewsCounts = viewsCounts else {
                        completion(nil, error, false)
                        return
                    }
                    
                    // Синхронизация счетчиков просмотров
                    for i in 0..<newsItems.count {
                        for oldItem in viewsCounts {
                            if newsItems[i].id == oldItem.key {
                                newsItems[i].viewsCount += oldItem.value
                            }
                        }
                    }
                    
                    self.completeFetching(service: service, newsItems: newsItems,
                                     mergePolicy: mergePolicy, completion: completion)
                }
            } else {
                self.completeFetching(service: service, newsItems: newsItems,
                                 mergePolicy: mergePolicy, completion: completion)
            }
        }
    }
    
    func saveFeedItem(index: Int, completion: @escaping ((String?) -> ())) {
        storageService.saveFeedItem(data[index], completion: completion)
    }
    
    func saveNews(completion: @escaping ((String?) -> ())) {
        storageService.saveNews(data, completion: completion)
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
