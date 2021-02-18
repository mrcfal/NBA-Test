//
//  Array+Ext.swift
//  NBA Test
//
//  Created by Marco Falanga on 18/02/21.
//

import Foundation

extension Array where Element == InfoTuple {
    /// When Element is InfoTuple (alias for (boldKey: String, value String)), it implements subscript.
    ///
    /// You can append new items to the array like:
    /// ```
    /// array["key"] = "value"
    /// ```
    /// You can get the value by a key like:
    /// ```
    /// print(array["key"])
    /// //if there is no such a key
    /// //the value is nil
    /// ```
    subscript(_ key: String) -> String? {
        get { self.first(where: { $0.boldKey == key })?.value }
        set {
            //if newValue nil, remove value with the key
            //if newValue, remove the previous value if exists
            self.removeAll(where: { $0.boldKey == key })
            if let newValue = newValue {
                self.append((boldKey: key, value: newValue))
            }
        }
    }
}
