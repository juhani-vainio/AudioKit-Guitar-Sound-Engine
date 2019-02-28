//
//  EQ31CollectionViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 17/12/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class EQ31CollectionViewCell: UICollectionViewCell {
    
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
    @IBOutlet weak var slider11: UISlider!
    @IBOutlet weak var slider12: UISlider!
    @IBOutlet weak var slider13: UISlider!
    @IBOutlet weak var slider14: UISlider!
    @IBOutlet weak var slider15: UISlider!
    @IBOutlet weak var slider16: UISlider!
    @IBOutlet weak var slider17: UISlider!
    @IBOutlet weak var slider18: UISlider!
    @IBOutlet weak var slider19: UISlider!
    @IBOutlet weak var slider20: UISlider!
    @IBOutlet weak var slider21: UISlider!
    @IBOutlet weak var slider22: UISlider!
    @IBOutlet weak var slider23: UISlider!
    @IBOutlet weak var slider24: UISlider!
    @IBOutlet weak var slider25: UISlider!
    @IBOutlet weak var slider26: UISlider!
    @IBOutlet weak var slider27: UISlider!
    @IBOutlet weak var slider28: UISlider!
    @IBOutlet weak var slider29: UISlider!
    @IBOutlet weak var slider30: UISlider!
    @IBOutlet weak var slider31: UISlider!
    
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
    @IBOutlet weak var slider11Value: UILabel!
    @IBOutlet weak var slider12Value: UILabel!
    @IBOutlet weak var slider13Value: UILabel!
    @IBOutlet weak var slider14Value: UILabel!
    @IBOutlet weak var slider15Value: UILabel!
    @IBOutlet weak var slider16Value: UILabel!
    @IBOutlet weak var slider17Value: UILabel!
    @IBOutlet weak var slider18Value: UILabel!
    @IBOutlet weak var slider19Value: UILabel!
    @IBOutlet weak var slider20Value: UILabel!
    @IBOutlet weak var slider21Value: UILabel!
    @IBOutlet weak var slider22Value: UILabel!
    @IBOutlet weak var slider23Value: UILabel!
    @IBOutlet weak var slider24Value: UILabel!
    @IBOutlet weak var slider25Value: UILabel!
    @IBOutlet weak var slider26Value: UILabel!
    @IBOutlet weak var slider27Value: UILabel!
    @IBOutlet weak var slider28Value: UILabel!
    @IBOutlet weak var slider29Value: UILabel!
    @IBOutlet weak var slider30Value: UILabel!
    @IBOutlet weak var slider31Value: UILabel!
    
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
    @IBOutlet weak var slider11Title: UILabel!
    @IBOutlet weak var slider12Title: UILabel!
    @IBOutlet weak var slider13Title: UILabel!
    @IBOutlet weak var slider14Title: UILabel!
    @IBOutlet weak var slider15Title: UILabel!
    @IBOutlet weak var slider16Title: UILabel!
    @IBOutlet weak var slider17Title: UILabel!
    @IBOutlet weak var slider18Title: UILabel!
    @IBOutlet weak var slider19Title: UILabel!
    @IBOutlet weak var slider20Title: UILabel!
    @IBOutlet weak var slider21Title: UILabel!
    @IBOutlet weak var slider22Title: UILabel!
    @IBOutlet weak var slider23Title: UILabel!
    @IBOutlet weak var slider24Title: UILabel!
    @IBOutlet weak var slider25Title: UILabel!
    @IBOutlet weak var slider26Title: UILabel!
    @IBOutlet weak var slider27Title: UILabel!
    @IBOutlet weak var slider28Title: UILabel!
    @IBOutlet weak var slider29Title: UILabel!
    @IBOutlet weak var slider30Title: UILabel!
    @IBOutlet weak var slider31Title: UILabel!
    
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
        self.slider11Value.textColor = interface.text
        self.slider11Title.textColor = interface.text
        self.slider12Title.textColor = interface.text
        self.slider12Value.textColor = interface.text
        self.slider13Title.textColor = interface.text
        self.slider13Value.textColor = interface.text
        self.slider14Title.textColor = interface.text
        self.slider14Value.textColor = interface.text
        self.slider15Value.textColor = interface.text
        self.slider15Title.textColor = interface.text
        self.slider16Title.textColor = interface.text
        self.slider16Value.textColor = interface.text
        self.slider17Title.textColor = interface.text
        self.slider17Value.textColor = interface.text
        self.slider18Title.textColor = interface.text
        self.slider18Value.textColor = interface.text
        self.slider19Title.textColor = interface.text
        self.slider19Value.textColor = interface.text
        self.slider20Title.textColor = interface.text
        self.slider20Value.textColor = interface.text
        self.slider21Value.textColor = interface.text
        self.slider21Title.textColor = interface.text
        self.slider22Title.textColor = interface.text
        self.slider22Value.textColor = interface.text
        self.slider23Title.textColor = interface.text
        self.slider23Value.textColor = interface.text
        self.slider24Title.textColor = interface.text
        self.slider24Value.textColor = interface.text
        self.slider25Value.textColor = interface.text
        self.slider25Title.textColor = interface.text
        self.slider26Title.textColor = interface.text
        self.slider26Value.textColor = interface.text
        self.slider27Title.textColor = interface.text
        self.slider27Value.textColor = interface.text
        self.slider28Title.textColor = interface.text
        self.slider28Value.textColor = interface.text
        self.slider29Title.textColor = interface.text
        self.slider29Value.textColor = interface.text
        self.slider30Title.textColor = interface.text
        self.slider30Value.textColor = interface.text
        self.slider31Title.textColor = interface.text
        self.slider31Value.textColor = interface.text
        self.controllers.backgroundColor = interface.tab
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
        slider11.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider12.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider13.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider14.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider15.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider16.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider17.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider18.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider19.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider20.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider21.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider22.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider23.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider24.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider25.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider26.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider27.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider28.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider29.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider30.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        slider31.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
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
        case slider11: slider11Value.text = audio.shared.changeValues(id:self.id, slider: 11, value: Double(slider.value))
        case slider12: slider12Value.text = audio.shared.changeValues(id:self.id, slider: 12, value: Double(slider.value))
        case slider13: slider13Value.text = audio.shared.changeValues(id:self.id, slider: 13, value: Double(slider.value))
        case slider14: slider14Value.text = audio.shared.changeValues(id:self.id, slider: 14, value: Double(slider.value))
        case slider15: slider15Value.text = audio.shared.changeValues(id:self.id, slider: 15, value: Double(slider.value))
        case slider16: slider16Value.text = audio.shared.changeValues(id:self.id, slider: 16, value: Double(slider.value))
        case slider17: slider17Value.text = audio.shared.changeValues(id:self.id, slider: 17, value: Double(slider.value))
        case slider18: slider18Value.text = audio.shared.changeValues(id:self.id, slider: 18, value: Double(slider.value))
        case slider19: slider19Value.text = audio.shared.changeValues(id:self.id, slider: 19, value: Double(slider.value))
        case slider20: slider20Value.text = audio.shared.changeValues(id:self.id, slider: 20, value: Double(slider.value))
        case slider21: slider21Value.text = audio.shared.changeValues(id:self.id, slider: 21, value: Double(slider.value))
        case slider22: slider22Value.text = audio.shared.changeValues(id:self.id, slider: 22, value: Double(slider.value))
        case slider23: slider23Value.text = audio.shared.changeValues(id:self.id, slider: 23, value: Double(slider.value))
        case slider24: slider24Value.text = audio.shared.changeValues(id:self.id, slider: 24, value: Double(slider.value))
        case slider25: slider25Value.text = audio.shared.changeValues(id:self.id, slider: 25, value: Double(slider.value))
        case slider26: slider26Value.text = audio.shared.changeValues(id:self.id, slider: 26, value: Double(slider.value))
        case slider27: slider27Value.text = audio.shared.changeValues(id:self.id, slider: 27, value: Double(slider.value))
        case slider28: slider28Value.text = audio.shared.changeValues(id:self.id, slider: 28, value: Double(slider.value))
        case slider29: slider29Value.text = audio.shared.changeValues(id:self.id, slider: 29, value: Double(slider.value))
        case slider30: slider30Value.text = audio.shared.changeValues(id:self.id, slider: 30, value: Double(slider.value))
        case slider31: slider31Value.text = audio.shared.changeValues(id:self.id, slider: 31, value: Double(slider.value))
        default: break
        }
        
    }
    
}
