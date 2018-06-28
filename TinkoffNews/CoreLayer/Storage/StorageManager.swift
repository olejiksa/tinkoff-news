//
//  StorageManager.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol IStorageManager {
    func isEmpty(offset: Int) -> Bool
    
    func fetchViewCounts(offset: Int, completion: @escaping ([String: Int]?, String?) -> ())
    func fetchNewsFeed(offset: Int, completion: @escaping ([FeedItem]?, String?) -> ())
    func saveNewsFeed(_ newsFeed: [FeedItem], completion: @escaping (String?) -> ())
    func saveItem(_ item: FeedItem, completion: @escaping (String?) -> ())
}

class StorageManager: IStorageManager {
    
    // MARK: - Dependency
    
    private let coreDataStack: ICoreDataStack
    
    // MARK: - Initializer
    
    init(coreDataStack: ICoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    // MARK: - IStorageManager
    
    func isEmpty(offset: Int) -> Bool {
        var result = false
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(News.self)")
        fetchRequest.fetchLimit = 20
        fetchRequest.fetchOffset = offset
        
        do {
            result = try coreDataStack.mainContext.count(for: fetchRequest) == 0
        } catch {
            result = true
        }
        
        return result
    }
    
    func fetchViewCounts(offset: Int, completion: @escaping ([String: Int]?, String?) -> ()) {
        coreDataStack.mainContext.perform {
            var newsFeed = [String: Int]()
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "\(News.self)")
            fetchRequest.fetchLimit = 20
            fetchRequest.fetchOffset = offset
            fetchRequest.propertiesToFetch = ["id", "viewsCount"]
            fetchRequest.resultType = .dictionaryResultType
            
            do {
                let result = try self.coreDataStack.mainContext.fetch(fetchRequest) as? [[String: Any]]
                guard let dictionary = result else {
                    completion(nil, "Cannot cast fetch request result to dictionary")
                    return
                }
                
                for item in dictionary {
                    let id = item["id"] as! String
                    let viewsCount = item["viewsCount"] as! Int
                    
                    newsFeed[id] = viewsCount
                }
            } catch {
                completion(nil, error.localizedDescription)
                return
            }
            
            completion(newsFeed, nil)
        }
    }
    
    func fetchNewsFeed(offset: Int, completion: @escaping ([FeedItem]?, String?) -> ()) {
        coreDataStack.mainContext.perform {
            var newsFeed = [News]()
            
            let fetchRequest = NSFetchRequest<News>(entityName: "\(News.self)")
            fetchRequest.fetchLimit = 20
            fetchRequest.fetchOffset = offset
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            do {
                newsFeed = try self.coreDataStack.mainContext.fetch(fetchRequest)
            } catch {
                completion(nil, error.localizedDescription)
                return
            }
            
            var models = [FeedItem]()
            for cachedNews in newsFeed {
                if let model = News.map(from: cachedNews) {
                    models.append(model)
                }
            }
            
            completion(models, nil)
        }
    }
    
    func saveNewsFeed(_ newsFeed: [FeedItem], completion: @escaping (String?) -> ()) {
        coreDataStack.saveContext.perform {
            for model in newsFeed {
                News.findOrInsert(model, in: self.coreDataStack.saveContext)
            }
            
            self.performSave(in: self.coreDataStack.saveContext, completion: completion)
        }
    }
    
    func saveItem(_ model: FeedItem, completion: @escaping (String?) -> ()) {
        coreDataStack.saveContext.perform {
            News.findOrInsert(model, in: self.coreDataStack.saveContext)
            
            self.performSave(in: self.coreDataStack.saveContext, completion: completion)
        }
    }
    
    // MARK: - Private methods
    
    private func performSave(in context: NSManagedObjectContext, completion: @escaping (String?) -> ()) {
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                } catch {
                    print("Context save error: \(error)")
                    completion(error.localizedDescription)
                }
                
                if let parent = context.parent {
                    self?.performSave(in: parent, completion: completion)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
}
