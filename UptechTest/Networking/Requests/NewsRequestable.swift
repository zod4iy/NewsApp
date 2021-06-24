//
//  NewsRequestable.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import Foundation

protocol NewsRequestable {
    func fetch(page: Int, pageSize: Int, completion: @escaping (Result<News, StatusCode>) -> Void)
}

extension NetworkService: NewsRequestable {
    func fetch(page: Int, pageSize: Int, completion: @escaping (Result<News, StatusCode>) -> Void) {
        let request = NewsRequest.fetch(page: page, pageSize: pageSize)
        self.request(request, completion: completion)
    }
}
