//
//  TeamInfoHeaderViewTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class TeamInfoHeaderViewTests: XCTestCase {
    var view: TeamInfoHeaderView!
    var teamInfoViewModel: TeamInfoViewModel!
    var team: TeamModel!
    var tester: MockTestHelper!
    
    override func setUpWithError() throws {
        team = try teamBuilder()
        teamInfoViewModel = TeamInfoViewModel(team: team)
        view = TeamInfoHeaderView(frame: .zero)
        tester = MockTestHelper()
        view.testHelper = tester
    }
    
    override func tearDownWithError() throws {
        view = nil
        teamInfoViewModel = nil
        team = nil
        tester = nil
    }
    
    func test_before_setting_viewModel() {
        XCTAssertEqual(tester.isSetCalled, false)
    }
    
    func test_teamInfoVM_set() {
        view.teamInfoVM = teamInfoViewModel
        
        XCTAssertEqual(tester.isSetCalled, true)
    }
    
    func test_subviews_are_set_after_viewModel_set() {
        let exp = expectation(description: "callback")
        var functionValue: String = ""

        tester.onCalled = { function, _ in
            functionValue = function
            exp.fulfill()
        }
        view.teamInfoVM = teamInfoViewModel

        wait(for: [exp], timeout: 10)
        
        XCTAssertEqual(functionValue, "setVStack()")
    }
    
    private func teamBuilder() throws -> TeamModel {
        return try JSONDecoder().decode(TeamModel.self, from: XCTUnwrap(TeamModel.dummyJSONString.data(using: .utf8)))
    }
}
