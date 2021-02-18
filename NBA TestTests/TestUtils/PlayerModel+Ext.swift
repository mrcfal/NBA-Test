//
//  PlayerModel+Ext.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation
@testable import NBA_Test

extension PlayerModel {
    static let dummyJSONString = """
    {
          "id": 14,
          "first_name": "Ike",
          "height_feet": null,
          "height_inches": null,
          "last_name": "Anigbogu",
          "position": "C",
          "team": {
            "id": 12,
            "abbreviation": "IND",
            "city": "Indiana",
            "conference": "East",
            "division": "Central",
            "full_name": "Indiana Pacers",
            "name": "Pacers"
          },
          "weight_pounds": null
        }
    """
}
