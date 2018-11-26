//
//  UnitTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 23/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class UnitTableViewCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.title.textColor = interface.textIdle
        self.value.textColor = interface.text
        self.slider.minimumTrackTintColor = interface.highlight
        self.slider.maximumTrackTintColor = interface.mainBackground
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        self.title.text = nil
        self.slider = nil
        self.value = nil
    }
    
}
