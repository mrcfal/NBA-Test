//
//  DetailPlayerViewControllerTests.swift
//  NBA TestTests
//
//  Created by Marco Falanga on 18/02/21.
//

import XCTest
@testable import NBA_Test

class DetailPlayerViewControllerTests: XCTestCase {
    
    var vc: DetailPlayerViewController!
    
    override func setUpWithError() throws {
        vc = DetailPlayerViewController()
    }
    
    override func tearDownWithError() throws {
        vc = nil
    }
    
    func test_setSubviews_not_called() {
        XCTAssertEqual(vc.setSubviewsCalled, false)
    }
    
    func test_setSubviews_called_after_viewDidLoad() throws {
        vc.playerInfoVM = PlayerInfoViewModel(player: try playerBuilder())
        vc.viewDidLoad()
        
        XCTAssertEqual(vc.setSubviewsCalled, true)
    }
    
    private func playerBuilder() throws -> PlayerModel {
        return try JSONDecoder().decode(PlayerModel.self, from: XCTUnwrap(PlayerModel.dummyJSONString.data(using: .utf8)))
    }
}
