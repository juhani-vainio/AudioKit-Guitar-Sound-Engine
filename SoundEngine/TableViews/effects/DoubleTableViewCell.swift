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
    
    @IBOutlet weak var coloringView: UIView!
    @IBOutlet weak var specialSwitch: UISwitch!
    @IBOutlet weak var specialTitle: UILabel!
    @IBOutlet weak var specialViewArea: UIView!
    @IBOutlet weak var specialViewHeight: NSLayoutConstraint!
    @IBOutlet weak var specialView: UIView!
      @IBOutlet weak var specialButton: UIButton!
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
        coloringView.layer.cornerRadius = 8
        coloringView.layer.borderWidth = 3
        // Initialization code
    
        
        slider1.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider2.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchDown)
     
           controllersView.layer.cornerRadius = 8
        specialViewArea.layer.cornerRadius = 8
       
        specialSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
      
        specialSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
      
        specialButton.addTarget(self, action: #selector(toggleSwitch), for: .touchUpInside)
    }
    
    @objc func toggleSwitch() {
        print("button")
        if specialSwitch.isOn {
            specialSwitch.setOn(false, animated: true)
            switchValueChanged(toggle: specialSwitch)
            
        } else {
            specialSwitch.setOn(true, animated: true)
            switchValueChanged(toggle: specialSwitch)
        }
        
    }
    
    func setColors() {
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.title.textColor = interface.text
        self.slider1Value.textColor = interface.text
        self.slider1Title.textColor = interface.text
        self.slider2Title.textColor = interface.text
        self.slider2Value.textColor = interface.text
        self.controllersView.backgroundColor = interface.tabs
     
        self.onOffButton.backgroundColor = UIColor.clear
        specialViewArea.backgroundColor = interface.tabs
        specialSwitch.onTintColor = interface.highlight
        // specialSwitch.tintColor = interface.negative
        specialTitle.textColor = interface.text
        
          onOffButton.layer.borderColor = interface.text.cgColor
        
        controllersView.backgroundColor = interface.tableBackground
        slider1.minimumTrackTintColor = interface.sliderMin
        slider1.maximumTrackTintColor = interface.sliderMax
        slider1.thumbTintColor = interface.sliderThumb
        slider2.minimumTrackTintColor = interface.sliderMin
        slider2.maximumTrackTintColor = interface.sliderMax
        slider2.thumbTintColor = interface.sliderThumb
    }
    
    @objc func switchValueChanged(toggle: UISwitch) {
        audio.shared.toggleOnOff(id: self.id, isOn: toggle.isOn)
    }
    
    func setOnOff() {
        if onOffButton.titleLabel?.text == "ON" {
            onOffButton.setTitleColor(interface.text, for: .normal)
            slider1.isEnabled = true
            slider2.isEnabled = true

        } else {
            onOffButton.setTitleColor(interface.textIdle, for: .normal)
            if (slider1Title.text?.contains("ix"))! {
                slider1.isEnabled = false
            }
            if (slider2Title.text?.contains("ix"))!  || (slider2Title.text?.contains("Volume"))! {
                slider2.isEnabled = false
            }

        }
        
    }
    
    @objc func toggleOnOff() {
        let text = audio.shared.changeValues(id:self.id, slider: 0, value: 0)
        print(text)
        onOffButton.setTitle(text, for: .normal)
        setOnOff()
    }
    
    
    @objc func valueChanged(slider: UISlider) {
        switch slider {
        case slider1: slider1Value.text = audio.shared.changeValues(id:self.id, slider: 1, value: Double(slider.value))
        case slider2: slider2Value.text = audio.shared.changeValues(id:self.id, slider: 2, value: Double(slider.value))
        default: break
        }

    }
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
