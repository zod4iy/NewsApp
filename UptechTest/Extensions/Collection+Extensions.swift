//
//  Collection+Extensions.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/14/21.
//

import Foundation

extension Collection {

    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
