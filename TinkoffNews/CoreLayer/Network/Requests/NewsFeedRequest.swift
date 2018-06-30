//
//  NewsFeedRequest.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

class NewsFeedRequest: NewsRequest {
    
    init(first: Int, last: Int) {
        super.init(endpoint: "\(RequestFactory.endpointRoot)news",
            parameters: ["first": first, "last": last])
    }
    
}
