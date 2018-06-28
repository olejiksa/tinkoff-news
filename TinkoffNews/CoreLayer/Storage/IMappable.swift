//
//  IMappable.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 27/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol IMappable: class {
    associatedtype T1: NSManagedObject
    associatedtype T2
    
    static func map(from managedObject: T1) -> T2?
}
