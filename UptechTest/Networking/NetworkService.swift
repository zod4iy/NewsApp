//
//  NetworkService.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import Foundation

class NetworkService {
    
    private let urlSession: URLSession
    private let requestBuilder: RequestBuilder
    private let decoder: JSONDecoder
    
    init(_ api: API) {
        let configutration = URLSessionConfiguration.ephemeral
        self.urlSession = URLSession(configuration: configutration, delegate: nil, delegateQueue: nil)
        self.requestBuilder = RequestBuilder(api)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    @discardableResult
    func request<T: Codable>(_ requestBuildable: RequestBuildable, completion: @escaping (Result<T, StatusCode>) -> Void) -> URLSessionDataTask? {
        
        guard let request = requestBuilder.build(requestBuildable) else {
            completion(.failure(StatusCode.unowned))
            return nil
        }
        
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self,
                  let data = data,
                  let httpResponse = response as? HTTPURLResponse,
                  StatusCode.code(httpResponse.statusCode).isSuccessful else {
                completion(.failure(StatusCode.unowned))
                return
            }
            
            if let model = try? self.decoder.decode(T.self, from: data) {
                completion(.success(model))
            } else {
                completion(.failure(StatusCode.decoding))
            }
        }
        
        task.resume()
        return task
    }
}
