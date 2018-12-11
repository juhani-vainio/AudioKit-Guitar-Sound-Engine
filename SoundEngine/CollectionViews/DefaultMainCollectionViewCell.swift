//
//  DefaultMainCollectionViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 15/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class DefaultMainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var topLabelsView: UIView!
    @IBOutlet weak var bottomLabelsView: UIView!
    @IBOutlet weak var controllers: UIView!
 
    @IBOutlet weak var slidersStackView: UIStackView!
    @IBOutlet weak var slider1: UISlider!
    
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = interface.tableBackground
        title.textColor = interface.text
      
        slidersStackView.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
     
        topLabelsView.layer.borderWidth = 1
        topLabelsView.layer.borderColor = UIColor.white.cgColor
        topLabelsView.layer.cornerRadius = 2
        bottomLabelsView.layer.borderWidth = 1
        bottomLabelsView.layer.borderColor = UIColor.white.cgColor
        bottomLabelsView.layer.cornerRadius = 2
        
    }

}
