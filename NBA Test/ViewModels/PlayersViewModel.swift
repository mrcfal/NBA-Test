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
    
    static var processingQueue: DispatchQueue = DispatchQueue(label: "players-processing")
    
    @Published var error: MyError? = nil
    @Published var result: MyListResponse<PlayerModel>? = nil
    @Published var isLoading: Bool = false
    
    var players: [PlayerModel] {
        result?.data ?? []
    }
    
    var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    func get() {
        do {
            let urlRequest = try getUrlRequest(path: "/players")
            perform(urlRequest: urlRequest)
        } catch let error {
            self.error = MyError(error: error)
        }
    }
}
