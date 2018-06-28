//
//  News.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

extension News: IMappable {
    
    typealias T1 = News
    typealias T2 = FeedItem
    
    @nonobjc static func map(from managedObject: T1) -> T2? {
        guard let id = managedObject.id,
              let name = managedObject.name,
              let date = managedObject.date else { return nil }
        
        return T2(id: id,
                  text: name,
                  publicationDate: PublicationDate(milliseconds: date.milliseconds()),
                  viewsCount: Int(managedObject.viewsCount))
    }
    
    @nonobjc static func findOrInsert(_ model: FeedItem, in context: NSManagedObjectContext) {
        if let cachedNews = News.find(by: model.id, in: context) {
            FeedItem.map(from: model, to: cachedNews)
        } else {
            if let entity = NSEntityDescription.entity(forEntityName: "\(News.self)", in: context),
               let cachedNews = NSManagedObject(entity: entity, insertInto: context) as? News {
                FeedItem.map(from: model, to: cachedNews)
            }
        }
    }
    
    @nonobjc private static func find(by id: String, in context: NSManagedObjectContext) -> News? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "\(News.self)")
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
    
    @nonobjc private static func insert(model: FeedItem, in context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "\(News.self)", in: context),
           let cachedNews = NSManagedObject(entity: entity, insertInto: context) as? News {
            FeedItem.map(from: model, to: cachedNews)
        }
    }
    
}
