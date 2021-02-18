//
//  MyListResponse.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

/// Generic model used to handle the RapidAPI response. Note: We do not care about the meta property at this stage, we just focus on the data.
struct MyListResponse<T: Codable>: Codable {
    var data: [T]
    var meta: [String : Int?]
}

