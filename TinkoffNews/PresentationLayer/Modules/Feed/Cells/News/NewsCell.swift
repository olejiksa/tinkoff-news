//
//  NewsCell.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 28/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var viewsCountLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var date: Date? {
        didSet {
            guard let date = date else {
                dateLabel.text = String()
                return
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, d MMM yyyy, h:mm"
            
            dateLabel.text = dateFormatter.string(from: date)
        }
    }
    
    var viewsCount = 0 {
        didSet {
            viewsCountLabel.text = String(viewsCount)
        }
    }
    
}
