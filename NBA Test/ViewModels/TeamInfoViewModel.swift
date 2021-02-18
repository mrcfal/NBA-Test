//
//  TeamInfoViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation

/// Used in TeamInfoViewModel and PlayerInfroViewModel, Array where Element == InfoTuple implement subscript (see Array+Ext for more info)
typealias InfoTuple = (boldKey: String, value: String)

/// Used to present the team's information to display in the TeamInfoHeaderView.
///
/// It uses the InfoTuple typealias for (boldKey: String, value: String). See the Array+Ext source file.
///
/// I do not use a dictionary because I want to have control on the information sorting.
/// The setValues method is called to set the teamInfo array using the subscript extension (see Array+Ext for more info).
final class TeamInfoViewModel {
    
    //NOTE - I want it sorted so I do not use dict
    
    var title: String = "Team Bio"
    var teamInfo: [InfoTuple] = []
    var imageUrl: URL?
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        
        setValues()
    }
    
    private func setValues() {
        teamInfo["Full Name"] = team.fullName
        teamInfo["City"] = team.city
        teamInfo["Conference"] = team.conference
        teamInfo["Division"] = team.division
        
        imageUrl = try? Helpers.getTeamLogoUrl(team: team)
    }
}
