//
//  TableViewCell.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 16/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
  
    var sliders = [String]()

    @IBOutlet weak var slidersTableView: UITableView!
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
        self.controllersView.backgroundColor = interface.tableAltBackground
        self.onOffButton.backgroundColor = UIColor.clear
        self.slidersTableView.backgroundColor = UIColor.clear
      //  self.onOffButton.setTitleColor(interface.text, for: .normal)
 
        createTableViews()
    }

    @objc func changeValue(slider : UISlider) {
        
    }
    
    func createTableViews() {
       
        slidersTableView.delegate = self
        slidersTableView.dataSource = self
        
        slidersTableView.rowHeight = UITableView.automaticDimension
        slidersTableView.estimatedRowHeight = UITableView.automaticDimension
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "UnitTableViewCell", bundle: nil)
        slidersTableView.register(nib, forCellReuseIdentifier: "UnitTableViewCell")
   
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sliders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.row \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "UnitTableViewCell", for: indexPath) as! UnitTableViewCell
            cell.title.text = sliders[indexPath.row]
        return cell
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
