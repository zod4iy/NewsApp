//
//  StatusCode.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/14/21.
//

import Foundation

enum StatusCode: Error {
    case unowned
    case decoding
    case code(Int)
    
    var description: String {
        switch self {
        case .code(let value):
            switch value {
            case 200..<300: return "Ok"
            case 400..<500: return "Client Error"
            case 500..<600: return "Server Error"
            default: return "Unknown"
            }
        case .decoding: return "Decoding Error"
        default: return "Unknown"
        }
    }
    
    var isSuccessful: Bool {
        switch self {
        case let .code(value): return 200..<300 ~= value
        default: return false
        }
    }
}
