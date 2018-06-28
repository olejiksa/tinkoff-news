//
//  Date+Milliseconds.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

extension Date {
    
    static func create(from milliseconds: Int) -> Date? {
        return Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    func milliseconds() -> Int {
        return Int(self.timeIntervalSince1970 * 1000)
    }
    
}
