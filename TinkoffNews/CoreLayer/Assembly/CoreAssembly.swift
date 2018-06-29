//
//  CoreAssembly.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

protocol ICoreAssembly {
    var requestSender: IRequestSender { get }
    var storageManager: IStorageManager { get }
}

class CoreAssembly: ICoreAssembly {
    private lazy var coreDataStack: ICoreDataStack = CoreDataStack(resourseName: "TinkoffNews")
    
    lazy var requestSender: IRequestSender = RequestSender()
    lazy var storageManager: IStorageManager = StorageManager(coreDataStack: coreDataStack)
}
