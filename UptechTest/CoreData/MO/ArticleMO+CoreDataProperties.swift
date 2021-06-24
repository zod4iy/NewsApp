//
//  ArticleMO+CoreDataProperties.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/16/21.
//
//

import Foundation
import CoreData


extension ArticleMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleMO> {
        return NSFetchRequest<ArticleMO>(entityName: "ArticleMO")
    }

    @NSManaged public var author: String?
    @NSManaged public var content: String?
    @NSManaged public var descriptions: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var publishedAtDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImage: String?
    @NSManaged public var image: Data?

}

extension ArticleMO : Identifiable {

}
