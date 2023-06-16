//
//  WLLazyImageView.swift
//  WisdomLeafApp
//
//  Created by Gopi on 16/06/23.
//

import Foundation
import UIKit

class WLLazyImageView: UIImageView {
    
    private var imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURl imageURL: URL, placeHolderImage: String) {
        
        self.image = UIImage(named: placeHolderImage)
        
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject){
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
        
    }
}
