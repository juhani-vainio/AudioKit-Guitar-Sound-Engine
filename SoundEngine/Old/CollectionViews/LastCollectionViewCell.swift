//
//  LastCollectionViewCell.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 16/10/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class LastCollectionViewCell: UICollectionViewCell {

   
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
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
