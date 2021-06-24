//
//  API.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import Foundation

enum API {
    case newsapi
    
    var scheme: String {
        switch self {
        case .newsapi: return "https"
        }
    }
    
    var host: String {
        switch self {
        case .newsapi: return "newsapi.org"
        }
    }
    
    var apiKey: String {
        switch self {
        case .newsapi:  return "b8a4371601fd47d7b68204d03b1ab8dd"
        }
    }
}
