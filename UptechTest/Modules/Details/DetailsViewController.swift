import UIKit

protocol DetailsViewProtocol: AnyObject {
    func setupModel(_ model:Article)
}

final class DetailsViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var articleImageView: UIImageView!
    @IBOutlet private weak var descriptionTextView: UITextView!
    
    var presenter: DetailsPresenterInput?
    var model: Article!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.updateView()
    }
    
    private func configureView() {
        titleLabel.text = model.title
        articleImageView.load(URL(string: model.urlToImage ?? ""))
        
        descriptionTextView.isEditable = false
        descriptionTextView.text = model.description
    }
}

extension DetailsViewController: DetailsViewProtocol {
    func setupModel(_ model: Article) {
        self.model = model
        
        configureView()
    }
}
