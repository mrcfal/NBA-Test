//
//  TeamPlayersViewModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class TeamPlayersViewModelTests: XCTestCase {
    
    var team: TeamModel!
    var viewModel: TeamPlayersViewModel!
    
    override func setUpWithError() throws {
        team = try teamBuilder()
        viewModel = TeamPlayersViewModel(team: team)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        team = nil
    }
    
    func test_players_isEmpty() {
        XCTAssertEqual(0, viewModel.teamPlayers.count)
    }
    
    func test_players_when_adding_onePlayer() throws {
        viewModel.setPlayers(allPlayers: [try playerInTeamBuilder(team: team)])
        
        XCTAssertEqual(1, viewModel.teamPlayers.count)
    }
    
    func test_players_when_allPlayers_but_only_two_are_in_team() throws {
        let allPlayer = try buildPlayersFromTwoDifferentTeams()
        
        viewModel.setPlayers(allPlayers: allPlayer)
        
        XCTAssertEqual(2, viewModel.teamPlayers.count)
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
    
    private func playerBuilder() throws -> PlayerModel {
        return try JSONDecoder().decode(PlayerModel.self, from: XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8)))
    }
    
    private func playerInTeamBuilder(team: TeamModel) throws -> PlayerModel {
        var player = try playerBuilder()
        player.team = team
        
        return player
    }
    
    private func buildPlayersFromTwoDifferentTeams() throws -> [PlayerModel] {
        let player0 = try playerInTeamBuilder(team: team)
        let player1 = try playerInTeamBuilder(team: team)
        
        let otherTeam = TeamModel(id: 100, abbreviation: "Other team", city: "Rome", conference: "Italy", division: "South", fullName: "Other Team Rome", name: "Others")
        
        let otherPlayer0 = try playerInTeamBuilder(team: otherTeam)
        let otherPlayer1 = try playerInTeamBuilder(team: otherTeam)
        
        return [otherPlayer0, player0, player1, otherPlayer1]
    }
}
