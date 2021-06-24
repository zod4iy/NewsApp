//
//  ListInteractor.swift
//  UptechTestAssigment
//
//  Created by Alex Kurylenko on 12.05.2021.
//

import Foundation
import CoreData

private struct Constants {
    static let newsPageSize = 10
}

protocol ListInteractorInput: AnyObject {
    var fetchedResultsController: NSFetchedResultsController<ArticleMO>? { get }

    func fetchNews(nextPage: Int, pageSize: Int)
    func clearStoredArticles()
    func saveArticles(_ articles: [Article])
}

protocol ListInteractorOutput: AnyObject {
    func fetchNewsSuccess(_ articles: [Article]?, _ totalArticles: Int?)
    func fetchNewsFailure(_ error: StatusCode)
}

final class ListInteractor: ListInteractorInput {
    
    weak var output: ListInteractorOutput?
    var networkService: NewsRequestable?
    var articleService: ArticlesServiceProtocol?
    
    var fetchedResultsController: NSFetchedResultsController<ArticleMO>? {
        return articleService?.fetchedResultsController
    }
    
    func fetchNews(nextPage: Int, pageSize: Int) {
        networkService?.fetch(page: nextPage, pageSize: Constants.newsPageSize, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(news):
                self.output?.fetchNewsSuccess(news.articles, news.totalResults)
            case let .failure(error):
                self.output?.fetchNewsFailure(error)
            }
        })
    }
    
    func clearStoredArticles() {
        articleService?.clearAll()
    }
    
    func saveArticles(_ articles: [Article]) {
        articleService?.save(articles)
    }
}
