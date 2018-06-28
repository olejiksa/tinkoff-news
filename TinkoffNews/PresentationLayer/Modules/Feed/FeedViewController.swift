//
//  FeedViewController.swift
//  TinkoffNews
//
//  Created by Олег Самойлов on 25/06/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
    
    // MARK: - UI
    
    private var pageIndex = 1
    
    @IBOutlet private weak var tableView: UITableView!
    
    lazy private var refreshControl: UIRefreshControl = {
        let refresher = UIRefreshControl()
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: #selector(updateData), for: .valueChanged)
        
        return refresher
    }()
    
    // MARK: - Dependency
    
    private var model: IFeedModel
    private let presentationAssembly: IPresentationAssembly
    
    // MARK: - Initializers
    
    init(model: IFeedModel, presentationAssembly: IPresentationAssembly) {
        self.model = model
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
        configureData(mergePolicy: .overwrite, manually: false)
    }
    
    // MARK: - Private methods
    
    private func configureData(mergePolicy: FeedMergePolicy, manually: Bool) {
        switch mergePolicy {
        case .overwrite:
            pageIndex = 1
        case .append:
            pageIndex += 1
        }
        
        model.getNewsFeed(page: pageIndex, mergePolicy: mergePolicy, manually: manually) { [weak self] (newsItems, error, save) in
            DispatchQueue.main.async {
                if let error = error {
                    self?.showMessage(for: error)
                } else {
                    self?.tableView.reloadData()
                    if save {
                        self?.model.saveNews() { [weak self] error in
                            if let error = error {
                                self?.showMessage(for: error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func configureUI() {
        tableView.refreshControl = refreshControl
        
        navigationItem.title = "Tinkoff News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "\(NewsCell.self)", bundle: nil), forCellReuseIdentifier: "\(NewsCell.self)")
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func showMessage(for error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    // MARK: - Selector
    
    @objc private func updateData() {
        configureData(mergePolicy: .overwrite, manually: true)
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
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No any news yet"
            noDataLabel.textColor = .darkGray
            noDataLabel.textAlignment = .center
            
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "\(NewsCell.self)"
        var cell: NewsCell
        
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: identifier) as? NewsCell {
            cell = dequeuedCell
        } else {
            cell = NewsCell(style: .default, reuseIdentifier: identifier)
        }
        
        if indexPath.row == model.data.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
            cell.textLabel?.text = "Loading..."
            return cell
        } else {
            cell.title = model.data[indexPath.row].text
            cell.date = Date(timeIntervalSince1970: TimeInterval(model.data[indexPath.row].publicationDate.milliseconds / 1000))
            cell.viewsCount = model.data[indexPath.row].viewsCount
        }
        
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
        
        model.saveNews(index: indexPath.row) { [weak self] error in
            if let error = error {
                self?.showMessage(for: error)
            }
        }
        
        let controller = presentationAssembly.postViewController(newsItem: model.data[indexPath.row])
        
        controller.navigationItem.title = model.data[indexPath.row].text
        navigationController?.pushViewController(controller, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == model.data.count {
            configureData(mergePolicy: .append, manually: false)
        }
    }
    
}
