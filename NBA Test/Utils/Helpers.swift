//
//  Helpers.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import Foundation

final class Helpers {
    /// Helper used to get the team url using the team abbreviation value and the official NBA API. If the URL is not valid it throws an error (of type MyError).
    static func getTeamLogoUrl(team: TeamModel, hostname: String = Constants.teamLogoUrlString) throws -> URL {
        let url = URL(string: hostname + team.abbreviation.lowercased() + ".png")
        guard let unwrappedUrl = url else {
            print("URL not valid", #fileID, #function)
            throw MyError(message: "URL not valid")
        }
        
        return unwrappedUrl
    }
}
