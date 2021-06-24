import UIKit

protocol DetailsPresenterInput: AnyObject {
    func updateView()
}

final class DetailsPresenter {
    var wireframe: DetailsWireframe?
    var interactor: DetailsInteractorInput?
    weak var view: DetailsViewProtocol?
    var model: Article?
    
    convenience init(view: DetailsViewProtocol,
                     interactor: DetailsInteractorInput,
                     wireframe: DetailsWireframe) {
        self.init()
        
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

extension DetailsPresenter: DetailsPresenterInput {
   
    func updateView() {
        guard let model = model else { return }
        view?.setupModel(model)
    }
}

extension DetailsPresenter: DetailsInteractorOutput {
    
}
