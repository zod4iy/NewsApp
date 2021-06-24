//
//  ArticlesService.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/16/21.
//

import CoreData

protocol ArticlesServiceProtocol {
    var count: Int { get }
    var fetchedResultsController: NSFetchedResultsController<ArticleMO> { get }
    func addImage(url: URL, data: Data)
    func save(_ articles: [Article])
    func clearAll()
}

final class ArticlesService: ArticlesServiceProtocol {
    
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let coreDataService: CoreDataServiceProtocol
    
    lazy var fetchedResultsController: NSFetchedResultsController<ArticleMO> = {

        let fetchRequest: NSFetchRequest<ArticleMO> = ArticleMO.fetchRequest()
        fetchRequest.sortDescriptors = ArticleMO.defaultSortDescriptors

        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        return fetchedResultsController
    }()
    
    
    private var context: NSManagedObjectContext {
        return coreDataService.managedObjectContext
    }
    
    var count: Int {
        return ArticleMO.count(in: context) { request in
            request.includesPropertyValues = false
        }
    }
    
    init(coreDataService: CoreDataServiceProtocol = CoreDataService.shared) {
        
        self.decoder = JSONDecoder()
        self.encoder = JSONEncoder()
        
        self.coreDataService = coreDataService
        // Activate Persistent Container
        let _ = coreDataService.managedObjectContext
        
        try? fetchedResultsController.performFetch()
    }
    
    func get() -> [Article]? {
        let articleMO = ArticleMO.fetch(in: context) { request in
            request.sortDescriptors = ArticleMO.defaultSortDescriptors
        }
        
        let data = (try? encoder.encode(articleMO)) ?? Data()
        return try? decoder.decode([Article].self, from: data)
    }
    
    func save(_ articles: [Article]) {
        articles.forEach { article in
            if let url = article.url {
                let predicate = NSPredicate(format: "%K == %@", #keyPath(ArticleMO.url), url)
                if let data = try? encoder.encode(article),
                   let articleMO = ArticleMO.findOrCreate(in: self.context, matching: predicate, data: data, configure: { _ in }) {
                    articleMO.update(article)
                }
            }
            
        }
        
        let _ = context.saveOrRollback()
    }
    
    func addImage(url: URL, data: Data) {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(ArticleMO.urlToImage), url.absoluteString)
        let articleMO = ArticleMO.findOrFetch(in: context, matching: predicate)
        articleMO?.image = data
    }
    
    func clearAll() {
        let fetchRequest = NSFetchRequest<ArticleMO>(entityName: ArticleMO.entityName)
        fetchRequest.includesPropertyValues = false
        
        let articleMO = try? context.fetch(fetchRequest)
        articleMO?.forEach { context.delete($0) }
        
        _ = context.saveOrRollback()
    }
}
