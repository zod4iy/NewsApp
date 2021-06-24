//
//  UIImageView+Extensions.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 5/13/21.
//

import UIKit

extension UIImageView {
    
    func load(_ url: URL?) {
        
        guard let url = url else {
            image = UIImage(named: "imagePlaceholder")
            return
        }
        
        if let image = ImageCacheService.shared.get(for: url) {
            self.image = image
            return
        }
        
        image = UIImage(named: "imagePlaceholder")
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageCacheService.shared.add(for: url, imageData: data)
                        self?.image = image
                    }
                }
            }
        }
    }
}
