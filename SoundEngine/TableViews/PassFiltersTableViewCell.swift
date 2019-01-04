//
//  PassFiltersTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 03/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import UIKit

class PassFiltersTableViewCell: UITableViewCell {

    
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var controllersView: UIView!

    @IBOutlet weak var lowPassValueLabel: UILabel!
    @IBOutlet weak var highPassValueLabel: UILabel!
    
    @IBOutlet weak var lowPassSlider: UISlider!
    @IBOutlet weak var highPassSlider: UISlider!
    
    @IBOutlet weak var highPassSwitch: UISwitch!
    @IBOutlet weak var lowPassSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lowPassSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        highPassSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        
        controllersView.backgroundColor = interface.heading
        controllersView.layer.cornerRadius = 8
        
        for label in labels {
            label.textColor = interface.text
        }
        
        lowPassValueLabel.textColor = interface.text
        highPassValueLabel.textColor = interface.text
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
