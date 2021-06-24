import Foundation

protocol DetailsInteractorInput: AnyObject {
    
}

protocol DetailsInteractorOutput: AnyObject {
    
}

final class DetailsInteractor: DetailsInteractorInput {
    weak var output: DetailsInteractorOutput?

}
