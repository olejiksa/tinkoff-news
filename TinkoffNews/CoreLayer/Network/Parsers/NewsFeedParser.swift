//
//  NewsFeedParser.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

struct NewsFeedResponse: Codable {
    let payload: [FeedItem]
}

class NewsFeedParser: IParser {
    typealias Model = [FeedItem]
    
    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(NewsFeedResponse.self, from: data).payload
        } catch  {
            print("Error trying to convert data to JSON")
            return nil
        }
    }
}
