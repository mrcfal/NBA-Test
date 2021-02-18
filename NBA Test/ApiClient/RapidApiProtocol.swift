//
//  RapidApiProtocol.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

/// Read **ApiClientProtocol** for more info.
///
/// It provides getUrlRequest default implementation which sets the perform URLRequest parameter (see ApiClientProtocol) with the RapidAPI headers and hostname. Each context defines its own path (i.e. "/teams", "/players")
protocol RapidApiProtocol: ApiClientProtocol {
    func getUrlRequest(path: String, hostname: String, headers: [String : String]) throws -> URLRequest    
}

extension RapidApiProtocol {
    func getUrlRequest(path: String, hostname: String = Constants.hostname, headers: [String : String] = ["x-rapidapi-key" : Constants.apiSecretKey, "x-rapidapi-host" : Constants.hostKey]) throws -> URLRequest {
        guard let url = URL(string: hostname + path) else {
            print("URL not valid")
            throw ErrorType(message: "URL not valid")
        }
        
        var result = URLRequest(url: url)
        
        headers.forEach { (key, value) in
            result.setValue(value, forHTTPHeaderField: key)
        }
        
        return result
    }
}
