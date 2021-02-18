//
//  ImageLoader.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Combine
import UIKit

/// Used to get an image from an URL. It caches the image and it checks if the image is cached before performing the data task.
///
/// When you call the load method:
/// 1. it checks if it is already loading, if it is so it returns;
/// 2. otherwise it checks if there is an image cached with the same key (the url), if it is so it sets the image with the cached one;
/// 3. otherwise it publishes a data task;
/// 4. it attempts to map the received data to an UIImage, if it fails, it replace the image with the errorImage (you can define your own errorImage whe you initialize the object, it is intended as placeholder image);
/// 5. otherwise it sets the image property and it caches the output;
/// Note: the default cache is the singleton MyImageCache.
class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    private let errorImage: UIImage?
    
    private static let imageProcessingQueue = DispatchQueue(label: "async-image-processing")
    
    public init(url: URL, cache: ImageCache? = MyImageCache.shared.imageCache, errorImage: UIImage? = nil) {
        self.url = url
        self.cache = cache
        self.errorImage = errorImage
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: self.errorImage)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }
}
