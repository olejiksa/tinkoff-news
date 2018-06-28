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

extension FeedItem: IReverseMappable {
    typealias T1 = FeedItem
    typealias T2 = News
    
    static func map(from model: T1, to entity: T2) {
        entity.id = model.id
        entity.name = model.text
        entity.viewsCount = Int16(model.viewsCount)
        entity.date = Date(timeIntervalSince1970: TimeInterval(model.publicationDate.milliseconds / 1000))
        //entity.content = model.content
    }
}

struct PublicationDate: Codable {
    let milliseconds: Int
}
