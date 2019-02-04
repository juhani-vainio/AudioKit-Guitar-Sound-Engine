//
//  ParallaxFlowLayout.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 02/10/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import UIKit

class ParallaxFlowLayout: UICollectionViewLayout {
    
    private var firstSetupDone = false
    private var cache = [IndexPath: ParallaxLayoutAttributes]()
    private var visibleLayoutAttributes = [ParallaxLayoutAttributes]()
    private var contentWidth: CGFloat = 0
    
    private var itemSize = CGSize(width: 0, height: 0)
    private var maxParallaxOffset: CGFloat = 0
    
    private func setup() {
        itemSize = CGSize(width: collectionView!.bounds.width, height: collectionView!.bounds.height)
        collectionView!.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
        
        cache.removeAll(keepingCapacity: true)
        cache = [IndexPath: ParallaxLayoutAttributes]()
        contentWidth = 0
        
        for section in 0 ..< collectionView!.numberOfSections {
            for item in 0 ..< collectionView!.numberOfItems(inSection: section) {
                let cellIndexPath = IndexPath(item: item, section: section)
                let attributes = ParallaxLayoutAttributes(forCellWith: cellIndexPath)
                attributes.frame = CGRect(
                    x: contentWidth,
                    y: 0,
                    width: itemSize.width,
                    height: itemSize.height
                )
                contentWidth = attributes.frame.maxX
                cache[cellIndexPath] = attributes
            }
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public class var layoutAttributesClass: AnyClass {
        return ParallaxLayoutAttributes.self
    }
    
    override public var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: collectionView!.frame.height)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        visibleLayoutAttributes.removeAll(keepingCapacity: true)
        let halfWidth = collectionView!.bounds.width * 0.5
        let halfCellWidth = itemSize.width * 0.5
        
        for (_, attributes) in cache {
            attributes.parallax = .identity
            if attributes.frame.intersects(rect) {
                let cellDistanceFromCenter = attributes.center.x - collectionView!.contentOffset.x - halfWidth
                let parallaxOffset = -(maxParallaxOffset * cellDistanceFromCenter) / (halfWidth + halfCellWidth)
                let boundedParallaxOffset = min(max(-maxParallaxOffset, parallaxOffset), maxParallaxOffset)
                attributes.parallax = CGAffineTransform(translationX: boundedParallaxOffset, y: 0)
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
 
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let layoutAttributes = layoutAttributesForElements(in: collectionView!.bounds)
        
        let centerOffset = collectionView!.bounds.size.width / 2
        let offsetWithCenter = proposedContentOffset.x + centerOffset
        
        let closestAttribute = layoutAttributes!
            .sorted { abs($0.center.x - offsetWithCenter) < abs($1.center.x - offsetWithCenter) }
            .first ?? UICollectionViewLayoutAttributes()
        
        return CGPoint(x: closestAttribute.center.x - centerOffset, y: 0)
    }
}

class ParallaxLayoutAttributes: UICollectionViewLayoutAttributes {
    
    var parallax: CGAffineTransform = .identity
    
    override func copy(with zone: NSZone?) -> Any {
        guard let attributes = super.copy(with: zone) as? ParallaxLayoutAttributes else { return super.copy(with: zone) }
        attributes.parallax = parallax
        return attributes
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? ParallaxLayoutAttributes else { return false }
        guard NSValue(cgAffineTransform: attributes.parallax) == NSValue(cgAffineTransform: parallax) else { return false }
        return super.isEqual(object)
    }
}
