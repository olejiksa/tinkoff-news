//
//  NewsFeedRequest.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

class NewsFeedRequest: IRequest {
    
    private let endpoint = "https://api.tinkoff.ru/v1/news"
    
    private var parameters: [String: Int]
    
    private var urlString: String {
        var formingString = String()
        
        for pair in parameters {
            formingString.append("\(pair.key)=\(pair.value)&")
        }
        
        return String("\(endpoint)?\(formingString.dropLast())")
    }
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    init(first: Int, last: Int) {
        parameters = [String: Int]()
        
        parameters["first"] = first
        parameters["last"] = last
    }
    
}
