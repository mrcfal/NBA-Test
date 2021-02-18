//
//  TeamModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

struct TeamModel: Codable {
    var id: Int
    var abbreviation: String
    var city: String
    var conference: String
    var division: String
    var fullName: String
    var name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case abbreviation
        case city
        case conference
        case division
        case fullName = "full_name"
        case name
    }
}

extension TeamModel: Hashable { }
