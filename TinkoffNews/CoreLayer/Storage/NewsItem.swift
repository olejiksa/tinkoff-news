//
//  NewsItem.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 29/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

class NewsItem {
    let id: String
    var name: String?
    var date: Date?
    var viewsCount = 0
    var content: String?
    
    init(id: String, name: String, date: Date?, viewsCount: Int) {
        self.id = id
        self.name = String(htmlEncodedString: name)
        self.date = date
        self.viewsCount = viewsCount
    }
    
    init(id: String, content: String) {
        self.id = id
        self.content = String(htmlEncodedString: content)
    }
    
    func map(to entity: News, as type: NewsItemType) {
        switch type {
        case .feed:
            entity.id = id
            entity.name = name
            entity.date = date
            entity.viewsCount = Int16(viewsCount)
        case .post:
            entity.id = id
            entity.content = content
        }
    }
}
