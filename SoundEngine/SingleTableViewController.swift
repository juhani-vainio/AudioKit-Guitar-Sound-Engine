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
    
    @IBOutlet weak var savedSoundsTableView: UITableView!
    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var inputLevel: UISlider!
    @IBOutlet weak var outputLevel: UISlider!
   
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
       
       
        inputLevel.setValue(Float((audio.shared.inputBooster?.dB)!), animated: true)
        inputLevel.addTarget(self, action: #selector(inputLevelChanged), for: .valueChanged)
        outputLevel.setValue(Float((audio.shared.outputBooster?.dB)!), animated: true)
        outputLevel.addTarget(self, action: #selector(outputLevelChanged), for: .valueChanged)
        
        bufferLengthSegment.selectedSegmentIndex = settings.bufferLength - 1
        
        addButton.backgroundColor = interface.buttonBackground
        addButton.setTitleColor(interface.highlight, for: .normal)
        
        
        availableEffects.backgroundColor = interface.tableAltBackground
        selectedEffects.backgroundColor = UIColor.clear
       
        savedSoundsTableView.backgroundColor = interface.tableBackground
        
        mainCollection.backgroundColor = UIColor.clear
        mainViewBackground.backgroundColor = interface.mainBackground
 
        
    }
    
    @objc func inputLevelChanged(slider: UISlider) {
        audio.shared.inputBooster?.dB = Double(slider.value)
        print("Input --- \(audio.shared.inputBooster?.dB) dB")
    }
    
    @objc func outputLevelChanged(slider: UISlider) {
        audio.shared.outputBooster?.dB = Double(slider.value)
   
        print("Output --- \(audio.shared.outputBooster?.dB) dB --- \(audio.shared.outputBooster?.gain)")
    }

    // MARK: TABLEVIEWS
    func createTableViews() {
        // Arrange available units list aplhabetically
        audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
        availableEffects.delegate = self
        availableEffects.dataSource = self
        selectedEffects.delegate = self
        selectedEffects.dataSource = self
        savedSoundsTableView.delegate = self
        savedSoundsTableView.dataSource = self
        
        registerTableViewCells()
    }
    
    func registerTableViewCells() {
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        let doubleNib = UINib(nibName: "DoubleTableViewCell", bundle: nil)
        let tripleNib = UINib(nibName: "TripleTableViewCell", bundle: nil)
        let quatroNib = UINib(nibName: "QuatroTableViewCell", bundle: nil)
        let pentaNib = UINib(nibName: "PentaTableViewCell", bundle: nil)
        let hexaNib = UINib(nibName: "HexaTableViewCell", bundle: nil)
        let heptaNib = UINib(nibName: "HeptaTableViewCell", bundle: nil)
        let octaNib = UINib(nibName: "OctaTableViewCell", bundle: nil)
        selectedEffects.register(nib, forCellReuseIdentifier: "TableViewCell")
        selectedEffects.register(doubleNib, forCellReuseIdentifier: "DoubleTableViewCell")
        selectedEffects.register(tripleNib, forCellReuseIdentifier: "TripleTableViewCell")
        selectedEffects.register(quatroNib, forCellReuseIdentifier: "QuatroTableViewCell")
        selectedEffects.register(pentaNib, forCellReuseIdentifier: "PentaTableViewCell")
        selectedEffects.register(hexaNib, forCellReuseIdentifier: "HexaTableViewCell")
        selectedEffects.register(heptaNib, forCellReuseIdentifier: "HeptaTableViewCell")
        selectedEffects.register(octaNib, forCellReuseIdentifier: "OctaTableViewCell")
        
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
        if tableView == savedSoundsTableView {
            value = Collections.savedSounds.count
        }
        else if tableView == availableEffects {
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
        
        if tableView == savedSoundsTableView{
            cellTitle = Collections.savedSounds[indexPath.row]
        }
        else if tableView == selectedEffects {
            cellOpened = audio.selectedEffectsData[indexPath.row].opened
            cellTitle = audio.selectedEffectsData[indexPath.row].title
            cellType = audio.selectedEffectsData[indexPath.row].type
            cellIsLast = audio.selectedEffectsData.endIndex - 1 == indexPath.row
            cellId = audio.selectedEffectsData[indexPath.row].id
            
        }
    
        else {
            cellTitle = audio.availableEffectsData[indexPath.row].title
            
        }
        
        if tableView == availableEffects || tableView == savedSoundsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
            cell.textLabel?.text = cellTitle
            cell.textLabel?.textColor = interface.text
            cell.backgroundColor = interface.tableBackground
            cell.selectedBackgroundView = backgroundView
            
            returnCell = cell
            
        }
        else {
            
            switch cellType {
                
    
            case "1":
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
                
            case "2":
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
                
            case "3":
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
                
            case "4":
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
                
            case "5":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "PentaTableViewCell", for: indexPath) as! PentaTableViewCell
                
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
                
                let slider5 = audio.shared.getValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
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
                    if slider5.name.contains("ix") {
                        cell.slider5.isEnabled = false
                    }
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(5 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            case "6":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "HexaTableViewCell", for: indexPath) as! HexaTableViewCell
                
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
                
                let slider5 = audio.shared.getValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
                let slider6 = audio.shared.getValues(id: cellId, slider: 6)
                cell.slider6Title.text = slider6.name
                cell.slider6Value.text = slider6.value
                cell.slider6.minimumValue = slider6.min
                cell.slider6.maximumValue = slider6.max
                cell.slider6.value = slider6.valueForSlider
                
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
                    if slider5.name.contains("ix") {
                        cell.slider5.isEnabled = false
                    }
                    if slider6.name.contains("ix") {
                        cell.slider6.isEnabled = false
                    }
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(6 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            case "7":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeptaTableViewCell", for: indexPath) as! HeptaTableViewCell
                
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
                
                let slider5 = audio.shared.getValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
                let slider6 = audio.shared.getValues(id: cellId, slider: 6)
                cell.slider6Title.text = slider6.name
                cell.slider6Value.text = slider6.value
                cell.slider6.minimumValue = slider6.min
                cell.slider6.maximumValue = slider6.max
                cell.slider6.value = slider6.valueForSlider
                
                let slider7 = audio.shared.getValues(id: cellId, slider: 7)
                cell.slider7Title.text = slider7.name
                cell.slider7Value.text = slider7.value
                cell.slider7.minimumValue = slider7.min
                cell.slider7.maximumValue = slider7.max
                cell.slider7.value = slider7.valueForSlider
                
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
                    if slider5.name.contains("ix") {
                        cell.slider5.isEnabled = false
                    }
                    if slider6.name.contains("ix") {
                        cell.slider6.isEnabled = false
                    }
                    if slider7.name.contains("ix") {
                        cell.slider7.isEnabled = false
                    }
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(7 * 50)
                    cell.controllersView.isHidden = false
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                }
                returnCell = cell
                
            case "8":
                // Has two sliders
                let cell = tableView.dequeueReusableCell(withIdentifier: "OctaTableViewCell", for: indexPath) as! OctaTableViewCell
                
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
                
                let slider5 = audio.shared.getValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
                let slider6 = audio.shared.getValues(id: cellId, slider: 6)
                cell.slider6Title.text = slider6.name
                cell.slider6Value.text = slider6.value
                cell.slider6.minimumValue = slider6.min
                cell.slider6.maximumValue = slider6.max
                cell.slider6.value = slider6.valueForSlider
                
                let slider7 = audio.shared.getValues(id: cellId, slider: 7)
                cell.slider7Title.text = slider7.name
                cell.slider7Value.text = slider7.value
                cell.slider7.minimumValue = slider7.min
                cell.slider7.maximumValue = slider7.max
                cell.slider7.value = slider7.valueForSlider
                
                let slider8 = audio.shared.getValues(id: cellId, slider: 8)
                cell.slider8Title.text = slider8.name
                cell.slider8Value.text = slider8.value
                cell.slider8.minimumValue = slider8.min
                cell.slider8.maximumValue = slider8.max
                cell.slider8.value = slider8.valueForSlider
                
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
                    if slider5.name.contains("ix") {
                        cell.slider5.isEnabled = false
                    }
                    if slider6.name.contains("ix") {
                        cell.slider6.isEnabled = false
                    }
                    if slider7.name.contains("ix") {
                        cell.slider7.isEnabled = false
                    }
                    if slider8.name.contains("ix") {
                        cell.slider8.isEnabled = false
                    }
                }
                if cellOpened == true {
                    if cellIsLast {
                        cell.bottomConstraint.constant = 8
                    } else {
                        cell.bottomConstraint.constant = 0
                    }
                    cell.controllerHeight.constant = CGFloat(8 * 50)
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
        if tableView == savedSoundsTableView {
            let sound = Collections.savedSounds[indexPath.row]
            
            helper.shared.getSavedChain(name: sound)
            self.selectedEffects.reloadData()
            self.mainCollection.reloadData()
            self.resetEffectChain()
            savedSoundsTableView.isHidden = true
            
        }
        
        else if tableView == availableEffects {
            let tempData = audio.availableEffectsData[indexPath.row]
            audio.selectedEffectsData.append(tempData)
            self.selectedEffects.reloadData()
            audio.availableEffectsData.remove(at: indexPath.row)
            let row = IndexPath(item: indexPath.row, section: 0)
            self.availableEffects.deleteRows(at: [row], with: .none)
            self.availableEffects.isHidden = true
            self.resetEffectChain()
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
                audio.selectedEffectsData[indexPath.row].opened = false
                let tempData = audio.selectedEffectsData[indexPath.row]
                audio.availableEffectsData.append(tempData)
                // Arrange available units list aplhabetically
                audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
                self.availableEffects.reloadData()
                audio.selectedEffectsData.remove(at: indexPath.row)
                let row = IndexPath(item: indexPath.row, section: 0)
                self.selectedEffects.deleteRows(at: [row], with: .none)
                self.resetEffectChain()
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
        
        let mainNib = UINib(nibName: "EQCollectionViewCell", bundle: nil)
        mainCollection.register(mainNib, forCellWithReuseIdentifier: "EQCollectionViewCell")
        
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
        var cellId = String()
        
        if collectionView == mainCollection  {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EQCollectionViewCell", for: indexPath) as! EQCollectionViewCell
            cellId = "eq10"
            cell.id = cellId
            
            let slider1 = audio.shared.getEQValues(slider: 1)
            cell.slider1Title.text = slider1.name
            cell.slider1Value.text = slider1.value
            cell.slider1.minimumValue = slider1.min
            cell.slider1.maximumValue = slider1.max
            cell.slider1.value = slider1.valueForSlider
            
            let slider2 = audio.shared.getEQValues(slider: 2)
            cell.slider2Title.text = slider2.name
            cell.slider2Value.text = slider2.value
            cell.slider2.minimumValue = slider2.min
            cell.slider2.maximumValue = slider2.max
            cell.slider2.value = slider2.valueForSlider
            
            let slider3 = audio.shared.getEQValues(slider: 3)
            cell.slider3Title.text = slider3.name
            cell.slider3Value.text = slider3.value
            cell.slider3.minimumValue = slider3.min
            cell.slider3.maximumValue = slider3.max
            cell.slider3.value = slider3.valueForSlider
            
            let slider4 = audio.shared.getEQValues(slider: 4)
            cell.slider4Title.text = slider4.name
            cell.slider4Value.text = slider4.value
            cell.slider4.minimumValue = slider4.min
            cell.slider4.maximumValue = slider4.max
            cell.slider4.value = slider4.valueForSlider
            
            let slider5 = audio.shared.getEQValues(slider: 5)
            cell.slider5Title.text = slider5.name
            cell.slider5Value.text = slider5.value
            cell.slider5.minimumValue = slider5.min
            cell.slider5.maximumValue = slider5.max
            cell.slider5.value = slider5.valueForSlider
            
            let slider6 = audio.shared.getEQValues(slider: 6)
            cell.slider6Title.text = slider6.name
            cell.slider6Value.text = slider6.value
            cell.slider6.minimumValue = slider6.min
            cell.slider6.maximumValue = slider6.max
            cell.slider6.value = slider6.valueForSlider
            
            let slider7 = audio.shared.getEQValues(slider: 7)
            cell.slider7Title.text = slider7.name
            cell.slider7Value.text = slider7.value
            cell.slider7.minimumValue = slider7.min
            cell.slider7.maximumValue = slider7.max
            cell.slider7.value = slider7.valueForSlider
            
            let slider8 = audio.shared.getEQValues(slider: 8)
            cell.slider8Title.text = slider8.name
            cell.slider8Value.text = slider8.value
            cell.slider8.minimumValue = slider8.min
            cell.slider8.maximumValue = slider8.max
            cell.slider8.value = slider8.valueForSlider
            
            let slider9 = audio.shared.getEQValues(slider: 9)
            cell.slider9Title.text = slider9.name
            cell.slider9Value.text = slider9.value
            cell.slider9.minimumValue = slider9.min
            cell.slider9.maximumValue = slider9.max
            cell.slider9.value = slider9.valueForSlider
            
            let slider10 = audio.shared.getEQValues(slider: 10)
            cell.slider10Title.text = slider10.name
            cell.slider10Value.text = slider10.value
            cell.slider10.minimumValue = slider10.min
            cell.slider10.maximumValue = slider10.max
            cell.slider10.value = slider10.valueForSlider
            
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
    
    @IBAction func settingsButtonTapped(_ sender: Any) {
        if self.settingsView.isHidden {
            self.settingsView.isHidden = false
        } else {
            self.settingsView.isHidden = true
        }
    }
    
    @IBAction func bufferLengthSegmentAction(_ sender: UISegmentedControl) {
        let segment = sender.selectedSegmentIndex + 1
        audio.shared.setBufferLength(segment: segment)
        UserDefaults.standard.set(segment, forKey: "bufferLength")
        do {
            try AudioKit.stop()
        } catch {
            print("Could not stop AudioKit")
        }
        // START AUDIOKIT
        do {
            try AudioKit.start()
            print("START AUDIOKIT")
        } catch {
            print("Could not start AudioKit")
        }

        
    }
    
    
    @IBAction func loadSoundButtonAction(_ sender: Any) {
        if self.savedSoundsTableView.isHidden {
            self.savedSoundsTableView.isHidden = false
        }
    }
    
    @IBAction func saveSoundButtonAction(_ sender: Any) {
        popUpDialogueForNewSound()
    }
    
    // MARK: DIALOGUES
    
    func popUpDialogueForNewSound() {
        let alert = UIAlertController(title: "Name of your new sound?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Create an OK Button
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            
            if let name = alert.textFields?.first?.text {
                print("Your new sound is: \(name)")
                if self.nameCheck {
                    helper.shared.saveEffectChain(name: name)
                   
                }
                
            }
        })
        
        // Add the OK Button to the Alert Controller
        alert.addAction(okAction)
        self.nameCheck = false
        okAction.isEnabled = false
        // Add a text field to the alert controller
        alert.addTextField { (textField) in
            textField.enablesReturnKeyAutomatically = true
            textField.placeholder = "Input name here..."
            // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:textField , queue: OperationQueue.main, using: {_ in
                // Being in this block means that something fired the UITextFieldTextDidChange notification.
                let text = textField.text
                if Collections.savedSounds.contains(text!) || Collections.cantTouchThis.contains(text!) {
                    okAction.isEnabled = false
                    self.nameCheck = false
                }
                    
                else {
                    let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count ?? 0
                    let textIsNotEmpty = textCount > 0
                    self.nameCheck = textIsNotEmpty
                    okAction.isEnabled = textIsNotEmpty
                }
            })
        }
        
        self.present(alert, animated: true)
    }
    
}
