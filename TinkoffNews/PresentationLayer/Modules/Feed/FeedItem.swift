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
}

extension FeedItem: IReverseMappable {
    typealias T1 = FeedItem
    typealias T2 = News
    
    static func map(from model: T1, to entity: T2) {
        entity.id = model.id
        entity.name = model.text
        entity.date = Date(timeIntervalSince1970: TimeInterval(model.publicationDate.milliseconds / 1000))
        //entity.content = model.content
        //entity.numberOfViews = Int32(model.numberOfView)
    }
}

struct PublicationDate: Codable {
    let milliseconds: Int
}
