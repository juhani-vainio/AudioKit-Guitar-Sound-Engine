//
//  QuatroTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 24/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class QuatroTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var sliders = [String]()
    @IBOutlet weak var slider4Value: UILabel!
    @IBOutlet weak var slider4Title: UILabel!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var slider3Value: UILabel!
    @IBOutlet weak var slider3Title: UILabel!
    @IBOutlet weak var slider3: UISlider!
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
        self.slider3Title.textColor = interface.text
        self.slider3Value.textColor = interface.text
        self.slider4Title.textColor = interface.text
        self.slider4Value.textColor = interface.text
        self.controllersView.backgroundColor = interface.heading
        controllersView.layer.cornerRadius = 8
        self.onOffButton.backgroundColor = UIColor.clear
        
        
        // get values from Audiokit variables
        slider1.setValue(0.2, animated: true)
        slider1Value.text = "0.2"
        
        slider2.setValue(0.5, animated: true)
        slider2Value.text = "0.5"
        
        slider3.setValue(0.7, animated: true)
        slider3Value.text = "0.7"
        
        slider4.setValue(0.7, animated: true)
        slider4Value.text = "0.7"
        
    }
    
    
    @objc func changeValue(slider : UISlider) {
        
    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
