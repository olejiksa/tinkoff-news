//
//  IMappable.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import CoreData

protocol IMappable {
    var id: String { get }
    func map(to entity: NSManagedObject)
}
