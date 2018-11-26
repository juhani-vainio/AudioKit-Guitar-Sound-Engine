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
    var type = String()

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
            unitData(opened: false, title: "Variable Delay", sliders: ["VD time 0.2", "VD feedback 1.2", "isOn true"], isOn: false, type: "triple"),
                unitData(opened: false, title: "OverDrive", sliders: ["OD value 0.2", "OD gain 2", "isOn false"], isOn: true, type: "triple"),
                unitData(opened: false, title: "Tanh Distortion", sliders: ["TD time 0.2", "TD feedback 1.2", "isOn true"], isOn: false, type: "triple"),
                unitData(opened: false, title: "Compressor", sliders: ["C value 0.2", "C gain 2", "isOn false"], isOn: true, type: "triple")
        ]
        
      // VÄLIAIKAINEN MALLI
        selectedUnitsAfterData = [
            unitData(opened: false, title: "Delay", sliders: ["D time 0.2", "D feedback 1.2", "D cutoff 0.2", "mix 0.4"], isOn: false, type: "quatro"),
                unitData(opened: false, title: "Drive", sliders: ["Drive 0.2", "gain 10"], isOn: true, type: "double")
        
        ]
        // VÄLIAIKAINEN MALLI
        selectedUnitsBeforeData = [
            unitData(opened: false, title: "Clipper", sliders: ["clip 0.2"], isOn: false, type: "single"),
            unitData(opened: false, title: "Wah Wah!", sliders: ["Wah 0.2", "Wah feedback 1.2", "Wah mix 0.4"], isOn: false, type: "triple"),
            unitData(opened: false, title: "Decimator", sliders: ["Decimate 0.2", "gain 0.6"], isOn: false, type: "double")
            
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
        
        
        unitsAfter.roundedAllCorner()
        unitsBefore.roundedAllCorner()
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        let doubleNib = UINib(nibName: "DoubleTableViewCell", bundle: nil)
        let tripleNib = UINib(nibName: "TripleTableViewCell", bundle: nil)
        let quatroNib = UINib(nibName: "QuatroTableViewCell", bundle: nil)
        unitsAfter.register(nib, forCellReuseIdentifier: "TableViewCell")
        unitsBefore.register(nib, forCellReuseIdentifier: "TableViewCell")
        unitsAfter.register(doubleNib, forCellReuseIdentifier: "DoubleTableViewCell")
        unitsBefore.register(doubleNib, forCellReuseIdentifier: "DoubleTableViewCell")
        unitsAfter.register(tripleNib, forCellReuseIdentifier: "TripleTableViewCell")
        unitsBefore.register(tripleNib, forCellReuseIdentifier: "TripleTableViewCell")
        unitsAfter.register(quatroNib, forCellReuseIdentifier: "QuatroTableViewCell")
        unitsBefore.register(quatroNib, forCellReuseIdentifier: "QuatroTableViewCell")
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
        
        var returnCell = UITableViewCell()
        var cellOpened = Bool()
        var cellTitle = String()
        var cellSliders = [String]()
        var cellIsOn = Bool()
        var cellType = String()
        var cellIsLast = Bool()
        
        if tableView == unitsBefore {
            cellOpened = selectedUnitsBeforeData[indexPath.row].opened
            cellTitle = selectedUnitsBeforeData[indexPath.row].title
            cellSliders = selectedUnitsBeforeData[indexPath.row].sliders
            cellIsOn = selectedUnitsBeforeData[indexPath.row].isOn
            cellType = selectedUnitsBeforeData[indexPath.row].type
            cellIsLast = selectedUnitsBeforeData.endIndex - 1 == indexPath.row
   
        }
        else if tableView == unitsAfter {
            cellOpened = selectedUnitsAfterData[indexPath.row].opened
            cellTitle = selectedUnitsAfterData[indexPath.row].title
            cellSliders = selectedUnitsAfterData[indexPath.row].sliders
            cellIsOn = selectedUnitsAfterData[indexPath.row].isOn
            cellType = selectedUnitsAfterData[indexPath.row].type
            cellIsLast = selectedUnitsAfterData.endIndex - 1 == indexPath.row
        }
        
        if tableView == availableUnits {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = availableUnitsData[indexPath.row].title
                cell.textLabel?.textColor = interface.text
                cell.backgroundColor = interface.tableBackground
                cell.selectedBackgroundView = backgroundView
            
            returnCell = cell
            
         }
        else {
            // unitsAfter List
           
            switch cellType {
            case "double":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTableViewCell", for: indexPath) as! DoubleTableViewCell
                cell.title.text = cellTitle
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(50 * 2)
                    cell.controllersView.isHidden = false
                    cell.slider2Title.text = cellSliders[1]
                    cell.slider1Title.text = cellSliders[0]
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                cell.selectedBackgroundView = backgroundView
                returnCell = cell
            case "triple":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "TripleTableViewCell", for: indexPath) as! TripleTableViewCell
                cell.title.text = cellTitle
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(50 * 3)
                    cell.controllersView.isHidden = false
                    cell.slider3Title.text = cellSliders[2]
                    cell.slider2Title.text = cellSliders[1]
                    cell.slider1Title.text = cellSliders[0]
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                cell.selectedBackgroundView = backgroundView
                returnCell = cell
            case "quatro":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuatroTableViewCell", for: indexPath) as! QuatroTableViewCell
                cell.title.text = cellTitle
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(50 * 4)
                    cell.controllersView.isHidden = false
                    cell.slider4Title.text = cellSliders[3]
                    cell.slider3Title.text = cellSliders[2]
                    cell.slider2Title.text = cellSliders[1]
                    cell.slider1Title.text = cellSliders[0]
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                cell.selectedBackgroundView = backgroundView
                returnCell = cell
            default:
                // One slider
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                cell.title.text = cellTitle
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                cell.selectedBackgroundView = backgroundView
                returnCell = cell
            }
        }
        
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == availableUnits {
            
        }
        else if tableView == unitsAfter {
            // unitsAfter List
            if selectedUnitsAfterData[indexPath.row].opened == true {
                selectedUnitsAfterData[indexPath.row].opened = false
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
            else {
                selectedUnitsAfterData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
            //tableView.reloadData()
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
            //tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        if tableView == unitsBefore {
            if selectedUnitsBeforeData[indexPath.row].opened {
                return false
            }
            else {
                return true
            }
        }
        
       else if tableView == unitsAfter {
            if selectedUnitsAfterData[indexPath.row].opened {
                return false
            }
            else {
                return true
            }
        }
        
        else {
            return true
        }
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

extension UIView{
    func roundedTopLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    
    func roundedTopRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottomRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedBottom(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.bottomRight , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedTop(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedRight(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
    func roundedAllCorner(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topRight , .bottomRight , .topLeft , .bottomLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = bounds
        maskLayer1.path = maskPath1.cgPath
        layer.mask = maskLayer1
    }
}
