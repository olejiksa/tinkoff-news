//
//  PostViewController.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit
import Foundation

class PostViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var spinner: UIActivityIndicatorView!
    @IBOutlet private weak var postTextLabel: UILabel!
    
    // MARK: - Dependency
    
    private let model: IPostModel
    private var logger: ILoggable
    
    // MARK: - Initializers
    
    init(model: IPostModel, logger: ILoggable) {
        self.model = model
        self.logger = logger
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData()
    }
    
    // MARK: - Private methods
    
    private func configureData() {
        model.getNewsPost(usingCache: false) { [weak self] (postItem, attributedText, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.logger.logMessage(for: error)
                    self?.postTextLabel.text = "No data available, try to open later"
                    self?.postTextLabel.textColor = .darkGray
                } else if let postItem = postItem {
                    self?.postTextLabel.attributedText = attributedText
                    self?.postTextLabel.textColor = .black
                    self?.model.saveNewsPost(postItem) { [weak self] error in
                        if let error = error {
                            self?.logger.logMessage(for: error)
                        }
                    }
                }
                
                self?.spinner.stopAnimating()
            }
        }
    }
    
    private func configureUI() {
        logger.delegate = self
        
        titleLabel.text = model.postHeader.title
        
        navigationItem.title = model.postHeader.date
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    }
    
}
