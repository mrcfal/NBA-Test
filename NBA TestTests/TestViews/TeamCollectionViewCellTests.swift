//
//  TeamCollectionViewCellTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class TeamCollectionViewCellTests: XCTestCase {
    var view: TeamCollectionViewCell!
    var teamViewModel: TeamViewModel!
    var team: TeamModel!
    var tester: MockTestHelper!
    
    override func setUpWithError() throws {
        team = try teamBuilder()
        teamViewModel = TeamViewModel(team: team)
        view = TeamCollectionViewCell(frame: .zero)
        tester = MockTestHelper()
        view.testHelper = tester
    }
    
    override func tearDownWithError() throws {
        view = nil
        teamViewModel = nil
        team = nil
        tester = nil
    }
    
    func test_before_setting_viewModel() {
        XCTAssertEqual(tester.isSetCalled, false)
    }
    
    func test_playerVM_set() {
        view.teamVM = teamViewModel
        
        XCTAssertEqual(tester.isSetCalled, true)
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
