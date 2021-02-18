//
//  UIHelper.swift
//  NBA Test
//
//  Created by Marco Falanga on 17/02/21.
//

import UIKit

struct UIHelper {
    /// UIHelpers used to set the collectionVIew flow layout. By default it attempts to set at least 3 items per row.
    /// - Parameters:
    ///   - headerSize: optional CGSize, if not nil, it sets the header size;
    static func createColumsFlowLayout(columns: Int, aspectRatio: CGFloat = 1, headerSize: CGSize?, in view: UIView) -> UICollectionViewFlowLayout {
                
        let width = min(view.bounds.width, view.bounds.height)
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        
        let availableWidth = width - (padding*2) - (minimumItemSpacing*2)
        let itemWidth = availableWidth / CGFloat(columns)
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * aspectRatio)
        
        if let size = headerSize {
            flowLayout.headerReferenceSize = size
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
        
        return flowLayout
    }
}
