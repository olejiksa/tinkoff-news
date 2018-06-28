//
//  NewsPostParser.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 26/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

struct NewsPostResponse: Codable {
    //let resultCode: String
    let payload: PostItem
    //let trackingId: Int
}

class NewsPostParser: IParser {
    typealias Model = PostItem
    
    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(NewsPostResponse.self, from: data).payload
        } catch  {
            print("Error trying to convert data to JSON")
            return nil
        }
    }
}
