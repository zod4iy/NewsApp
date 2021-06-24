//
//  RequestBuilder.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
    case PATCH
}

protocol RequestBuildable {
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [String : String]? { get }
}

class RequestBuilder {
    
    private let api: API
    
    init(_ api: API) {
        self.api = api
    }
    
    func build(_ buildable: RequestBuildable) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = api.scheme
        urlComponents.host = api.host
        urlComponents.path = buildable.path
        
        if let parameters = buildable.parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name:  $0.key, value: $0.value) }
        }
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = buildable.method.rawValue
        request.setValue(api.apiKey, forHTTPHeaderField: "X-Api-Key")
        
        return request
    }
}
