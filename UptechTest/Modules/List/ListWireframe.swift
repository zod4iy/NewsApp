//
//  ListWireframe.swift
//  UptechTestAssigment
//
//  Created by Alex Kurylenko on 12.05.2021.
//

import UIKit

protocol ListWireframing {
    func navigateToDetails(_ article: Article)
}

final class ListWireframe {
    
    weak var viewController: ListViewController?
    
    static func createModule() -> ListViewController {
        let view = ListViewController(nibName: nil, bundle: nil)
        let interactor = ListInteractor()
        let wireframe = ListWireframe()
        let presenter = ListPresenter(view: view, interactor: interactor, wireframe: wireframe)
        
        let networkService = NetworkService(.newsapi)
        let articleService = ArticlesService()
        
        interactor.networkService = networkService
        interactor.articleService = articleService

        view.presenter = presenter
        interactor.output = presenter
        wireframe.viewController = view
        
        return view
    }
    
    static func createModuleWithNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: createModule())
    }
}

// MARK: - ListWireframing
extension ListWireframe: ListWireframing {
    func navigateToDetails(_ article: Article) {
        let detailsViewController = DetailsWireframe.createModule(model: article)
        viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
    }
}
