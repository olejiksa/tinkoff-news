//
//  Mappable.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol Mappable {
    var id: String { get }
    func map(to entity: NSManagedObject)
}
