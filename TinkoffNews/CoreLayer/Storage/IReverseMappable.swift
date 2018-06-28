//
//  IReverseMappable.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol IReverseMappable {
    associatedtype T1
    associatedtype T2: NSManagedObject
    
    static func map(from model: T1, to entity: T2)
}
