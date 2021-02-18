//
//  PlayerModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class PlayerModelTests: XCTestCase {
    var player: PlayerModel?
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws {
        player = nil
    }
    
    func test_json_decoding() throws {
        let data = try XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8))
        
        player = try JSONDecoder().decode(PlayerModel.self, from: data)
        let unwrappedPlayer = try XCTUnwrap(player)
        
        XCTAssertEqual(unwrappedPlayer.team?.fullName, "Indiana Pacers")
        XCTAssertEqual(unwrappedPlayer.id, 14)
    }
}
