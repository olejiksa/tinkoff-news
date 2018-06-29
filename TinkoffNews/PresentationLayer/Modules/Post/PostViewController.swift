//
//  PostViewController.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
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
    
    // MARK: - Initializers
    
    init(model: IPostModel) {
        self.model = model
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
        model.getNewsPost(useCache: false) { [weak self] (attributedText, error) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showMessage(for: error)
                    self?.postTextLabel.text = "No data available, try to open later"
                    self?.postTextLabel.textColor = .darkGray
                } else {
                    self?.postTextLabel.attributedText = attributedText
                    self?.postTextLabel.textColor = .black
                    self?.model.saveNewsPost() { [weak self] error in
                        if let error = error {
                            self?.showMessage(for: error)
                        }
                    }
                }
                
                self?.spinner.stopAnimating()
            }
        }
    }
    
    private func configureUI() {
        titleLabel.text = model.postTitle
        
        navigationItem.title = model.postDate
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: nil)
    }
    
    private func showMessage(for error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
