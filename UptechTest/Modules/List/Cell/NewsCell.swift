//
//  NewsCell.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 13.05.2021.
//

import UIKit

final class NewsCell: UITableViewCell {

    @IBOutlet private weak var newsImageView: UIImageView!
    @IBOutlet private weak var newsAuthorLable: UILabel!
    @IBOutlet private weak var newsTitleLabel: UILabel!
    
    private var imageUrl: String?
    private let cacheService = ImageCacheService.shared
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setup()
    }

    func configure(model: Article) {
        newsAuthorLable.text = model.author
        newsTitleLabel.text = model.title
        if let data = model.image, let image = UIImage(data: data) {
            newsImageView.image = image
        } else {
            newsImageView.load(URL(string: model.urlToImage ?? ""))
        }
    }
    
    private func setup() {
        newsAuthorLable.text = nil
        newsTitleLabel.text = nil
    }
    
}
