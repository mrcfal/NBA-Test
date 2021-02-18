//
//  TeamInfoViewModelTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class TeamInfoViewModelTests: XCTestCase {
    
    var team: TeamModel!
    var viewModel: TeamInfoViewModel!
    
    override func setUpWithError() throws {
        team = try teamBuilder()
        viewModel = TeamInfoViewModel(team: team)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        team = nil
    }
    
    func test_info_is_set() {
        XCTAssertEqual(false, viewModel.teamInfo.isEmpty)
    }
    
    func test_info_subscript() {
        let value = viewModel.teamInfo["City"]
        XCTAssertEqual("Atlanta", value)
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
