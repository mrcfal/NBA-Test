//
//  TeamViewModel.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

/// Presents the team in TeamCollectionViewCell. It is also used for filtering data in ViewController (in order to filter teams by conference using the ConferenceType enum).
///
/// It provides:
/// - titleName: which so far it is just the team's fullName;
/// - conference: which is a ConferenceType enum based on the team's conference string value (if string is not valid it is set to *all*);
/// - imageURL: optional url used to get the team logo (using the official NBA API). Note: if the helper method throws an error (i.e. URL not valid) this value is nil
final class TeamViewModel {
    
    var conference: ConferenceType!
    var titleName: String!
    var imageUrl: URL?
    
    let team: TeamModel
    
    init(team: TeamModel) {
        self.team = team
        setValues()
    }
    
    private func setValues() {
        switch team.conference {
        case "East":
            conference = .eastern
        case "West":
            conference = .western
        default:
            conference = .all
        }
        
        titleName = team.fullName
        
        imageUrl = try? Helpers.getTeamLogoUrl(team: team)
    }
}

