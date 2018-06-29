//
//  AppDelegate.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let rootAssembly = RootAssembly()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let controller = rootAssembly.presentationAssembly.feedViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }

}

