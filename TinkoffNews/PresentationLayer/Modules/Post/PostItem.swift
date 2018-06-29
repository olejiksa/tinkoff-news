//
//  PostItem.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

struct PostItem: Codable {
    let title: Title
    let content: String
}

extension PostItem: IMappable {
    typealias T = News
    
    func map(to entity: T) {
        entity.id = title.id
        entity.content = content
    }
}

struct Title: Codable {
    let id: String
}
