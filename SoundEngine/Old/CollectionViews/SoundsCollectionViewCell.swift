//
//  SoundsCollectionViewCell.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 01/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class SoundsCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var deleteButton: UIButton!
    
    var effectNames = [String]()
    @IBOutlet weak var information: UILabel!
    
    @IBOutlet weak var effectsLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
 
        title.adjustsFontSizeToFitWidth = false
        title.lineBreakMode = .byTruncatingTail
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
        var frame = layoutAttributes.frame
        frame.size.height = ceil(size.height)
        layoutAttributes.frame = frame
        return layoutAttributes
    }
 
}
