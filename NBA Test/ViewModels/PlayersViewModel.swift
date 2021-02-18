//
//  PlayersViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation
import Combine

/// Conforms to RapidApiProtocol. The error is of type MyError and the result is of type MyListResponse\<PlayerModel\> (it has a *data* parameter of type [PlayerModel].
///
/// The main responsibility of this class is to get all the players using the RapidAPI. See **RapidApiProtocol** for more info.
final class PlayersViewModel: ObservableObject, RapidApiProtocol {
    
    static let shared = PlayersViewModel()
    
    static var processingQueue: DispatchQueue = DispatchQueue(label: "players-processing")
    
    @Published var error: MyError? = nil
    @Published var result: MyListResponse<PlayerModel>? = nil
    @Published var isLoading: Bool = false
    @Published var players: [PlayerModel] = []
    
    private var nextPage = 0
    private let perPage = 100
    private var isFull = false
    
    var cancellable: AnyCancellable?
    private var resultPlayerCancellable: AnyCancellable?
    
    private init() {
        resultPlayerCancellable = $result.sink(receiveValue: { [weak self] value in
            guard let self = self else { return }
            guard let data = value?.data else { return }
            let newPlayers = (self.players + data).unique()
            self.players = newPlayers
        })
    }
    
    deinit {
        cancellable?.cancel()
        resultPlayerCancellable?.cancel()
    }
    
    func get() {
        guard isFull == false else { return }
        
        do {
            let urlRequest = try getUrlRequest(path: "/players?page=\(nextPage)&per_page=\(perPage)")
            print("calling \(String(describing: urlRequest.url?.absoluteString))")
            perform(urlRequest: urlRequest, completion: { [weak self] result in
                guard let self = self else { return }
                if let value = result.meta["next_page"], let unwrappedValue = value {
                    self.nextPage = unwrappedValue
                } else {
                    self.isFull = true
                }
            })
        } catch let error {
            self.error = MyError(error: error)
        }
    }
}
