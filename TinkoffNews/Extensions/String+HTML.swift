//
//  String+HTML.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

extension String {
    
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }
        
        self.init(attributedString.string)
    }
    
}
