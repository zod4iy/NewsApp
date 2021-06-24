//
//  CodingUserInfoKey+Extensions.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/14/21.
//

import CoreData

public extension CodingUserInfoKey {
    // Helper property to retrieve the Core Data managed object context
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")
}

extension JSONDecoder {
    convenience init(_ moc: NSManagedObjectContext) {
        guard let infoKey = CodingUserInfoKey.managedObjectContext else {
            self.init()
            return
        }
        self.init()
        self.userInfo[infoKey] = moc
    }
}

