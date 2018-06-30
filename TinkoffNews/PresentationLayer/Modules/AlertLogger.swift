//
//  AlertLogger.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 30/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

class AlertLogger: ILoggable {
    
    weak var delegate: UIViewController?
    
    func logMessage(for error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        delegate?.present(alert, animated: true)
    }
    
}
