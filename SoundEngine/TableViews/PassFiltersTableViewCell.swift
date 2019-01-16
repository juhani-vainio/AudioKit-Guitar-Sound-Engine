//
//  PassFiltersTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 03/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import UIKit

class PassFiltersTableViewCell: UITableViewCell {

    @IBOutlet weak var highPassOnOffButton: UIButton!
    @IBOutlet weak var lowPassOnOffButton: UIButton!
    
    @IBOutlet weak var highPassSegment: UISegmentedControl!
    
    @IBOutlet weak var lowPassSegment: UISegmentedControl!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var controllersView: UIView!

    @IBOutlet weak var lowPassValueLabel: UILabel!
    @IBOutlet weak var highPassValueLabel: UILabel!
    
    @IBOutlet weak var lowPassSlider: UISlider!
    @IBOutlet weak var highPassSlider: UISlider!
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
     
        highPassOnOffButton.backgroundColor = UIColor.clear
        highPassOnOffButton.layer.borderWidth = 2
        highPassOnOffButton.layer.borderColor = interface.text.cgColor
        highPassOnOffButton.layer.cornerRadius = highPassOnOffButton.bounds.height / 2
        
        lowPassOnOffButton.backgroundColor = UIColor.clear
        lowPassOnOffButton.layer.borderWidth = 2
        lowPassOnOffButton.layer.borderColor = interface.text.cgColor
        lowPassOnOffButton.layer.cornerRadius = lowPassOnOffButton.bounds.height / 2
        
        controllersView.backgroundColor = interface.heading
        controllersView.layer.cornerRadius = 8
        
        for label in labels {
            label.textColor = interface.text
        }
        highPassSegment.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        lowPassSegment.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        highPassSegment.tintColor = interface.text
        lowPassSegment.tintColor = interface.text
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
