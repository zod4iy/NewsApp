//
//  ArticleMO+CoreDataClass.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/16/21.
//
//

import CoreData

@objc(ArticleMO)
public class ArticleMO: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey, CaseIterable {
            case author
            case title
            case description
            case url
            case urlToImage
            case publishedAt
            case content
        }
        
        required convenience public init(from decoder: Decoder) throws {
            guard let key = CodingUserInfoKey.managedObjectContext,
                let context = decoder.userInfo[key] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: ArticleMO.entityName, in: context) else {
                    throw CoreDataError.failedToGetEntity
            }
            
            self.init(entity: entity, insertInto: context)
            
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.author = try container.decodeIfPresent(String.self, forKey: .author)
            self.title = try container.decodeIfPresent(String.self, forKey: .title)
            self.descriptions = try container.decodeIfPresent(String.self, forKey: .description)
            self.url = try container.decodeIfPresent(String.self, forKey: .url)
            self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
            self.publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
            self.content = try container.decodeIfPresent(String.self, forKey: .content)

            if let publishedAt = self.publishedAt {
                let date = Date.dateFormatterApiResponse.date(from: publishedAt)
                self.publishedAtDate = date
            }
        }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encodeIfPresent(author, forKey: .author)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(descriptions, forKey: .description)
        try container.encodeIfPresent(url, forKey: .url)
        try container.encodeIfPresent(urlToImage, forKey: .urlToImage)
        try container.encodeIfPresent(publishedAt, forKey: .publishedAt)
        try container.encodeIfPresent(content, forKey: .content)
    }
    
}

extension ArticleMO: Managed {
    public static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: #keyPath(ArticleMO.publishedAtDate), ascending: false)]
    }
}

extension ArticleMO {
    func update(_ article: Article) {
        self.author = article.author
        self.title = article.title
        self.descriptions = article.description
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.publishedAt = article.publishedAt
        self.content = article.content
    }
}
