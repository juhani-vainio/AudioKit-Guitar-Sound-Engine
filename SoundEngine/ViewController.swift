//
//  ViewController.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 14/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//



struct unitData {
    var opened = Bool()
    var title = String()
    var sliders = [String]()
    var isOn = Bool()

}


import UIKit

fileprivate var preCollectionLongPressGesture: UILongPressGestureRecognizer!
fileprivate var postCollectionLongPressGesture: UILongPressGestureRecognizer!

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
    
    var availableUnitsData = [unitData]()        // VÄLIAIKAINEN MALLI
    var selectedUnitsAfterData = [unitData]()    // VÄLIAIKAINEN MALLI
    var selectedUnitsBeforeData = [unitData]()    // VÄLIAIKAINEN MALLI
    
    
    private let parallaxLayout = ParallaxFlowLayout()
    private let postSnappingLayout = PostSnappingFlowLayout()
    private let preSnappingLayout = PreSnappingFlowLayout()
    
    @IBOutlet weak var mainViewBackground: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var lineInView: UIView!
    @IBOutlet weak var inputTitle: UILabel!
    @IBOutlet weak var lineInHeader: UIView!
    @IBOutlet weak var inputInfoLabel: UILabel!
    @IBOutlet weak var inputSlider: UISlider!
    
    @IBOutlet weak var outputView: UIView!
    @IBOutlet weak var outputTitle: UILabel!
    @IBOutlet weak var outputHeader: UIView!
    @IBOutlet weak var outputInfoLabel: UILabel!
    @IBOutlet weak var outputSlider: UISlider!
    
    @IBOutlet weak var availableUnits: UITableView!
    @IBOutlet weak var unitsAfter: UITableView!
    @IBOutlet weak var unitsBefore: UITableView!
    
    @IBOutlet weak var mainCollection: UICollectionView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get user preferences from userdefaults
        
        // Set up Interface
        Colors.palette.setInterfaceColorScheme(name: "spotify")
        colorScheme = "spotify"
        colorSwitchButton.setTitle("spotify", for: .normal)
        interfaceSetup()
        
        // VÄLIAIKAINEN MALLI
        availableUnitsData = [
                unitData(opened: false, title: "Variable Delay", sliders: ["time 0.2", "feedback 1.2", "isOn true"], isOn: false),
                unitData(opened: false, title: "OverDrive", sliders: ["value 0.2", "gain 2", "isOn false"], isOn: true),
                unitData(opened: false, title: "Tanh Distortion", sliders: ["time 0.2", "feedback 1.2", "isOn true"], isOn: false),
                unitData(opened: false, title: "Compressor", sliders: ["value 0.2", "gain 2", "isOn false"], isOn: true)
        ]
        
      // VÄLIAIKAINEN MALLI
        selectedUnitsAfterData = [
            unitData(opened: false, title: "Delay", sliders: ["time 0.2", "feedback 1.2", "cutoff 0.2", "mix 0.4"], isOn: false),
                unitData(opened: false, title: "Drive", sliders: ["value 0.2", "gain 2"], isOn: true)
        
        ]
        // VÄLIAIKAINEN MALLI
        selectedUnitsBeforeData = [
            unitData(opened: false, title: "Clipper", sliders: ["clip 0.2"], isOn: false),
            unitData(opened: false, title: "Wah Wah!", sliders: ["time 0.2", "feedback 1.2", "mix 0.4"], isOn: false),
            unitData(opened: false, title: "Decimator", sliders: ["value 0.2", "gain 2"], isOn: false)
            
        ]
        
        
        
        
        createCollectionViews()
        createTableViews()
        
    }


    
     // MARK: TABLEVIEWS
    func createTableViews() {
        // Arrange available units list aplhabetically
        self.availableUnitsData = self.availableUnitsData.sorted{ $0.title < $1.title }
        
        availableUnits.delegate = self
        availableUnits.dataSource = self
        unitsAfter.delegate = self
        unitsAfter.dataSource = self
        unitsBefore.delegate = self
        unitsBefore.dataSource = self
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        unitsAfter.register(nib, forCellReuseIdentifier: "TableViewCell")
        unitsBefore.register(nib, forCellReuseIdentifier: "TableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
            return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if tableView == availableUnits {
            return availableUnitsData.count
            
         } else if tableView == unitsAfter {
            // unitsAfter List
            return selectedUnitsAfterData.count
        }
         else {
            return selectedUnitsBeforeData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
         if tableView == availableUnits {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = availableUnitsData[indexPath.row].title
                cell.textLabel?.textColor = interface.text
                cell.backgroundColor = interface.tableBackground
                cell.selectedBackgroundView = backgroundView
            return cell
            
      
         } else if tableView == unitsAfter {
            // unitsAfter List
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.title.text = selectedUnitsAfterData[indexPath.row].title
            cell.sliders = selectedUnitsAfterData[indexPath.row].sliders
            
            if selectedUnitsAfterData[indexPath.row].opened == true {
                let heigth = selectedUnitsAfterData[indexPath.row].sliders.count * 44
                cell.controllerHeight.constant = CGFloat(heigth)
            } else {
                cell.controllerHeight.constant = 0
            }
            if selectedUnitsAfterData[indexPath.row].isOn == true {
                cell.onOffButton.setTitle("OFF", for: .normal)
                cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
            } else {
                cell.onOffButton.setTitle("ON", for: .normal)
                cell.onOffButton.setTitleColor(interface.text, for: .normal)
            }
            cell.selectedBackgroundView = backgroundView
            return cell
            
         } else {
            // unitsBefore List
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.title.text = selectedUnitsBeforeData[indexPath.row].title
            cell.sliders = selectedUnitsBeforeData[indexPath.row].sliders
            if selectedUnitsBeforeData[indexPath.row].opened == true {
                let heigth = selectedUnitsBeforeData[indexPath.row].sliders.count * 44
                cell.controllerHeight.constant = CGFloat(heigth)
            } else {
                cell.controllerHeight.constant = 0
            }
            if selectedUnitsBeforeData[indexPath.row].isOn == true {
                cell.onOffButton.setTitle("OFF", for: .normal)
                 cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
            } else {
                cell.onOffButton.setTitle("ON", for: .normal)
                cell.onOffButton.setTitleColor(interface.text, for: .normal)
            }
            
            cell.selectedBackgroundView = backgroundView
            return cell
        
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == availableUnits {
            
        }
        else if tableView == unitsAfter {
            // unitsAfter List
            if selectedUnitsAfterData[indexPath.row].opened == true {
                selectedUnitsAfterData[indexPath.row].opened = false
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .none)
            }
            else {
                selectedUnitsAfterData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .none)
            }
        } else {
            // unitsBefore List
            if selectedUnitsBeforeData[indexPath.row].opened == true {
                selectedUnitsBeforeData[indexPath.row].opened = false
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
            else {
                selectedUnitsBeforeData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        return true

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            if tableView == unitsAfter {
                // remove and insert data between arrays
                let tempData = selectedUnitsAfterData[indexPath.row]
                self.availableUnitsData.append(tempData)
                 // Arrange available units list aplhabetically
                self.availableUnitsData = self.availableUnitsData.sorted{ $0.title < $1.title }
                self.availableUnits.reloadData()
                self.selectedUnitsAfterData.remove(at: indexPath.row)
                let row = IndexPath(item: indexPath.row, section: 0)
                self.unitsAfter.deleteRows(at: [row], with: .none)
            }
            else if tableView == unitsBefore {
                // remove and insert data between arrays
                let tempData = selectedUnitsBeforeData[indexPath.row]
                self.availableUnitsData.append(tempData)
                // Arrange available units list aplhabetically
                self.availableUnitsData = self.availableUnitsData.sorted{ $0.title < $1.title }
                self.availableUnits.reloadData()
                self.selectedUnitsBeforeData.remove(at: indexPath.row)
                let row = IndexPath(item: indexPath.row, section: 0)
                self.unitsBefore.deleteRows(at: [row], with: .none)
            }
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == availableUnits {
            let swipeAction = self.leadingSwipeAction(forRowAtIndexPath: indexPath)
            let action = UISwipeActionsConfiguration(actions: [swipeAction])
            return action
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == availableUnits {
            let swipeAction = self.trailingSwipeAction(forRowAtIndexPath: indexPath)
            let action = UISwipeActionsConfiguration(actions: [swipeAction])
            return action
        } else {
            return nil
        }
        
    }

    func leadingSwipeAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        // swiping RIGHT
        // insert to AFTER Units
        let tempData = self.availableUnitsData[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "INSERT AFTER") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            self.selectedUnitsAfterData.append(tempData)
            self.unitsAfter.reloadData()
            self.availableUnitsData.remove(at: indexPath.row)
            let row = IndexPath(item: indexPath.row, section: 0)
            self.availableUnits.deleteRows(at: [row], with: .none)
    
            completionHandler(true)
        }
        
        return action
    }
    
    func trailingSwipeAction(forRowAtIndexPath indexPath: IndexPath) -> UIContextualAction {
        // swiping LEFT
        // insert to BEFORE Units
        let tempData = self.availableUnitsData[indexPath.row]
        
        let action = UIContextualAction(style: .normal, title: "INSERT BEFORE") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            self.selectedUnitsBeforeData.append(tempData)
            self.unitsBefore.reloadData()
            self.availableUnitsData.remove(at: indexPath.row)
            let row = IndexPath(item: indexPath.row, section: 0)
            self.availableUnits.deleteRows(at: [row], with: .none)
            
            completionHandler(true)
        }
        return action
        
    }
    
    // MARK: COLLECTION VIEWS
    
    func createCollectionViews() {
       
        mainCollection.delegate = self
        
       
        mainCollection.dataSource = self
        
        
        mainCollection.collectionViewLayout = parallaxLayout
        
        registerCollectionViewCells()
        
        
        
    }
    
    
    func registerCollectionViewCells() {
        
        /*
        for pedal in 0..<Effects.selectedEffects.count {
            
            let typeName = Effects.selectedEffects[pedal]
            
            let nib = UINib(nibName: typeName + "CollectionViewCell", bundle: nil)
            audioSignalView.register(nib, forCellWithReuseIdentifier: typeName)
            
        }
        for pedal in 0..<Effects.listOfEffects.count {
            
            let typeName = Effects.listOfEffects[pedal]
            
            let nib = UINib(nibName: typeName + "CollectionViewCell", bundle: nil)
            audioSignalView.register(nib, forCellWithReuseIdentifier: typeName)
        }
        */
       
        
        let mainNib = UINib(nibName: "DefaultMainCollectionViewCell", bundle: nil)
        mainCollection.register(mainNib, forCellWithReuseIdentifier: "DefaultMainCollectionViewCell")
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
      return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemCount = 0
        if collectionView == mainCollection {
            print("mainCollection")
            itemCount = 2
        }
        print(itemCount)
        return itemCount

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var returnCell = UICollectionViewCell()
        if collectionView == mainCollection  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultMainCollectionViewCell", for: indexPath) as! DefaultMainCollectionViewCell
            
            returnCell = cell
        }
        
        return returnCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
       /*
        if collectionView == audioSignalView {
            if indexPath.item == effectCellName.count - 1 {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
         */
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        
        /*
        if proposedIndexPath.row == collectionView.numberOfItems(inSection: 0) - 1 {
            return IndexPath(row: proposedIndexPath.row - 1, section: proposedIndexPath.section)
        } else {
            return proposedIndexPath
        }
        
        */
        return proposedIndexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        
        /*
        let removed = effectCellName.remove(at: sourceIndexPath.item)
        effectCellName.insert(removed, at: destinationIndexPath.item)
        
        let removedEffect = effect.remove(at: sourceIndexPath.item)
        effect.insert(removedEffect, at: destinationIndexPath.item)
        
        let removedName = Effects.selectedEffects.remove(at: sourceIndexPath.item)
        Effects.selectedEffects.insert(removedName, at: destinationIndexPath.item)
        
        resetEffectChain()
        
        */
        
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
     if collectionView == mainCollection {
            print("MAIN SELECTED CELL:  \(indexPath.item)")
        }
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if self.availableUnits.isHidden {
            self.availableUnits.isHidden = false
        } else {
            self.availableUnits.isHidden = true
        }
        
    }
    
    @IBAction func tapColorSwitch(_ sender: Any) {
        let index = Colors.palette.options.firstIndex(of: colorScheme)
        if index! < Colors.palette.options.count - 1{
            let nextScheme = Colors.palette.options[index! + 1]
            colorSwitchButton.setTitle(nextScheme, for: .normal)
            Colors.palette.setInterfaceColorScheme(name: nextScheme)
            colorScheme = nextScheme
            
        } else {
            
            let nextScheme = Colors.palette.options[0]
            colorSwitchButton.setTitle(nextScheme, for: .normal)
            Colors.palette.setInterfaceColorScheme(name: nextScheme)
            colorScheme = nextScheme
        }
        interfaceSetup()

    }
    
    @IBOutlet weak var colorSwitchButton: UIButton!
    
    @IBAction func checkButton(_ sender: Any) {
        
        
            
        
        
        print("AVAILABLE")
        print(self.availableUnitsData)
        print("SELECTED")
        print(self.selectedUnitsAfterData)
    }
   
    var colorScheme = ""
    
    func interfaceSetup() {
        // set interface color scheme
        
        
        checkButton.backgroundColor = interface.buttonBackground
        checkButton.setTitleColor(interface.text, for: .normal)
        addButton.backgroundColor = interface.buttonBackground
        addButton.setTitleColor(interface.highlight, for: .normal)
        
        lineInView.backgroundColor = interface.tableAltBackground
        inputTitle.textColor = interface.text
        lineInHeader.backgroundColor = interface.heading
        inputInfoLabel.textColor = interface.text
        inputSlider.minimumTrackTintColor = interface.highlight
        inputSlider.maximumTrackTintColor = interface.mainBackground
        inputSlider.thumbTintColor = interface.text
        
        outputView.backgroundColor = interface.tableAltBackground
        outputTitle.textColor = interface.text
        outputHeader.backgroundColor = interface.heading
        outputInfoLabel.textColor = interface.text
        outputSlider.minimumTrackTintColor = interface.highlight
        outputSlider.maximumTrackTintColor = interface.mainBackground
        outputSlider.thumbTintColor = interface.text
        
        appnameButton.setTitleColor(interface.text, for: .normal)
        
        availableUnits.backgroundColor = UIColor.clear
        unitsAfter.backgroundColor = UIColor.clear
        unitsBefore.backgroundColor = UIColor.clear
        
        mainCollection.backgroundColor = UIColor.clear
        mainViewBackground.backgroundColor = interface.mainBackground
        
        mainCollection.backgroundColor = UIColor.clear
        mainControls.backgroundColor = UIColor.clear
        
        beforeHeading.backgroundColor = interface.heading
        mainHeading.backgroundColor = interface.heading
        afterHeading.backgroundColor = interface.heading
        
        // colors test view
        colorSchemeTestView.backgroundColor = interface.mainBackground
        ct1.backgroundColor = interface.buttonBackground
        ct2.backgroundColor = interface.tableBackground
        ct3.backgroundColor = interface.tableAltBackground
        ct4.backgroundColor = interface.heading
        ct5.backgroundColor = interface.text
        ct6.backgroundColor = interface.textIdle
        ct7.backgroundColor = interface.positive
        ct8.backgroundColor = interface.negative
        ct9.backgroundColor = interface.highlight
        
    }
    
    @IBOutlet weak var appnameButton: UIButton!
    @IBOutlet weak var beforeHeading: UIView!
    @IBOutlet weak var mainHeading: UIView!
    @IBOutlet weak var afterHeading: UIView!
    @IBOutlet weak var mainControls: UIView!
    @IBOutlet weak var colorSchemeTestView: UIView!
    
    @IBOutlet weak var ct1: UIView!
    @IBOutlet weak var ct2: UIView!
    @IBOutlet weak var ct3: UIView!
    @IBOutlet weak var ct4: UIView!
    @IBOutlet weak var ct5: UIView!
    @IBOutlet weak var ct6: UIView!
    @IBOutlet weak var ct7: UIView!
    @IBOutlet weak var ct8: UIView!
    @IBOutlet weak var ct9: UIView!
    
}

