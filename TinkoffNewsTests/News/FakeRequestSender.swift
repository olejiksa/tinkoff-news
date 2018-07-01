//
//  FakeRequestSender.swift
//  TinkoffNewsTests
//
//  Created by Oleg Samoylov on 01/07/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation
@testable import TinkoffNews

protocol Nameable {
    var resourseName: String? { get set }
}

class FakeRequestSender: IRequestSender, Nameable {
    var resourseName: String?
    
    func send<Parser>(config: RequestConfig<Parser>, completion: @escaping (Result<Parser.Model>) -> ()) where Parser: IParser {
        guard let resouseName = resourseName else {
            completion(.error("Resource name is nil."))
            return
        }
        
        if let path = Bundle(for: type(of: self)).path(forResource: resouseName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                    completion(.error("Received data cannot be parsed."))
                    return
                }
                
                completion(.success(parsedModel))
            } catch {
                completion(.error(error.localizedDescription))
            }
        } else {
            completion(.error("Not found: \(resouseName)"))
        }
    }
}
