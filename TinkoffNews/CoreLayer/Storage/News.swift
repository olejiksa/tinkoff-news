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
                  publicationDate: PublicationDate(milliseconds: Int(date.timeIntervalSince1970 * 1000)), viewsCount: Int(managedObject.viewsCount))
    }
    
}
