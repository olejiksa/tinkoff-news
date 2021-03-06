//
//  RequestSender.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(String)
}

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> ())
}

class RequestSender: IRequestSender {
    
    private let session = URLSession(configuration: .default)
    
    func send<Parser>(config: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> ()) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completion(.error("URL string cannot be parsed to URL."))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(.error(error.localizedDescription))
                return
            }
            
            guard let data = data, let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completion(.error("Received data cannot be parsed."))
                return
            }
            
            completion(.success(parsedModel))
        }
        
        task.resume()
    }
    
}
