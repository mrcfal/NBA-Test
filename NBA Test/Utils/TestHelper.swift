//
//  TestHelper.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation

#if DEBUG
protocol TestHelper: AnyObject {
    func onSet()
    func onCalled(function: String, file: String)
}
#endif

