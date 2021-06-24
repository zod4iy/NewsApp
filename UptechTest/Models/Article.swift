//
//  Article.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/14/21.
//

import Foundation

struct Article: Codable {
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
    let image: Data?
}

extension Article: Hashable {
    init(_ article: ArticleMO) {
        self.author = article.author
        self.title = article.title
        self.description = article.descriptions
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
        self.image = article.image
    }
}
