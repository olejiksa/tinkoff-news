//
//  FeedViewController.swift
//  TinkoffNews
//
//  Created by Oleg Samoylov on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - UI
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        return refresher
    }()
    
    // MARK: - Dependencies
    
    private var model: IFeedModel
    private var logger: ILoggable
    private let presentationAssembly: IPresentationAssembly
    
    // MARK: - Initializers
    
    init(model: IFeedModel, logger: ILoggable, presentationAssembly: IPresentationAssembly) {
        self.model = model
        self.logger = logger
        self.presentationAssembly = presentationAssembly
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI()
        configureTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureData(mergePolicy: .overwrite, usingCache: true)
    }
    
    // MARK: - Private methods
    
    private func configureData(mergePolicy: FeedMergePolicy, usingCache: Bool) {
        switch mergePolicy {
        case .overwrite:
            model.pageNumber = 1
        case .append:
            model.pageNumber += 1
        }
        
        model.getNewsFeed(mergePolicy: mergePolicy, usingCache: usingCache) {
            [weak self] (newsItems, error, save) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.logger.logMessage(for: error)
                } else {
                    self?.tableView.reloadData()
                    if save {
                        self?.model.saveNewsFeed() { [weak self] error in
                            if let error = error {
                                self?.logger.logMessage(for: error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func configureUI() {
        logger.delegate = self
        
        tableView.refreshControl = refreshControl
        
        navigationItem.title = "Tinkoff News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "\(NewsCell.self)", bundle: nil), forCellReuseIdentifier: "\(NewsCell.self)")
        tableView.register(UINib(nibName: "\(LoadCell.self)", bundle: nil), forCellReuseIdentifier: "\(LoadCell.self)")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Selector
    
    @objc private func updateData() {
        configureData(mergePolicy: .overwrite, usingCache: false)
        refreshControl.endRefreshing()
    }
    
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionsCount = 0
        
        if model.data.count > 0 {
            sectionsCount = 1
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                    width: tableView.bounds.size.width,
                                                    height: tableView.bounds.size.height))
            noDataLabel.text = "No any news yet"
            noDataLabel.textColor = .darkGray
            noDataLabel.textAlignment = .center
            
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == model.data.count {
            return tableView.dequeueReusableCell(withIdentifier: "\(LoadCell.self)", for: indexPath)
        }
        
        let identifier = "\(NewsCell.self)"
        var cell: NewsCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsCell {
            cell = dequeuedCell
        } else {
            cell = NewsCell(style: .default, reuseIdentifier: identifier)
        }
        
        cell.setup(from: model.data[indexPath.row])
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < model.data.count else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        model.data[indexPath.row].viewsCount += 1
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        model.saveNewsFeedItem(by: indexPath.row) { [weak self] error in
            if let error = error {
                self?.logger.logMessage(for: error)
            }
        }
        
        let controller = presentationAssembly.postViewController(newsItem: model.data[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == model.data.count {
            configureData(mergePolicy: .append, usingCache: true)
        }
    }
    
}
