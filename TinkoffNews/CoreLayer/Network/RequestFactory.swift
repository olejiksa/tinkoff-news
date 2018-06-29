//
//  RequestFactory.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

struct RequestFactory {
    
    static func getNewsFeed(first: Int, last: Int) -> RequestConfig<NewsFeedParser> {
        let request = NewsFeedRequest(first: first, last: last)
        let parser = NewsFeedParser()
        
        return RequestConfig<NewsFeedParser>(request: request, parser: parser)
    }
    
    static func getNewsPost(id: String) -> RequestConfig<NewsPostParser> {
        let request = NewsPostRequest(id: id)
        let parser = NewsPostParser()
        
        return RequestConfig<NewsPostParser>(request: request, parser: parser)
    }
    
}
