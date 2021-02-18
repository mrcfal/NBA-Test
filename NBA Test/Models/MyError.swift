//
//  MyError.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

/// Model that conforms to **MyErrorProtocol**. It is used to handle *RapidAPI* errors.
///
/// You can initialize a MyError object with a message or with an error. If the error is of type MyErrorProtocol, it sets its own message with the error message, otherwise it sets its own message with a generic localizedDescription.
struct MyError: MyErrorProtocol {
    var message: String
    
    init(message: String) {
        self.message = message
    }
    
    init(error: Error) {
        switch error {
            case is MyErrorProtocol:
            self.init(message: (error as! MyErrorProtocol).message)
        default:
            self.init(message: error.localizedDescription)
        }
    }
}
