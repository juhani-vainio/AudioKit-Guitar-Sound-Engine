//
//  PassFiltersTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 03/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import UIKit

class PassFiltersTableViewCell: UITableViewCell {

    var highPassOn = Bool()
    var lowPassOn = Bool()
    
    @IBOutlet weak var highPassOnOffButton: UIButton!
    @IBOutlet weak var lowPassOnOffButton: UIButton!
    
    @IBOutlet weak var highPassSegment: UISegmentedControl!
    
    @IBOutlet weak var lowPassSegment: UISegmentedControl!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var controllersView: UIView!
    @IBOutlet weak var controllersHeight: NSLayoutConstraint!
    
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
        
        controllersView.backgroundColor = interface.tab
        controllersView.layer.cornerRadius = 8
        
        for label in labels {
            label.textColor = interface.text
        }
        highPassSegment.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        lowPassSegment.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        highPassSegment.tintColor = interface.text
        lowPassSegment.tintColor = interface.text
        
        highPassSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        lowPassSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        highPassOnOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchDown)
        lowPassOnOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchDown)
        highPassSegment.addTarget(self, action: #selector(toggleSegment), for: .valueChanged)
        lowPassSegment.addTarget(self, action: #selector(toggleSegment), for: .valueChanged)
    }
    
    @objc func toggleSegment(segment: UISegmentedControl) {
        
        if segment == highPassSegment {
            audio.shared.togglePassKneeOnOff(slider: 1, segment: self.highPassSegment.selectedSegmentIndex, isOn: highPassOn)
        }
        else if segment == lowPassSegment {
            audio.shared.togglePassKneeOnOff(slider: 2, segment: self.lowPassSegment.selectedSegmentIndex, isOn: lowPassOn)
        }
    }

    @objc func toggleOnOff(button: UIButton) {
        
        if button == highPassOnOffButton {
            if highPassOn == true {
                highPassOn = false
                self.highPassOnOffButton.setTitle("OFF", for: .normal)
            } else {
                 highPassOn = true
                self.highPassOnOffButton.setTitle("ON", for: .normal)
            }
            audio.shared.togglePassKneeOnOff(slider: 1, segment: self.highPassSegment.selectedSegmentIndex, isOn: highPassOn)
            
        }
        else if button == lowPassOnOffButton {
            if lowPassOn == true {
                lowPassOn = false
                self.lowPassOnOffButton.setTitle("OFF", for: .normal)
            } else {
                lowPassOn = true
                self.lowPassOnOffButton.setTitle("ON", for: .normal)
            }
            audio.shared.togglePassKneeOnOff(slider: 2, segment: self.lowPassSegment.selectedSegmentIndex, isOn: lowPassOn)
        }
        
    }
    
    @objc func valueChanged(slider: UISlider) {
        if slider == highPassSlider {
            let text = audio.shared.changePassFilterValues(slider: 1, value: Double(slider.value))
            print(text)
            highPassValueLabel.text = text
        } else if slider == lowPassSlider {
            let text = audio.shared.changePassFilterValues(slider: 2, value: Double(slider.value))
            print(text)
            lowPassValueLabel.text = text
        }
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    
}
