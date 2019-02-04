//
//  SnappingFlowLayout.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 02/10/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import UIKit

class PreSnappingFlowLayout: UICollectionViewFlowLayout {
    
    private var firstSetupDone = false
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 2
        let width = collectionView!.bounds.width
        let height = width / 3
        itemSize = CGSize(width: width, height: height)
        estimatedItemSize = CGSize(width: width, height: 100)
        sectionHeadersPinToVisibleBounds = true
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        
        let centerOffset = collectionView!.bounds.size.height / 2
        let offsetWithCenter = proposedContentOffset.y + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.y - offsetWithCenter) < abs($1.center.y - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: 0, y: closestAttribute.center.y - centerOffset)
    }
}

class PostSnappingFlowLayout: UICollectionViewFlowLayout {
    
    private var firstSetupDone = false
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        scrollDirection = .vertical
        minimumLineSpacing = 2
        let width = collectionView!.bounds.width
        let height = width / 3
        itemSize = CGSize(width: width, height: height)
        estimatedItemSize = CGSize(width: width, height: 100)
        sectionHeadersPinToVisibleBounds = true
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        
        let centerOffset = collectionView!.bounds.size.height / 2
        let offsetWithCenter = proposedContentOffset.y + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.y - offsetWithCenter) < abs($1.center.y - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: 0, y: closestAttribute.center.y - centerOffset)
    }
}
