//
//  TeamViewModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 17/02/21.
//

import XCTest
@testable import NBA_Test

class TeamViewModelTests: XCTestCase {
    var team: TeamModel!
    var viewModel: TeamViewModel!
    
    override func setUpWithError() throws {
        team = try teamBuilder()
        viewModel = TeamViewModel(team: team)
    }
    
    func test_team_is_set() {
        let injectedTeam = viewModel.team
        
        XCTAssertEqual(injectedTeam.id, 1)
        XCTAssertEqual(injectedTeam.city, "Atlanta")
    }
    
    func test_conference_value() {
        let expectedResult = ConferenceType.eastern
        
        XCTAssertEqual(expectedResult, viewModel.conference)
    }
    
    func test_conference_when_team_changes() {
        team.conference = "West"
        viewModel = TeamViewModel(team: team)
        
        let expectedResult = ConferenceType.western
        
        XCTAssertEqual(expectedResult, viewModel.conference)
    }
    
    func test_conference_when_team_has_invalid_value() {
        team.conference = "invalid value"
        viewModel = TeamViewModel(team: team)
        
        let expectedResult = ConferenceType.all
        
        XCTAssertEqual(expectedResult, viewModel.conference)
    }
    
    func test_logo_url() throws {
        let url = try XCTUnwrap(viewModel.imageUrl)
        let expectedResult = Constants.teamLogoUrlString + viewModel.team.abbreviation.lowercased() + ".png"
       
        XCTAssertEqual(expectedResult, url.absoluteString)
    }
    
    func test_logo_is_nil_when_url_is_not_valid() throws {
        team.abbreviation = "%%$"
        viewModel = TeamViewModel(team: team)
        
        XCTAssertNil(viewModel.imageUrl)
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
