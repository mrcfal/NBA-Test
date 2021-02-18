//
//  PlayerViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

/// Presents a player, provinding the fullName (based on the player's first and last name) )and a secondaryString (based on the player's position if it is not empty)
final class PlayerViewModel {
    
    var fullName: String!
    var secondaryString: String!

    let player: PlayerModel!
    
    init(player: PlayerModel) {
        self.player = player
        setValues()
    }
    
    private func setValues() {
        let personNameComponentsFormatter = PersonNameComponentsFormatter()
        personNameComponentsFormatter.style = .long
        var personNameComponents = PersonNameComponents()
        personNameComponents.familyName = player.lastName
        personNameComponents.givenName = player.firstName
        
        fullName = personNameComponentsFormatter.string(from: personNameComponents)
        secondaryString = player.position.isEmpty ? "" : "position: " + player.position
    }
}
