//
//  NewsRequest.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 30/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

class NewsRequest: IRequest {
    
    // MARK: - Dependencies
    
    private let endpoint: String
    private let parameters: [String: Any]
    
    // MARK: - Initializer
    
    init(endpoint: String, parameters: [String: Any]) {
        self.endpoint = endpoint
        self.parameters = parameters
    }
    
    // MARK: - IRequest
    
    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    private var urlString: String {
        var formingString = String()
        
        for pair in parameters {
            formingString.append("\(pair.key)=\(pair.value)&")
        }
        
        return String("\(endpoint)?\(formingString.dropLast())")
    }
    
}
