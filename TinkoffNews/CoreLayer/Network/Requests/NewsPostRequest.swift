//
//  NewsPostRequest.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 26/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

class NewsPostRequest: IRequest {
    
    private let endpoint = "https://api.tinkoff.ru/v1/news_content"
    
    private var parameters: [String: String]
    
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
    
    init(id: String) {
        parameters = [String: String]()
        
        parameters["id"] = id
    }
    
}
