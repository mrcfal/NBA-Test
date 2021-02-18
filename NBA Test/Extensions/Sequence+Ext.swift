//
//  Sequence+Ext.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var checked = Set<Iterator.Element>()
        return filter {
            //if it is not inserted in checked, it is a duplicate
            checked.insert($0).inserted
        }
    }
}
