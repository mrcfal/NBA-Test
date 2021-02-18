//
//  TeamsViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation
import Combine

/// Conforms to RapidApiProtocol. The error is of type MyError and the result is of type MyListResponse\<TeamModel\> (it has a *data* parameter of type [TeamModel].
///
/// The main responsibility of this class is to get all the teams using the RapidAPI. See **RapidApiProtocol** for more info.
final class TeamsViewModel: ObservableObject, RapidApiProtocol {
    
    static var processingQueue: DispatchQueue = DispatchQueue(label: "teams-processing")
    
    @Published var error: MyError? = nil
    @Published var result: MyListResponse<TeamModel>? = nil
    @Published var isLoading: Bool = false
    
    var cancellable: AnyCancellable?
    
    deinit {
        cancellable?.cancel()
    }
    
    func get() {
        do {
            let urlRequest = try getUrlRequest(path: "/teams")
            perform(urlRequest: urlRequest)
        } catch let error {
            self.error = MyError(error: error)
        }
    }
}
