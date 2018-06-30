//
//  NewsPostRequest.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 26/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

class NewsPostRequest: NewsRequest {
    
    init(id: String) {
        super.init(endpoint: "\(RequestFactory.endpointRoot)news_content",
            parameters: ["id": id])
    }
    
}
