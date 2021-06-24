//
//  ListViewController.swift
//  UptechTestAssigment
//
//  Created by Alex Kurylenko on 12.05.2021.
//

import UIKit
import CoreData

private struct Constants {
    static let title = "News"
    static let bottomSpinnerHeight: CGFloat = 80
    static let bottomLoadingInset: CGFloat = 20
}

protocol ListViewProtocol: AnyObject {
    func updateView()
    func bottomSpinner(isHidden: Bool)
    func showAlert(with error: StatusCode)
    func stopSpinners()
    func loadMore(isAvailable: Bool)
}

final class ListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.isHidden = true
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .singleLine
            tableView.refreshControl = refreshControl
            
            refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
            
            tableView.register(
                UINib(nibName: NewsCell.identifier, bundle: nil),
                forCellReuseIdentifier: NewsCell.identifier
            )
        }
    }
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var spinner: UIActivityIndicatorView = {
        return UIActivityIndicatorView(style: .large)
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
       return UIRefreshControl()
    }()
    
    var presenter: ListPresenterInput?
    private var canLoadMore = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
        presenter?.updateView()
    }
    
    func configureView() {
        navigationItem.title = Constants.title
    }
    
    @objc func refresh() {
        refreshControl.beginRefreshing()
        presenter?.refresh()
    }
}

// MARK: - ListViewProtocol
extension ListViewController: ListViewProtocol {
    
    func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.isHidden = false
            try? self?.presenter?.fetchedResultsController?.performFetch()
            self?.tableView.reloadData()
        }
    }
    
    func bottomSpinner(isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if isHidden {
                self.spinner.stopAnimating()
                self.tableView.tableFooterView = nil
            } else {
                self.spinner.frame = CGRect(
                    x: 0,
                    y: 0,
                    width: self.tableView.bounds.width,
                    height: Constants.bottomSpinnerHeight
                )
                self.spinner.startAnimating()
                self.tableView.tableFooterView = self.spinner
            }
        }
    }
    
    func showAlert(with error: StatusCode) {
        DispatchQueue.main.async { [weak self] in
            self?.stopSpinners()
            
            let alertController = UIAlertController(
                title: "Ops!",
                message: error.description,
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(
                    title: "Ok",
                    style: .default
                )
            )
            
            self?.present(alertController, animated: true)
        }
    }
    
    func stopSpinners() {
        DispatchQueue.main.async { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.bottomSpinner(isHidden: true)
            self?.refreshControl.endRefreshing()
        }
    }
    
    func loadMore(isAvailable: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.canLoadMore = isAvailable
        }
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.didSelectRow(at: indexPath)
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.fetchedResultsController?.sections?[safe: section]?.numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell,
              let item = presenter?.fetchedResultsController?.object(at: indexPath) else {
                return UITableViewCell()
        }
        
        cell.configure(model: Article(item))
        return cell
    }
}

// MARK: - UIScrollViewDelegate
extension ListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        let x = (contentHeight - frameHeight) + Constants.bottomLoadingInset

        if contentHeight > 0,
           contentHeight > frameHeight,
           offsetY > x,
           canLoadMore {
            canLoadMore = false
            
            presenter?.loadMore()
        }
    }
}
