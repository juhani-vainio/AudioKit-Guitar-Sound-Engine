//
//  SingleTableViewController.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 05/12/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import AudioKit
import UIKit

fileprivate var longPressGesture: UILongPressGestureRecognizer!

class SingleTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
  
    var nameCheck = Bool()
    var effectChainNeedsReset = Bool(false)
    private let parallaxLayout = ParallaxFlowLayout()
    
    fileprivate var sourceIndexPath: IndexPath?
    fileprivate var snapshot: UIView?
    
    @IBOutlet weak var bufferLengthSegment: UISegmentedControl!
    @IBOutlet weak var mainViewBackground: UIView!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var availableEffects: UITableView!

    @IBOutlet weak var selectedEffects: UITableView!
    
    @IBOutlet weak var mainCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         // Set up Interface Colors
        Colors.palette.setInterfaceColorScheme(name: "spotify")
        
        
        
        
      
        
        audio.shared.createEffects()
        
        helper.shared.checkUserDefaults()
        
        createCollectionViews()
        createTableViews()
        
        
        
        audio.shared.startAudio()
        interfaceSetup()
    }
    
    
    func interfaceSetup() {
       
        bufferLengthSegment.selectedSegmentIndex = settings.bufferLenght - 1
        
        addButton.backgroundColor = interface.buttonBackground
        addButton.setTitleColor(interface.highlight, for: .normal)
        
        
        availableEffects.backgroundColor = interface.tableAltBackground
        selectedEffects.backgroundColor = UIColor.clear
       
        
        mainCollection.backgroundColor = UIColor.clear
        mainViewBackground.backgroundColor = interface.mainBackground
 
        
    }
    

    // MARK: TABLEVIEWS
    func createTableViews() {
        // Arrange available units list aplhabetically
        audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
        availableEffects.delegate = self
        availableEffects.dataSource = self
        selectedEffects.delegate = self
        selectedEffects.dataSource = self
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        let doubleNib = UINib(nibName: "DoubleTableViewCell", bundle: nil)
        let tripleNib = UINib(nibName: "TripleTableViewCell", bundle: nil)
        let quatroNib = UINib(nibName: "QuatroTableViewCell", bundle: nil)
        selectedEffects.register(nib, forCellReuseIdentifier: "TableViewCell")
        selectedEffects.register(doubleNib, forCellReuseIdentifier: "DoubleTableViewCell")
        selectedEffects.register(tripleNib, forCellReuseIdentifier: "TripleTableViewCell")
        selectedEffects.register(quatroNib, forCellReuseIdentifier: "QuatroTableViewCell")
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(longPress:)))
        selectedEffects.addGestureRecognizer(longPressGesture)
        
    }
    
    @objc func handleLongGesture(longPress: UILongPressGestureRecognizer) {
        let state = longPress.state
        let location = longPress.location(in: self.selectedEffects)
        guard let indexPath = self.selectedEffects.indexPathForRow(at: location) else { //Clean up
            self.cleanup()
            return
            
        }
        switch state {
        case .began:
            sourceIndexPath = indexPath
            guard let cell = self.selectedEffects.cellForRow(at: indexPath) else { return }
            // Take a snapshot of the selected row using helper method. See below method
            snapshot = self.customSnapshotFromView(inputView: cell)
            guard  let snapshot = self.snapshot else { return }
            var center = cell.center
            snapshot.center = center
            snapshot.alpha = 0.0
            self.selectedEffects.addSubview(snapshot)
            UIView.animate(withDuration: 0.25, animations: {
                center.y = location.y
                snapshot.center = center
                snapshot.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                snapshot.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { (finished) in
                cell.isHidden = true
            })
            break
        case .changed:
            guard  let snapshot = self.snapshot else {
                return
            }
            var center = snapshot.center
            center.y = location.y
            snapshot.center = center
            guard let sourceIndexPath = self.sourceIndexPath  else {
                return
            }
            if indexPath != sourceIndexPath {
                
                let removed = audio.selectedEffectsData.remove(at: sourceIndexPath.row)
                audio.selectedEffectsData.insert(removed, at: indexPath.row)
                
                //swap(&audio.selectedEffectsData[indexPath.row], &audio.selectedEffectsData[sourceIndexPath.row])
                self.selectedEffects.moveRow(at: sourceIndexPath, to: indexPath)
                self.sourceIndexPath = indexPath
                self.effectChainNeedsReset = true
            }
            break
        default:
            guard let cell = self.selectedEffects.cellForRow(at: indexPath) else {
                return
            }
            guard  let snapshot = self.snapshot else {
                return
            }
            cell.isHidden = false
            cell.alpha = 0.0
            UIView.animate(withDuration: 0.25, animations: {
                snapshot.center = cell.center
                snapshot.transform = CGAffineTransform.identity
                snapshot.alpha = 0
                cell.alpha = 1
            }, completion: { (finished) in
                self.cleanup()
            })
        }
    }
    
    private func cleanup() {
        if effectChainNeedsReset == true {
            resetEffectChain()
        }
        self.sourceIndexPath = nil
        snapshot?.removeFromSuperview()
        self.snapshot = nil
        self.effectChainNeedsReset = false
    }

    private func customSnapshotFromView(inputView: UIView) -> UIView? {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0)
        if let CurrentContext = UIGraphicsGetCurrentContext() {
            inputView.layer.render(in: CurrentContext)
        }
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()
        let snapshot = UIImageView(image: image)
        snapshot.layer.masksToBounds = false
        snapshot.layer.cornerRadius = 0
        snapshot.layer.shadowOffset = CGSize(width: -5, height: 0)
        snapshot.layer.shadowRadius = 5
        snapshot.layer.shadowOpacity = 0.4
        return snapshot
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        var value = 0
        if tableView == availableEffects {
            value = audio.availableEffectsData.count
            
        } else if tableView == selectedEffects {
            // unitsAfter List
            value = audio.selectedEffectsData.count
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        
        var returnCell = UITableViewCell()
        var cellOpened = Bool()
        var cellTitle = String()
        var cellType = String()
        var cellIsLast = Bool()
        var cellId = String()
        
        if tableView == selectedEffects {
            cellOpened = audio.selectedEffectsData[indexPath.row].opened
            cellTitle = audio.selectedEffectsData[indexPath.row].title
            cellType = audio.selectedEffectsData[indexPath.row].sliderRowsForTable
            cellIsLast = audio.selectedEffectsData.endIndex - 1 == indexPath.row
            cellId = audio.selectedEffectsData[indexPath.row].id
            
        }
    
        else {
            cellTitle = audio.availableEffectsData[indexPath.row].title
            
        }
        if tableView == availableEffects {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = cellTitle
            cell.textLabel?.textColor = interface.text
            cell.backgroundColor = interface.tableBackground
            cell.selectedBackgroundView = backgroundView
            
            returnCell = cell
            
        }
        else {
            
            switch cellType {
                
            case "double":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTableViewCell", for: indexPath) as! DoubleTableViewCell
                
                let slider1 = audio.shared.getValues(id: cellId, slider: 1)
                cell.slider1Title.text = slider1.name
                cell.slider1Value.text = slider1.value
                cell.slider1.minimumValue = slider1.min
                cell.slider1.maximumValue = slider1.max
                cell.slider1.value = slider1.valueForSlider
                
                let slider2 = audio.shared.getValues(id: cellId, slider: 2)
                cell.slider2Title.text = slider2.name
                cell.slider2Value.text = slider2.value
                cell.slider2.minimumValue = slider2.min
                cell.slider2.maximumValue = slider2.max
                cell.slider2.value = slider2.valueForSlider
                
                cell.id = cellId
                cell.title.text = cellTitle
                cell.selectedBackgroundView = backgroundView
                
                if slider1.isOn {
                    cell.onOffButton.setTitle("ON", for: .normal)
                    cell.onOffButton.setTitleColor(interface.text, for: .normal)
                } else {
                    cell.onOffButton.setTitle("OFF", for: .normal)
                    cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
                    if slider1.name.contains("ix") {
                        cell.slider1.isEnabled = false
                    }
                    if slider2.name.contains("ix") {
                        cell.slider2.isEnabled = false
                    }
                    
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(2 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            case "triple":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "TripleTableViewCell", for: indexPath) as! TripleTableViewCell
                let slider1 = audio.shared.getValues(id: cellId, slider: 1)
                cell.slider1Title.text = slider1.name
                cell.slider1Value.text = slider1.value
                cell.slider1.minimumValue = slider1.min
                cell.slider1.maximumValue = slider1.max
                cell.slider1.value = slider1.valueForSlider
                
                
                let slider2 = audio.shared.getValues(id: cellId, slider: 2)
                cell.slider2Title.text = slider2.name
                cell.slider2Value.text = slider2.value
                cell.slider2.minimumValue = slider2.min
                cell.slider2.maximumValue = slider2.max
                cell.slider2.value = slider2.valueForSlider
                
                
                let slider3 = audio.shared.getValues(id: cellId, slider: 3)
                cell.slider3Title.text = slider3.name
                cell.slider3Value.text = slider3.value
                cell.slider3.minimumValue = slider3.min
                cell.slider3.maximumValue = slider3.max
                cell.slider3.value = slider3.valueForSlider
                
                cell.id = cellId
                cell.title.text = cellTitle
                cell.selectedBackgroundView = backgroundView
                
                if slider1.isOn {
                    cell.onOffButton.setTitle("ON", for: .normal)
                    cell.onOffButton.setTitleColor(interface.text, for: .normal)
                } else {
                    cell.onOffButton.setTitle("OFF", for: .normal)
                    cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
                    if slider1.name.contains("ix") {
                        cell.slider1.isEnabled = false
                    }
                    if slider2.name.contains("ix") {
                        cell.slider2.isEnabled = false
                    }
                    if slider3.name.contains("ix") {
                        cell.slider3.isEnabled = false
                    }
                    
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(3 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            case "quatro":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuatroTableViewCell", for: indexPath) as! QuatroTableViewCell
                
                let slider1 = audio.shared.getValues(id: cellId, slider: 1)
                cell.slider1Title.text = slider1.name
                cell.slider1Value.text = slider1.value
                cell.slider1.minimumValue = slider1.min
                cell.slider1.maximumValue = slider1.max
                cell.slider1.value = slider1.valueForSlider
                
                let slider2 = audio.shared.getValues(id: cellId, slider: 2)
                cell.slider2Title.text = slider2.name
                cell.slider2Value.text = slider2.value
                cell.slider2.minimumValue = slider2.min
                cell.slider2.maximumValue = slider2.max
                cell.slider2.value = slider2.valueForSlider
                
                let slider3 = audio.shared.getValues(id: cellId, slider: 3)
                cell.slider3Title.text = slider3.name
                cell.slider3Value.text = slider3.value
                cell.slider3.minimumValue = slider3.min
                cell.slider3.maximumValue = slider3.max
                cell.slider3.value = slider3.valueForSlider
                
                let slider4 = audio.shared.getValues(id: cellId, slider: 4)
                cell.slider4Title.text = slider4.name
                cell.slider4Value.text = slider4.value
                cell.slider4.minimumValue = slider4.min
                cell.slider4.maximumValue = slider4.max
                cell.slider4.value = slider4.valueForSlider
                
                cell.id = cellId
                cell.title.text = cellTitle
                cell.selectedBackgroundView = backgroundView
                
                if slider1.isOn {
                    cell.onOffButton.setTitle("ON", for: .normal)
                    cell.onOffButton.setTitleColor(interface.text, for: .normal)
                } else {
                    cell.onOffButton.setTitle("OFF", for: .normal)
                    cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
                    if slider1.name.contains("ix") {
                        cell.slider1.isEnabled = false
                    }
                    if slider2.name.contains("ix") {
                        cell.slider2.isEnabled = false
                    }
                    if slider3.name.contains("ix") {
                        cell.slider3.isEnabled = false
                    }
                    if slider4.name.contains("ix") {
                        cell.slider4.isEnabled = false
                    }
                    
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(4 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            default:
                // One slider
                let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                
                let slider = audio.shared.getValues(id: cellId, slider: 1)
                cell.sliderTitle.text = slider.name
                cell.sliderValue.text = slider.value
                cell.slider.minimumValue = slider.min
                cell.slider.maximumValue = slider.max
                cell.slider.value = slider.valueForSlider
                
                cell.id = cellId
                cell.title.text = cellTitle
                cell.selectedBackgroundView = backgroundView
                
                if slider.isOn {
                    cell.onOffButton.setTitle("ON", for: .normal)
                    cell.onOffButton.setTitleColor(interface.text, for: .normal)
                } else {
                    cell.onOffButton.setTitle("OFF", for: .normal)
                    cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
                    if slider.name.contains("ix") {
                        cell.slider.isEnabled = false
                    }
                    
                }
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
                
                returnCell = cell
            }
        }
        
        return returnCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == availableEffects {
            let tempData = audio.availableEffectsData[indexPath.row]
            audio.selectedEffectsData.append(tempData)
            self.selectedEffects.reloadData()
            audio.availableEffectsData.remove(at: indexPath.row)
            let row = IndexPath(item: indexPath.row, section: 0)
            self.availableEffects.deleteRows(at: [row], with: .none)
            self.availableEffects.isHidden = true
        }
        else {
     
            if audio.selectedEffectsData[indexPath.row].opened == true {
                audio.selectedEffectsData[indexPath.row].opened = false
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
            else {
                audio.selectedEffectsData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
            }
      
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if tableView == selectedEffects {
            if audio.selectedEffectsData[indexPath.row].opened {
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
            
             if tableView == selectedEffects {
                // remove and insert data between arrays
                let tempData = audio.selectedEffectsData[indexPath.row]
                audio.availableEffectsData.append(tempData)
                // Arrange available units list aplhabetically
                audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
                self.availableEffects.reloadData()
                audio.selectedEffectsData.remove(at: indexPath.row)
                let row = IndexPath(item: indexPath.row, section: 0)
                self.selectedEffects.deleteRows(at: [row], with: .none)
            }
            
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if tableView == selectedEffects {
            return true
            }
        else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //let removed = audio.selectedEffectsData.remove(at: sourceIndexPath.row)
        //audio.selectedEffectsData.insert(removed, at: destinationIndexPath.row)
        
        resetEffectChain()
        
        print("Starting Index: \(sourceIndexPath.item)")
        print("Ending Index: \(destinationIndexPath.item)")
        
    }
    
    func resetEffectChain() {
      //  unplugEffects()
       // connectEffects()
        print("Effect Order changed")
        print(audio.selectedEffectsData)
        helper.shared.saveCurrentSettings()
        audio.shared.resetAudioEffects()
        
        
    }
    
    /*
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
     
    }
    */
    
    
    
    // MARK: COLLECTION VIEWS
    
    func createCollectionViews() {
        
        mainCollection.delegate = self
        
        
        mainCollection.dataSource = self
        
        
        mainCollection.collectionViewLayout = parallaxLayout
        
        registerCollectionViewCells()
        
        
        
    }
    
    
    func registerCollectionViewCells() {
        
        let mainNib = UINib(nibName: "DefaultMainCollectionViewCell", bundle: nil)
        mainCollection.register(mainNib, forCellWithReuseIdentifier: "DefaultMainCollectionViewCell")
        
        let compressNib = UINib(nibName: "CompressionCollectionViewCell", bundle: nil)
        mainCollection.register(compressNib, forCellWithReuseIdentifier: "CompressionCollectionViewCell")
        
        let balanceNib = UINib(nibName: "BalanceCollectionViewCell", bundle: nil)
        mainCollection.register(balanceNib, forCellWithReuseIdentifier: "BalanceCollectionViewCell")
        
        let expandNib = UINib(nibName: "ExpandCollectionViewCell", bundle: nil)
        mainCollection.register(expandNib, forCellWithReuseIdentifier: "ExpandCollectionViewCell")
        
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
        if self.availableEffects.isHidden {
            self.availableEffects.isHidden = false
        } else {
            self.availableEffects.isHidden = true
        }
        
    }
    

    @IBAction func bufferLengthSegmentAction(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex + 1
        audio.shared.setBufferLength(segment: segment)
        UserDefaults.standard.set(segment, forKey: "bufferLength")
        
    }
    
}
