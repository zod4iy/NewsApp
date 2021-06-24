import UIKit

protocol DetailsWireframing {
    
}

final class DetailsWireframe {

    weak var viewController: DetailsViewController?
    
    static func createModule(model: Article) -> DetailsViewController {
        // create module objects
        let view = DetailsViewController(nibName: nil, bundle: nil)
        let interactor = DetailsInteractor()
        let wireframe = DetailsWireframe()
        let presenter = DetailsPresenter(view: view, interactor: interactor, wireframe: wireframe)
        presenter.model = model
        
        // wire in module dependencies
        view.presenter = presenter
        interactor.output = presenter
        wireframe.viewController = view
        
        return view
    }
    
    static func createModuleWithNavigationController(model: Article) -> UINavigationController {
        return UINavigationController(rootViewController: createModule(model: model))
    }
}

extension DetailsWireframe: DetailsWireframing {
    
}
