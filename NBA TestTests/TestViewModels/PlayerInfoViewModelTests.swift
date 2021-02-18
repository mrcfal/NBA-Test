//
//  PlayerInfoViewModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class PlayerInfoViewModelTests: XCTestCase {
    
    var player: PlayerModel!
    var viewModel: PlayerInfoViewModel!
    
    override func setUpWithError() throws {
        player = try playerBuilder()
        viewModel = PlayerInfoViewModel(player: player)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        player = nil
    }
    
    func test_info_is_set() {
        XCTAssertEqual(false, viewModel.playerInfo.isEmpty)
    }
    
    func test_info_subscript() {
        let value = viewModel.playerInfo["First name"]
        XCTAssertEqual("Ike", value)
    }
    
    func test_info_when_player_height_is_nil() {
        player.heightFeet = nil
        viewModel = PlayerInfoViewModel(player: player)
        
        XCTAssertNil(viewModel.playerInfo["Height"])
    }
    
    func test_info_when_player_height_is_set() {
        player.heightFeet = 12
        player.heightInches = 10.20
        viewModel = PlayerInfoViewModel(player: player)
        
        XCTAssertEqual(viewModel.playerInfo["Height"], "12.0 feet and 10.2 inches")
    }
    
    private func playerBuilder() throws -> PlayerModel {
        return try JSONDecoder().decode(PlayerModel.self, from: XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8)))
    }
}
