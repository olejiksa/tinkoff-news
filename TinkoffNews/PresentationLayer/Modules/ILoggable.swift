//
//  ILoggable.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 30/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

protocol ILoggable {
    var delegate: UIViewController? { get set }
    func logMessage(for error: String)
}
