//
//  FeedItem.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

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
    func map(to entity: News) {
        entity.id = id
        entity.name = text
        entity.viewsCount = Int16(viewsCount)
        entity.date = Date.create(from: publicationDate.milliseconds)
    }
}

struct PublicationDate: Codable {
    let milliseconds: Int
}
