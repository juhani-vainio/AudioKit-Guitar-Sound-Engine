//
//  TableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 16/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
    var id = String()
    
    var sliders = [String]()
  
    @IBOutlet weak var coloringView: UIView!
    @IBOutlet weak var specialSwitch: UISwitch!
    @IBOutlet weak var specialTitle: UILabel!
    @IBOutlet weak var specialViewArea: UIView!
    @IBOutlet weak var specialViewHeight: NSLayoutConstraint!
    @IBOutlet weak var specialView: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sliderValue: UILabel!
    @IBOutlet weak var sliderTitle: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var onOffButton: UIButton!
    @IBOutlet weak var controllerHeight: NSLayoutConstraint!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        coloringView.layer.cornerRadius = coloringView.bounds.width / 2
        
        
        // Initialization code
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        title.textColor = interface.text
        sliderTitle.textColor = interface.text
        sliderValue.textColor = interface.text
        controllersView.backgroundColor = interface.tab
        controllersView.layer.cornerRadius = 8
    
        onOffButton.backgroundColor = UIColor.clear
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchDown)
        
        specialViewArea.backgroundColor = interface.tab
        specialViewArea.layer.cornerRadius = 8
        specialSwitch.onTintColor = interface.positive
        specialSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        // specialSwitch.tintColor = interface.negative
        specialTitle.textColor = interface.text
        specialSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        onOffButton.layer.borderWidth = 2
        onOffButton.layer.borderColor = interface.text.cgColor
        onOffButton.layer.cornerRadius = onOffButton.bounds.height / 2
    }
    
    @objc func switchValueChanged(toggle: UISwitch) {
        audio.shared.toggleOnOff(id: self.id, isOn: toggle.isOn)
    }
    
    func setOnOff() {
        if onOffButton.titleLabel?.text == "ON" {
            onOffButton.setTitleColor(interface.text, for: .normal)
            slider.isEnabled = true
   
        } else {
            onOffButton.setTitleColor(interface.textIdle, for: .normal)
            
            if (sliderTitle.text?.contains("ix"))!  || (sliderTitle.text?.contains("Volume"))! {
                slider.isEnabled = false
            }

        }
        
    }
    

    
    @objc func toggleOnOff() {
        let text = audio.shared.changeValues(id:self.id, slider: 0, value: 0)
        print(text)
        onOffButton.setTitle(text, for: .normal)
        setOnOff()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func valueChanged() {
        sliderValue.text = audio.shared.changeValues(id:self.id, slider: 1, value: Double(slider.value))

    }
}
