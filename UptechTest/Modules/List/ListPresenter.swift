//
//  ListPresenter.swift
//  UptechTestAssigment
//
//  Created by Alex Kurylenko on 12.05.2021.
//

import Foundation
import CoreData

private struct Constants {
    static let newsPageSize = 10
}

protocol ListPresenterInput: AnyObject {
    var fetchedResultsController: NSFetchedResultsController<ArticleMO>? { get }
    func updateView()
    func loadMore()
    func refresh()
    func didSelectRow(at indexPath: IndexPath)
}

final class ListPresenter {

    var wireframe: ListWireframe?
    var interactor: ListInteractorInput?
    weak var view: ListViewProtocol?
    
    var fetchedResultsController: NSFetchedResultsController<ArticleMO>? {
        return interactor?.fetchedResultsController
    }
    
    private var count: Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    private var nextPage: Int? {
        let totalArticles = max(1, self.totalArticles ?? count)
        let next = Int(count / Constants.newsPageSize) + 1
        return count < totalArticles ? next  : nil
    }
    
    private var totalArticles: Int?
    private var isRefreshing = false
    
    convenience init(view: ListViewProtocol,
                     interactor: ListInteractorInput,
                     wireframe: ListWireframe) {
        self.init()
        
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - ListPresenterInput
extension ListPresenter: ListPresenterInput {
    func updateView() {
        guard count == 0 else {
            view?.stopSpinners()
            view?.updateView()
            return
        }
        
        guard let nextPage = self.nextPage else { return }
        interactor?.fetchNews(
            nextPage: nextPage,
            pageSize: Constants.newsPageSize
        )
    }
    
    func loadMore() {
        guard let nextPage = self.nextPage else {
            view?.loadMore(isAvailable: true)
            return
        }
        view?.bottomSpinner(isHidden: false)
        interactor?.fetchNews(
            nextPage: nextPage,
            pageSize: Constants.newsPageSize
        )
    }
    
    func refresh() {
        isRefreshing = true
        interactor?.fetchNews(
            nextPage: 1,
            pageSize: Constants.newsPageSize
        )
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let article = fetchedResultsController?.fetchedObjects?[safe: indexPath.row] else { return }
        wireframe?.navigateToDetails(Article(article))
    }
}

// MARK: - ListInteractorOutput
extension ListPresenter: ListInteractorOutput {
    func fetchNewsSuccess(_ articles: [Article]?, _ totalArticles: Int?) {
        view?.stopSpinners()
        self.totalArticles = totalArticles
        
        guard let articles = articles, !articles.isEmpty else {
            view?.loadMore(isAvailable: true)
            return
        }
        
        if isRefreshing {
            isRefreshing = false
            interactor?.clearStoredArticles()
        }
        
        interactor?.saveArticles(articles)
        view?.updateView()
        view?.loadMore(isAvailable: true)
    }
    
    func fetchNewsFailure(_ error: StatusCode) {
        view?.stopSpinners()
        view?.showAlert(with: error)
    }
}
