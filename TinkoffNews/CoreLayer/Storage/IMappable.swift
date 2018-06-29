//
//  IMappable.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol IMappable {
    associatedtype T where T: NSManagedObject
    func map(to entity: T)
}
