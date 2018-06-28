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
    
    func fetchNewsFeed(offset: Int, completion: @escaping ([FeedItem]?, String?) -> ())
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping (String?) -> ())
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
        
        do {
            let fetchRequest = NSFetchRequest<News>(entityName: "News")
            fetchRequest.fetchLimit = 20
            fetchRequest.fetchOffset = offset
            
            result = try coreDataStack.mainContext.count(for: fetchRequest) == 0
        } catch {
            result = true
        }
        
        return result
    }
    
    func fetchNewsFeed(offset: Int, completion: @escaping ([FeedItem]?, String?) -> ()) {
        coreDataStack.mainContext.perform {
            var newsFeed = [News]()
            
            let fetchRequest = NSFetchRequest<News>(entityName: "News")
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
    
    func saveNews(_ newsFeed: [FeedItem], completion: @escaping (String?) -> ()) {
        coreDataStack.saveContext.perform {
            for model in newsFeed {
                if let cachedNews = self.find(by: model.id, in: self.coreDataStack.saveContext) {
                    FeedItem.map(from: model, to: cachedNews)
                } else if let entity = NSEntityDescription.entity(forEntityName: "News", in: self.coreDataStack.saveContext), let cachedNews = NSManagedObject(entity: entity, insertInto: self.coreDataStack.saveContext) as? News {
                    FeedItem.map(from: model, to: cachedNews)
                }
            }
            
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
    
    private func find(by id: String, in context: NSManagedObjectContext) -> News? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id as CVarArg)
        
        do {
            if let news = try context.fetch(fetchRequest).first as? News {
                return news
            }
        } catch {
            print("Could not save. \(error)")
        }
        
        return nil
    }
    
}
