//
//  DefaultMainCollectionViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 15/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class EQCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var onOffSwitch: UISwitch!
    var id = String()
    
    @IBOutlet weak var topLabelsView: UIView!
    @IBOutlet weak var bottomLabelsView: UIView!
    @IBOutlet weak var controllers: UIView!
 
    @IBOutlet weak var slidersStackView: UIStackView!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var slider3: UISlider!
    @IBOutlet weak var slider4: UISlider!
    @IBOutlet weak var slider5: UISlider!
    @IBOutlet weak var slider6: UISlider!
    @IBOutlet weak var slider7: UISlider!
    @IBOutlet weak var slider8: UISlider!
    @IBOutlet weak var slider9: UISlider!
    @IBOutlet weak var slider10: UISlider!
    
    @IBOutlet weak var slider1Value: UILabel!
    @IBOutlet weak var slider2Value: UILabel!
    @IBOutlet weak var slider3Value: UILabel!
    @IBOutlet weak var slider4Value: UILabel!
    @IBOutlet weak var slider5Value: UILabel!
    @IBOutlet weak var slider6Value: UILabel!
    @IBOutlet weak var slider7Value: UILabel!
    @IBOutlet weak var slider8Value: UILabel!
    @IBOutlet weak var slider9Value: UILabel!
    @IBOutlet weak var slider10Value: UILabel!
    
    @IBOutlet weak var slider1Title: UILabel!
    @IBOutlet weak var slider2Title: UILabel!
    @IBOutlet weak var slider3Title: UILabel!
    @IBOutlet weak var slider4Title: UILabel!
    @IBOutlet weak var slider5Title: UILabel!
    @IBOutlet weak var slider6Title: UILabel!
    @IBOutlet weak var slider7Title: UILabel!
    @IBOutlet weak var slider8Title: UILabel!
    @IBOutlet weak var slider9Title: UILabel!
    @IBOutlet weak var slider10Title: UILabel!
    
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
        self.slider5Value.textColor = interface.text
        self.slider5Title.textColor = interface.text
        self.slider6Title.textColor = interface.text
        self.slider6Value.textColor = interface.text
        self.slider7Title.textColor = interface.text
        self.slider7Value.textColor = interface.text
        self.slider8Title.textColor = interface.text
        self.slider8Value.textColor = interface.text
        self.slider9Title.textColor = interface.text
        self.slider9Value.textColor = interface.text
        self.slider10Title.textColor = interface.text
        self.slider10Value.textColor = interface.text
        self.controllers.backgroundColor = interface.tabs
        controllers.layer.cornerRadius = 8
        
        slider1.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider2.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider3.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider4.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider5.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider6.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider7.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider8.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider9.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider10.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        onOffSwitch.addTarget(self, action: #selector(toggleOnOff), for: .valueChanged)
        
        audio.shared.toggleOnOff(id: self.id, isOn: onOffSwitch.isOn)
    }
    
    @objc func toggleOnOff(onOffSwitch : UISwitch) {
        if onOffSwitch.isOn {
            audio.shared.toggleOnOff(id: self.id, isOn: true)
        }
        else {
            audio.shared.toggleOnOff(id: self.id, isOn: false)
        }
    }
    
    @objc func valueChanged(slider: UISlider) {
        switch slider {
        case slider1: slider1Value.text = audio.shared.changeValues(id:self.id, slider: 1, value: Double(slider.value))
        case slider2: slider2Value.text = audio.shared.changeValues(id:self.id, slider: 2, value: Double(slider.value))
        case slider3: slider3Value.text = audio.shared.changeValues(id:self.id, slider: 3, value: Double(slider.value))
        case slider4: slider4Value.text = audio.shared.changeValues(id:self.id, slider: 4, value: Double(slider.value))
        case slider5: slider5Value.text = audio.shared.changeValues(id:self.id, slider: 5, value: Double(slider.value))
        case slider6: slider6Value.text = audio.shared.changeValues(id:self.id, slider: 6, value: Double(slider.value))
        case slider7: slider7Value.text = audio.shared.changeValues(id:self.id, slider: 7, value: Double(slider.value))
        case slider8: slider8Value.text = audio.shared.changeValues(id:self.id, slider: 8, value: Double(slider.value))
        case slider9: slider9Value.text = audio.shared.changeValues(id:self.id, slider: 9, value: Double(slider.value))
        case slider10: slider10Value.text = audio.shared.changeValues(id:self.id, slider: 10, value: Double(slider.value))
        default: break
        }
        
    }
    
}
