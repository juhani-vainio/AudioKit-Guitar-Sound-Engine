//
//  EqualizerTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 04/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import UIKit

class EqualizerTableViewCell: UITableViewCell {
    
    
    @IBOutlet var labels: [UILabel]!
    
    @IBOutlet weak var soundTitle: UILabel!
    @IBOutlet weak var tableHeadingBackground: UIView!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var controllersHeight: NSLayoutConstraint!
    @IBOutlet weak var threeStack: UIStackView!
    @IBOutlet weak var sevenStack: UIStackView!
    @IBOutlet weak var controllersView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tableHeadingBackground.layer.cornerRadius = 8
        
        threeBandHighSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        threeBandMidSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        threeBandLowSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        sevenBandBrillianceSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandPrecenceSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandUpperMidSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandMidSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandLowMidSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandBassSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        sevenBandSubBassSlider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
    }
    
    func setColors() {
        tableHeadingBackground.backgroundColor = interface.tableHeading
        for label in labels {
            label.textColor = interface.text
        }
        segmentControl.tintColor = interface.segmentTint
        segmentControl.backgroundColor = interface.segmentBackground
        controllersView.backgroundColor = interface.tableBackground
        controllersView.layer.cornerRadius = 8
        
        threeBandHighSlider.thumbTintColor = interface.sliderThumb
        threeBandMidSlider.thumbTintColor = interface.sliderThumb
        threeBandLowSlider.thumbTintColor = interface.sliderThumb
        
        sevenBandBrillianceSlider.thumbTintColor = interface.sliderThumb
        sevenBandPrecenceSlider.thumbTintColor = interface.sliderThumb
        sevenBandUpperMidSlider.thumbTintColor = interface.sliderThumb
        sevenBandMidSlider.thumbTintColor = interface.sliderThumb
        sevenBandLowMidSlider.thumbTintColor = interface.sliderThumb
        sevenBandBassSlider.thumbTintColor = interface.sliderThumb
        sevenBandSubBassSlider.thumbTintColor = interface.sliderThumb
        
        threeBandHighSlider.maximumTrackTintColor = interface.sliderMax
        threeBandMidSlider.maximumTrackTintColor = interface.sliderMax
        threeBandLowSlider.maximumTrackTintColor = interface.sliderMax
        
        sevenBandBrillianceSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandPrecenceSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandUpperMidSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandMidSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandLowMidSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandBassSlider.maximumTrackTintColor = interface.sliderMax
        sevenBandSubBassSlider.maximumTrackTintColor = interface.sliderMax
        
        threeBandHighSlider.minimumTrackTintColor = interface.sliderMin
        threeBandMidSlider.minimumTrackTintColor = interface.sliderMin
        threeBandLowSlider.minimumTrackTintColor = interface.sliderMin
        
        sevenBandBrillianceSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandPrecenceSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandUpperMidSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandMidSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandLowMidSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandBassSlider.minimumTrackTintColor = interface.sliderMin
        sevenBandSubBassSlider.minimumTrackTintColor = interface.sliderMin
    }
    
    @objc func valueChanged(slider: UISlider) {
        switch slider {
        case threeBandHighSlider: threeBandHighValue.text = audio.shared.changeEQValues(slider: "threeBandHighSlider", value: Double(slider.value))
        case threeBandMidSlider: threeBandMidValue.text = audio.shared.changeEQValues(slider: "threeBandMidSlider", value: Double(slider.value))
        case threeBandLowSlider: threeBandLowValue.text = audio.shared.changeEQValues(slider: "threeBandLowSlider", value: Double(slider.value))
            
        case sevenBandBrillianceSlider: sevenBandBrillianceValue.text = audio.shared.changeEQValues(slider: "sevenBandBrillianceSlider", value: Double(slider.value))
        case sevenBandPrecenceSlider: sevenBandPrecenceValue.text = audio.shared.changeEQValues(slider: "sevenBandPrecenceSlider", value: Double(slider.value))
        case sevenBandUpperMidSlider: sevenBandUpperMidValue.text = audio.shared.changeEQValues(slider: "sevenBandUpperMidSlider", value: Double(slider.value))
        case sevenBandMidSlider: sevenBandMidValue.text = audio.shared.changeEQValues(slider: "sevenBandMidSlider", value: Double(slider.value))
        case sevenBandLowMidSlider: sevenBandLowMidValue.text = audio.shared.changeEQValues(slider: "sevenBandLowMidSlider", value: Double(slider.value))
        case sevenBandBassSlider: sevenBandBassValue.text = audio.shared.changeEQValues(slider: "sevenBandBassSlider", value: Double(slider.value))
        case sevenBandSubBassSlider: sevenBandSubBassValue.text = audio.shared.changeEQValues(slider: "sevenBandSubBassSlider", value: Double(slider.value))
        
        default: break
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var threeBandHighSlider: UISlider!
    @IBOutlet weak var threeBandHighValue: UILabel!
    
    @IBOutlet weak var threeBandMidSlider: UISlider!
    @IBOutlet weak var threeBandMidValue: UILabel!
    
    @IBOutlet weak var threeBandLowSlider: UISlider!
    @IBOutlet weak var threeBandLowValue: UILabel!
    
    @IBOutlet weak var sevenBandBrillianceSlider: UISlider!
    @IBOutlet weak var sevenBandBrillianceValue: UILabel!
    
    @IBOutlet weak var sevenBandPrecenceSlider: UISlider!
    @IBOutlet weak var sevenBandPrecenceValue: UILabel!
    
    @IBOutlet weak var sevenBandUpperMidSlider: UISlider!
    @IBOutlet weak var sevenBandUpperMidValue: UILabel!
    
    @IBOutlet weak var sevenBandMidSlider: UISlider!
    @IBOutlet weak var sevenBandMidValue: UILabel!
    
    @IBOutlet weak var sevenBandLowMidSlider: UISlider!
    @IBOutlet weak var sevenBandLowMidValue: UILabel!
    
    @IBOutlet weak var sevenBandBassSlider: UISlider!
    @IBOutlet weak var sevenBandBassValue: UILabel!
    
    @IBOutlet weak var sevenBandSubBassSlider: UISlider!
    @IBOutlet weak var sevenBandSubBassValue: UILabel!
    
}
