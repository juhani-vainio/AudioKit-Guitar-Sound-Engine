//
//  DoubleTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 24/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class DoubleTableViewCell: UITableViewCell {
    
    var id = String()
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var sliders = [String]()
    @IBOutlet weak var slider2Value: UILabel!
    @IBOutlet weak var slider2Title: UILabel!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider1Value: UILabel!
    @IBOutlet weak var slider1Title: UILabel!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var onOffButton: UIButton!
    @IBOutlet weak var controllerHeight: NSLayoutConstraint!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = interface.tableBackground
        self.title.textColor = interface.text
        self.slider1Value.textColor = interface.text
        self.slider1Title.textColor = interface.text
        self.slider2Title.textColor = interface.text
        self.slider2Value.textColor = interface.text
        self.controllersView.backgroundColor = interface.heading
        controllersView.layer.cornerRadius = 8
        self.onOffButton.backgroundColor = UIColor.clear
        
        slider1.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider2.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    
    @objc func valueChanged(slider: UISlider) {
        switch slider {
        case slider1: slider1Value.text = audio.effect.changeValues(id:self.id, slider: 1, value: Double(slider.value))
        case slider2: slider2Value.text = audio.effect.changeValues(id:self.id, slider: 2, value: Double(slider.value))
        default: break
        }

    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
