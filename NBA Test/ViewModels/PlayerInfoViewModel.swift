//
//  PlayerInfoViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation

/// Used to present the player's information to display in the DetailPlayerViewController.
///
/// It uses the InfoTuple typealias for (boldKey: String, value: String). See the Array+Ext source file.
///
/// I do not use a dictionary because I want to have control on the information sorting.
/// The setValues method is called to set the teamInfo array using the subscript extension (see Array+Ext for more info).
final class PlayerInfoViewModel {
    
    var playerInfo: [InfoTuple]!
    var title: String!
    
    let player: PlayerModel
    
    init(player: PlayerModel) {
        self.player = player
        
        setValues()
    }
    
    private func setValues() {
        title = player.lastName + ", " + player.firstName
        playerInfo = []
        playerInfo["First name"] = player.firstName
        playerInfo["Last name"] = player.lastName
        
        if let feet = player.heightFeet, let inches = player.heightInches {
            let feetString = String(format: "%.1f", feet)
            let inchesString = String(format: "%.1f", inches)
            
            playerInfo["Height"] = feetString + " feet and " + inchesString + " inches"
        }
        
        if let weight = player.weightPounds {
            playerInfo["Weight"] = String(format: "%.1f pounds", weight)
        }
        
        if let team = player.team {
            playerInfo["Team"] = team.name
        }
    }
}
