//
//  ApiClientProtocol.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation
import Combine

/// Generic protocol that handles URLRequests and handles errors. The result type and the error type are generic (result must conform to Codable and error must conform to MyErrorProtocol).
///
/// The protocol provides a perform default implementation:
/// - given an URLRequest, it publishes a dataTask (if the publisher fails, it attempts to subscribe to it again a **numberOfRetry** times);
/// - the upstream publisher (dataTask) returns response and data, the map func transforms it to just the data;
/// - it attempts to decode the data as a type of **ResultType**;
/// - if it throws an error, it attempts to decode the data as a type of **ErrorType** (i.e. most API returns a different object in case of error, such as RapiAPI);
/// - if it throws a different error, it sinks the completion failure and set the error property;
/// - if the decoding succeeds, it sets the result property:
/// - the entire stream is handled by setting isLoading to true when it starts and isLoading to false when it ends
/// Extra info:
/// - the publisher is subscribed to the **processingQueue** property in order to prevent to receive request on the main thread;
/// - the final outcome is received on the main thread;
/// - the data task publisher is stored to cancellable property, which provides the possibility to cancel the publisher at any time (i.e. when the context changes or when the class is deinit)
protocol ApiClientProtocol: AnyObject {
    associatedtype ErrorType: MyErrorProtocol
    associatedtype ResultType: Codable

    static var processingQueue: DispatchQueue { get set }
    var error: ErrorType? { get set }
    var result: ResultType? { get set }
    var isLoading: Bool { get set }
    var cancellable: AnyCancellable? { get set }
    
    func perform(urlRequest: URLRequest, numberOfRetry: Int)
    func cancel()
}

extension ApiClientProtocol {
    
    func perform(urlRequest: URLRequest, numberOfRetry: Int = 3) {
        var data: Data!
        cancellable = URLSession.shared.dataTaskPublisher(for: urlRequest)
            .retry(numberOfRetry)
            .map {
                data = $0.data
                return $0.data
            }
            .decode(type: ResultType.self, decoder: JSONDecoder())
            .mapError({ [weak self] error -> Error in
                if let data = data, let error = try? JSONDecoder().decode(ErrorType.self, from: data) {
                    DispatchQueue.main.async {
                        self?.error = error
                    }
                }
                
                return error
            })
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { _ in },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.processingQueue)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error = ErrorType(error: error)
                default:
                    break
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                
                self.result = value
            })
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    private func onFinish() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
