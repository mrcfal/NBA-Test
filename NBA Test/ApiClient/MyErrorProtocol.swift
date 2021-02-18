//
//  MyErrorProtocol.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation


/// Errors that conform to this protocol have a message property (*String*) and can be initialize with a message or with a generic error.
///
/// Check **MyError** to see the init implementation. MyErrorProtocol ensures there is a message property.
protocol MyErrorProtocol: Codable, Error {
    var message: String { get set }
    init(message: String)
    init(error: Error)
}
