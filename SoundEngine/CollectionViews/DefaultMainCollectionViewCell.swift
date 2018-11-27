//
//  DefaultMainCollectionViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 15/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class DefaultMainCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = interface.tableBackground
        title.textColor = interface.text
    }

}
