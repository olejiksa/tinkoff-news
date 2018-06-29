//
//  News.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

extension News {
    
    @nonobjc static func findOrInsert(_ model: IMappable, in context: NSManagedObjectContext) {
        if let cachedNews = News.find(by: model.id, in: context) {
            model.map(to: cachedNews)
        } else {
            if let entity = NSEntityDescription.entity(forEntityName: "\(News.self)", in: context),
               let cachedNews = NSManagedObject(entity: entity, insertInto: context) as? News {
                model.map(to: cachedNews)
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
    
}
