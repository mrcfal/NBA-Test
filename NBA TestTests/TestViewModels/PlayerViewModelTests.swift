//
//  PlayerViewModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class PlayerViewModelTests: XCTestCase {
    var player: PlayerModel!
    var viewModel: PlayerViewModel!
    
    override func setUpWithError() throws {
        player = try playerBuilder()
        viewModel = PlayerViewModel(player: player)
    }
    
    func test_team_is_set() {
        let injectedPlayer = viewModel.player
        
        XCTAssertEqual(injectedPlayer?.id, 14)
        XCTAssertEqual(injectedPlayer?.firstName, "Ike")
    }
    
    func test_secondaryString() {
        let expectedResult = "position: C"
        
        XCTAssertEqual(expectedResult, viewModel.secondaryString)
    }
    
    func test_secondaryString_when_player_position_is_empty() {
        player.position = ""
        viewModel = PlayerViewModel(player: player)
        
        let expectedResult = ""
        
        XCTAssertEqual(expectedResult, viewModel.secondaryString)
    }
    
    func test_fullName() {
        XCTAssertEqual("Ike Anigbogu", viewModel.fullName)
    }
    
    func test_fullName_when_value_is_empty() {
        player.firstName = ""
        viewModel = PlayerViewModel(player: player)
        
        let expectedResult = "Anigbogu"
        
        XCTAssertEqual(expectedResult, viewModel.fullName)
    }
    
    
    private func playerBuilder() throws -> PlayerModel {
        return try JSONDecoder().decode(PlayerModel.self, from: XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8)))
    }
}
