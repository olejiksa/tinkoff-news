//
//  FeedItem.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation
import CoreData

struct FeedItem: Codable {
    let id: String
    let text: String
    let publicationDate: PublicationDate
    
    // Decoded news title
    var title: String? { return String(htmlEncodedString: text) }
    
    // Number of views
    var viewsCount = 0

    private enum CodingKeys: String, CodingKey {
        case id
        case text
        case publicationDate
    }
}

extension FeedItem: IMappable {
    func map(to entity: NSManagedObject) {
        entity.setValue(id, forKey: "id")
        entity.setValue(text, forKey: "name")
        entity.setValue(Int16(viewsCount), forKey: "viewsCount")
        entity.setValue(Date.create(from: publicationDate.milliseconds), forKey: "date")
    }
}

struct PublicationDate: Codable {
    let milliseconds: Int
}
