//
//  PostItem.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

struct PostItem: Codable, Mappable {
    
    // MARK: - Codable
    
    let title: Title
    let content: String
    
    // MARK: - Mappable
    
    var id: String {
        return title.id
    }
    
    func map(to entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        entity.setValue(content, forKey: "content")
    }
    
}

struct Title: Codable {
    let id: String
}
