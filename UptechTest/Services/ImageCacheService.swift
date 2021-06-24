//
//  ImageCacheService.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 13.05.2021.
//

import UIKit

final class ImageCacheService {
    static let shared = ImageCacheService()
    private init() {}
    
    private var imageCache = NSCache<NSString, NSData>()
    private let articlesService: ArticlesServiceProtocol = ArticlesService()
    
    func get(for url: URL) -> UIImage? {
        guard let data = imageCache.object(forKey: url.absoluteString as NSString) else { return nil }
        return UIImage(data: data as Data)
    }
    
    func add(for url: URL, imageData: Data) {
        articlesService.addImage(url: url, data: imageData)
        imageCache.setObject(imageData as NSData, forKey: url.absoluteString as NSString)
    }
}
