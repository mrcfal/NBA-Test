//
//  PlayerModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

struct PlayerModel: Codable {
    var id: Int
    var firstName: String
    var lastName: String
    var position: String
    
    //NOTE - feet can be integer cause it is "feet and inches" representation
    var heightFeet: Double?
    var heightInches: Double?
    var weightPounds: Double?
    
    var team: TeamModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case position
        case heightFeet = "height_feet"
        case heightInches = "height_inches"
        case weightPounds = "weight_pounds"
        case team
    }
}

extension PlayerModel: Hashable { }
