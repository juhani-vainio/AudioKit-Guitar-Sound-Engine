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
    var data = [String]()
    var isOn = Bool()
    var height = CGFloat()
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

    @IBOutlet weak var availableUnits: UITableView!
    @IBOutlet weak var unitsAfter: UITableView!
    @IBOutlet weak var unitsBefore: UITableView!
    

    @IBOutlet weak var mainCollection: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        
        // VÄLIAIKAINEN MALLI
        availableUnitsData = [
                unitData(opened: false, title: "Variable Delay", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 90),
                unitData(opened: false, title: "OverDrive", data: ["value 0.2, gain 2, isOn false"], isOn: true, height: 30),
                unitData(opened: false, title: "Tanh Distortion", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 120),
                unitData(opened: false, title: "Compressor", data: ["value 0.2, gain 2, isOn false"], isOn: true, height: 60)]
        
      // VÄLIAIKAINEN MALLI
        selectedUnitsAfterData = [
            unitData(opened: false, title: "Delay", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 90),
                unitData(opened: false, title: "Drive", data: ["value 0.2, gain 2, isOn false"], isOn: true, height: 30)
        
        ]
        // VÄLIAIKAINEN MALLI
        selectedUnitsBeforeData = [
            unitData(opened: false, title: "Clipper", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 90),
            unitData(opened: false, title: "Wah Wah!", data: ["time 0.2, feedback 1.2, isOn true"], isOn: false, height: 90),
            unitData(opened: false, title: "Decimator", data: ["value 0.2, gain 2, isOn false"], isOn: false, height: 120)
            
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
         if tableView == availableUnits {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = availableUnitsData[indexPath.row].title
            return cell
            
      
         } else if tableView == unitsAfter {
            // unitsAfter List
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.title.text = selectedUnitsAfterData[indexPath.row].title
            if selectedUnitsAfterData[indexPath.row].opened == true {
                cell.controllerHeight.constant = selectedUnitsAfterData[indexPath.row].height
            } else {
                cell.controllerHeight.constant = 0
            }
            if selectedUnitsAfterData[indexPath.row].isOn == true {
                cell.onOffButton.setTitle("OFF", for: .normal)
            } else {
                cell.onOffButton.setTitle("ON", for: .normal)
            }
            return cell
            
         } else {
            // unitsBefore List
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            cell.title.text = selectedUnitsBeforeData[indexPath.row].title
            if selectedUnitsBeforeData[indexPath.row].opened == true {
                cell.controllerHeight.constant = selectedUnitsBeforeData[indexPath.row].height
            } else {
                cell.controllerHeight.constant = 0
            }
            if selectedUnitsBeforeData[indexPath.row].isOn == true {
                cell.onOffButton.setTitle("OFF", for: .normal)
            } else {
                cell.onOffButton.setTitle("ON", for: .normal)
            }
            
            
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
                tableView.reloadRows(at: [row], with: .none)
            }
            else {
                selectedUnitsBeforeData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .none)
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
    
    
    
    @IBAction func addToUnitsBefore(_ sender: Any) {
        self.availableUnits.isHidden = false
        self.activateBefore = true
    }
    
    
    @IBAction func addToUnitsAfter(_ sender: Any) {
        self.availableUnits.isHidden = false
        self.activateBefore = false
    }
    
    
    @IBAction func checkButton(_ sender: Any) {
        print("AVAILABLE")
        print(self.availableUnitsData)
        print("SELECTED")
        print(self.selectedUnitsAfterData)
    }
    var activateBefore = Bool()
}

