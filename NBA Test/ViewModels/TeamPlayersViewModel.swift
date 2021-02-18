//
//  TeamPlayersViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation
import Combine

/// Used to create a list of players which play for a specific team. It is initialized from a team and it is set with the setPlayers method.
///
/// - setPlayers: the allPlayers parameter is filtered by the players' team and the players are sorted by firstName.
/// You should set this class when the class responsible of fetching the players succeeds and you should use this class when it is clear which team you selected.
///
/// Note:
///
/// so far we have not API to fetch only the players that play in a specific team, that is why we want to fetch all the players (hopefully as soon as possible) and then filter the result based on the team.
final class TeamPlayersViewModel: ObservableObject {
    @Published private(set) var teamPlayers: [PlayerModel] = []
    
    let team: TeamModel!
    
    init(team: TeamModel) {
        self.team = team
    }
        
    func setPlayers(allPlayers: [PlayerModel]) {
        teamPlayers = allPlayers.filter({ $0.team == team })
    }
}
