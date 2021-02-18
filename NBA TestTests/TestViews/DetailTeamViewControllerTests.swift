//
//  DetailTeamViewControllerTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class DetailTeamViewControllerTests: XCTestCase {
    var vc: DetailTeamViewController!
    var teamPlayersVM: TeamPlayersViewModel!
    
    override func setUpWithError() throws {
        vc = DetailTeamViewController()
        teamPlayersVM = TeamPlayersViewModel(team: try teamBuilder())
    }
    
    override func tearDownWithError() throws {
        vc = nil
        teamPlayersVM = nil
    }
    
    func test_tableView_reloadData_when_published_players_change() {
        vc.teamPlayersVM = teamPlayersVM

        let exp = expectation(description: "callback")
        vc.viewDidLoad()

        var playerName: String = ""

        vc.reloadData = { [weak self] playerVMs in
            playerName = playerVMs.first?.player.firstName ?? ""
            //avoid didLoad callback
            if playerVMs.isEmpty == false {
                exp.fulfill()
                self?.vc.reloadData = nil
            }
        }
        
        teamPlayersVM.setPlayers(allPlayers: [PlayerModel(id: 0, firstName: "Mike", lastName: "Jord", position: "C", heightFeet: nil, heightInches: nil, weightPounds: nil, team: teamPlayersVM.team)])
        
        wait(for: [exp], timeout: 10)
        
        XCTAssertEqual(playerName, "Mike")
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
