//
//  SwitchBoardTableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 15/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import UIKit

class SwitchBoardTableViewCell: UITableViewCell {

    @IBOutlet weak var controllersHeight: NSLayoutConstraint!
    @IBOutlet weak var controllers: UIView!
    @IBOutlet weak var switchesView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
