//
//  NewsRequest.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import Foundation

enum NewsRequest: RequestBuildable {
    
    case fetch(page: Int, pageSize: Int)
    
    var path: String {
        switch self {
        case .fetch: return "/v2/top-headlines"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetch: return .GET
        }
    }
    
    var parameters: [String : String]? {
        switch self {
        case let .fetch(page, pageSize):
            return [
                "category" : "general",
                "country" : "ua",
                "page" : "\(page)",
                "pageSize" : "\(pageSize)"
            ]
        }
    }
}
