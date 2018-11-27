//
//  TableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 16/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
  
    var sliders = [String]()

  
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
        // Initialization code
        contentView.backgroundColor = UIColor.clear
        backgroundColor = interface.tableBackground
        title.textColor = interface.text
        sliderTitle.textColor = interface.text
        sliderValue.textColor = interface.text
        controllersView.backgroundColor = interface.heading
        controllersView.layer.cornerRadius = 8
        onOffButton.backgroundColor = UIColor.clear
        slider.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func valueChanged() {
        sliderValue.text = audio.effect.changeValues(id:slider.tag, slider: 1, value: Double(slider.value))

    }
}
