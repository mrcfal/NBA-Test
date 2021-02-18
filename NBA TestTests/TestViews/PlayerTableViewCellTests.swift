//
//  PlayerTableViewCellTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class PlayerTableViewCellTests: XCTestCase {
    var view: PlayerTableViewCell!
    var playerViewModel: PlayerViewModel!
    var player: PlayerModel!
    var tester: MockTestHelper!
    
    override func setUpWithError() throws {
        player = try playerBuilder()
        playerViewModel = PlayerViewModel(player: player)
        view = PlayerTableViewCell(frame: .zero)
        tester = MockTestHelper()
        view.testHelper = tester
    }
    
    override func tearDownWithError() throws {
        view = nil
        playerViewModel = nil
        player = nil
        tester = nil
    }
    
    func test_before_setting_viewModel() {
        XCTAssertEqual(tester.isSetCalled, false)
    }
    
    func test_playerVM_set() {
        view.playerVM = playerViewModel
        
        XCTAssertEqual(tester.isSetCalled, true)
    }
    
    private func playerBuilder() throws -> PlayerModel {
        return try JSONDecoder().decode(PlayerModel.self, from: XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8)))
    }
}
