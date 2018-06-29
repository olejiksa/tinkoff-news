//
//  NewsPostParser.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 26/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

struct NewsPostResponse: Codable {
    let payload: PostItem
}

class NewsPostParser: IParser {
    func parse(data: Data) -> PostItem? {
        do {
            return try JSONDecoder().decode(NewsPostResponse.self, from: data).payload
        } catch  {
            print("Error trying to convert data to JSON")
            return nil
        }
    }
}
