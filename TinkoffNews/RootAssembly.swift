//
//  RootAssembly.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

class RootAssembly {
    lazy var presentationAssembly: IPresentationAssembly = PresentationAssembly(servicesAssembly: servicesAssembly)
    private lazy var servicesAssembly: IServicesAssembly = ServicesAssembly(coreAssembly: coreAssembly)
    private lazy var coreAssembly: ICoreAssembly = CoreAssembly()
}
