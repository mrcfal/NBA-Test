//
//  ImageCache.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit

/// Used in order to force classes to implement subscript (see TemporaryImageCache).
protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

/// Conforms to ImageCache protocol. You can set its cache property like cache[url] (which returns an optional UIImage).
struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

/// Singleton used to cache images. See **ImageLoader** for more info.
class MyImageCache {
    static let shared = MyImageCache()
    var imageCache = TemporaryImageCache()
    
    private init() { }
}
