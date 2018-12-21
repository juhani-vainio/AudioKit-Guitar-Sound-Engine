//
//  SingleTableViewController.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 05/12/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import AudioKit
import AudioKitUI
import UIKit

fileprivate var longPressGesture: UILongPressGestureRecognizer!

class SingleTableViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource  {
  
   
    var nameCheck = Bool()
    var effectChainNeedsReset = Bool(false)
    private let parallaxLayout = ParallaxFlowLayout()
    
    @IBOutlet weak var plotsMainView: UIView!
    @IBOutlet weak var waveformView: UIView!
    
    @IBOutlet weak var plotView1: UIView!
    @IBOutlet weak var plotView2: UIView!
    
    
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
        
        audio.shared.audioKitSettings()
        
        audio.shared.startAudio()
        interfaceSetup()
    }
    
    
    func interfaceSetup() {
       
       
        inputLevel.setValue(Float((audio.shared.inputBooster?.dB)!), animated: true)
        inputLevel.addTarget(self, action: #selector(inputLevelChanged), for: .valueChanged)
        inputLevel.addTarget(self, action: #selector(inputLevelChangeEnded), for: .touchUpInside)
        outputLevel.setValue(Float((audio.shared.outputBooster?.dB)!), animated: true)
        outputLevel.addTarget(self, action: #selector(outputLevelChanged), for: .valueChanged)
        outputLevel.addTarget(self, action: #selector(outputLevelChangeEnded), for: .touchUpInside)
        
        bufferLengthSegment.selectedSegmentIndex = settings.bufferLength - 1
        
        addButton.backgroundColor = interface.buttonBackground
        addButton.setTitleColor(interface.highlight, for: .normal)
        
        
        availableEffects.backgroundColor = interface.tableAltBackground
        selectedEffects.backgroundColor = UIColor.clear
       
        savedSoundsTableView.backgroundColor = interface.tableBackground
        
        mainCollection.backgroundColor = UIColor.clear
        mainViewBackground.backgroundColor = interface.mainBackground
 
        
        buildWaveforStackView()
       // updateWaveformView()
    
        
        
        
        
    }
    
    func updateWaveformView(){
        
        var oscillator = AKOscillator(waveform: AKTable(.sine))
        
        // var oscillator = AKFMOscillator(waveform: AKTable(.sine))
        oscillator.frequency = 512
        
        let clip = AKClipper(oscillator, limit: 0.9)
        let reverb = AKReverb(clip, dryWetMix: 0.5)
        AudioKit.output = AKBooster(reverb, gain: 0.0)
        do { try AudioKit.start()
            print("START AUDIOKIT")
        } catch {
            print("Could not start THIS FUCKING AudioKit")
        }
        oscillator.start()
        /*
        let plot1 = AKNodeOutputPlot(oscillator, frame: CGRect(x: 0, y: 0, width: plotView1.frame.width, height: plotView1.frame.height))
        plot1.plotType = .buffer
        plot1.shouldFill = false
        plot1.shouldMirror = false
        plot1.color = AKColor.blue
        plotView1.addSubview(plot1)
        
        let plot2 = AKNodeOutputPlot(clip, frame: CGRect(x: 0, y: 0, width: plotView2.frame.width, height: plotView2.frame.height))
        plot2.plotType = .buffer
        plot2.shouldFill = false
        plot2.shouldMirror = false
        plot2.color = AKColor.blue
        plotView2.addSubview(plot2)
        */
        
        var stackUnit1 = AKNodeOutputPlot(oscillator, frame: CGRect(x: 0, y: 0, width: waveformView.frame.width / 3, height: 80))
        stackUnit1.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackUnit1.widthAnchor.constraint(equalToConstant: waveformView.frame.width / 3).isActive = true
        stackUnit1.plotType = .buffer
        stackUnit1.shouldFill = false
        stackUnit1.shouldMirror = false
        stackUnit1.color = AKColor.blue
        
        var stackUnit2 = AKNodeOutputPlot(clip, frame: CGRect(x: 0, y: 0, width: waveformView.frame.width / 3, height: 80))
        stackUnit2.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackUnit2.widthAnchor.constraint(equalToConstant: waveformView.frame.width / 3).isActive = true
        stackUnit2.plotType = .buffer
        stackUnit2.shouldFill = false
        stackUnit2.shouldMirror = false
        stackUnit2.color = AKColor.blue
        
        var stackUnit3 = AKNodeOutputPlot(reverb, frame: CGRect(x: 0, y: 0, width: waveformView.frame.width / 3, height: 80))
        stackUnit3.heightAnchor.constraint(equalToConstant: 80).isActive = true
        stackUnit3.widthAnchor.constraint(equalToConstant: waveformView.frame.width / 3).isActive = true
        stackUnit3.plotType = .buffer
        stackUnit3.shouldFill = false
        stackUnit3.shouldMirror = false
        stackUnit3.color = AKColor.blue
        
        
        var stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 0
        
        
        stack.addArrangedSubview(stackUnit1)
        stack.addArrangedSubview(stackUnit2)
        stack.addArrangedSubview(stackUnit3)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        waveformView.addSubview(stack)
        
        //Constraints
        stack.centerXAnchor.constraint(equalTo: waveformView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: waveformView.centerYAnchor).isActive = true

        stackUnit1.backgroundColor = UIColor.green
        stackUnit2.backgroundColor = UIColor.brown
        stackUnit3.backgroundColor = UIColor.cyan
        
    }
    
    var recyclabeView = UIView()
    
    func buildWaveforStackView() {
        
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 0
        
        let units = audio.selectedAudioInputs.count
        let stackUnitWidth = waveformView.frame.width / CGFloat(units)
        var unitCount = 0
        for unit in audio.selectedAudioInputs {
                unit.outputNode.removeTap(onBus: 0)
                let node = unit as! AKNode
                let stackUnit = AKNodeOutputPlot(node, frame: CGRect(x: 0, y: 0, width: stackUnitWidth, height: 80))
                stackUnit.heightAnchor.constraint(equalToConstant: 80).isActive = true
                stackUnit.widthAnchor.constraint(equalToConstant: stackUnitWidth).isActive = true
                stackUnit.plotType = .buffer
                stackUnit.shouldFill = false
                stackUnit.shouldMirror = false
               // let nextColor = Colors.palette.materialDesignColors(x: unitCount, y: unitCount)
                let name = audio.selectedEffectsData[unitCount].id
                let color = Colors.palette.colorForEffect(name: name)
                stackUnit.color = color
                stackUnit.backgroundColor = interface.heading
                stack.addArrangedSubview(stackUnit)
         
            unitCount = unitCount + 1
            
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        
        recyclabeView = UIView(frame: CGRect(x: 0, y: 0, width: waveformView.frame.width, height: waveformView.frame.height))
        recyclabeView.addSubview(stack)
        waveformView.addSubview(recyclabeView)

        //Constraints
        stack.centerXAnchor.constraint(equalTo: waveformView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: waveformView.centerYAnchor).isActive = true
        
    }
    
    
    @objc func inputLevelChanged(slider: UISlider) {
        audio.shared.inputBooster?.dB = Double(slider.value)
      //  print("Input --- \(audio.shared.inputBooster?.dB) dB")
    }
    
    @objc func inputLevelChangeEnded(slider: UISlider) {
        
        UserDefaults.standard.set(audio.shared.inputBooster?.dB, forKey: "inputBooster")
    }
    
    @objc func outputLevelChanged(slider: UISlider) {
        audio.shared.outputBooster?.dB = Double(slider.value)
      //  print("Output --- \(audio.shared.outputBooster?.dB) dB --- \(audio.shared.outputBooster?.gain)")
    }
    
    @objc func outputLevelChangeEnded(slider: UISlider) {
     
        UserDefaults.standard.set(audio.shared.outputBooster?.dB, forKey: "outputBooster")
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
        var cellIsSpecial = Bool()
        
        if tableView == savedSoundsTableView{
            cellTitle = Collections.savedSounds[indexPath.row]
        }
        else if tableView == selectedEffects {
            cellOpened = audio.selectedEffectsData[indexPath.row].opened
            cellTitle = audio.selectedEffectsData[indexPath.row].title
            cellType = audio.selectedEffectsData[indexPath.row].type
            cellIsLast = audio.selectedEffectsData.endIndex - 1 == indexPath.row
            cellId = audio.selectedEffectsData[indexPath.row].id
            if Collections.specialEffects.contains(cellId) {
                cellIsSpecial = true
            }
            else {
                cellIsSpecial = false
            }
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                }
                else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial == true {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    if cellIsSpecial {
                        cell.specialViewHeight.constant = CGFloat(50)
                        cell.specialView.isHidden = false
                    }
                    else {
                        cell.specialViewHeight.constant = CGFloat(0)
                        cell.specialView.isHidden = true
                    }
                } else {
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
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
                
                if cellIsSpecial {
                    let special = audio.shared.getValues(id: cellId, slider: 0)
                    cell.specialTitle.text = special.name
                    if special.valueForSlider == 0 {
                        cell.specialSwitch.isOn = false
                    } else {
                        cell.specialSwitch.isOn = true
                    }
                }
                
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
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
                
                
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
            
           if audio.selectedEffectsData[indexPath.row].opened == false {
                // close previous cell
                if let previous = audio.selectedEffectsData.firstIndex(where: {$0.opened == true}) {
                    audio.selectedEffectsData[previous].opened = false
                    let row = IndexPath(item: previous, section: 0)
                    tableView.reloadRows(at: [row], with: .fade)
                }
                // open this cell
                audio.selectedEffectsData[indexPath.row].opened = true
                let row = IndexPath(item: indexPath.row, section: 0)
                tableView.reloadRows(at: [row], with: .fade)
                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
           else {
            audio.selectedEffectsData[indexPath.row].opened = false
            let row = IndexPath(item: indexPath.row, section: 0)
            tableView.reloadRows(at: [row], with: .fade)

            }
            /*
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
             */
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
        
        // remove old waveform plots
        

        
        buildWaveforStackView()
        
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
        
        let eqNib = UINib(nibName: "EQCollectionViewCell", bundle: nil)
        mainCollection.register(eqNib, forCellWithReuseIdentifier: "EQCollectionViewCell")
        
        let eq31Nib = UINib(nibName: "EQ31CollectionViewCell", bundle: nil)
        mainCollection.register(eq31Nib, forCellWithReuseIdentifier: "EQ31CollectionViewCell")
        
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
        cellId = "eq31"
        audio.shared.switchEQBandwidthRatio(id: cellId)
        if collectionView == mainCollection  {
            if cellId == "eq10" {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EQCollectionViewCell", for: indexPath) as! EQCollectionViewCell
                cell.id = cellId
                
                let slider1 = audio.shared.getEQValues(id: cellId, slider: 1)
                cell.slider1Title.text = slider1.name
                cell.slider1Value.text = slider1.value
                cell.slider1.minimumValue = slider1.min
                cell.slider1.maximumValue = slider1.max
                cell.slider1.value = slider1.valueForSlider
                
                let slider2 = audio.shared.getEQValues(id: cellId, slider: 2)
                cell.slider2Title.text = slider2.name
                cell.slider2Value.text = slider2.value
                cell.slider2.minimumValue = slider2.min
                cell.slider2.maximumValue = slider2.max
                cell.slider2.value = slider2.valueForSlider
                
                let slider3 = audio.shared.getEQValues(id: cellId, slider: 3)
                cell.slider3Title.text = slider3.name
                cell.slider3Value.text = slider3.value
                cell.slider3.minimumValue = slider3.min
                cell.slider3.maximumValue = slider3.max
                cell.slider3.value = slider3.valueForSlider
                
                let slider4 = audio.shared.getEQValues(id: cellId, slider: 4)
                cell.slider4Title.text = slider4.name
                cell.slider4Value.text = slider4.value
                cell.slider4.minimumValue = slider4.min
                cell.slider4.maximumValue = slider4.max
                cell.slider4.value = slider4.valueForSlider
                
                let slider5 = audio.shared.getEQValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
                let slider6 = audio.shared.getEQValues(id: cellId, slider: 6)
                cell.slider6Title.text = slider6.name
                cell.slider6Value.text = slider6.value
                cell.slider6.minimumValue = slider6.min
                cell.slider6.maximumValue = slider6.max
                cell.slider6.value = slider6.valueForSlider
                
                let slider7 = audio.shared.getEQValues(id: cellId, slider: 7)
                cell.slider7Title.text = slider7.name
                cell.slider7Value.text = slider7.value
                cell.slider7.minimumValue = slider7.min
                cell.slider7.maximumValue = slider7.max
                cell.slider7.value = slider7.valueForSlider
                
                let slider8 = audio.shared.getEQValues(id: cellId, slider: 8)
                cell.slider8Title.text = slider8.name
                cell.slider8Value.text = slider8.value
                cell.slider8.minimumValue = slider8.min
                cell.slider8.maximumValue = slider8.max
                cell.slider8.value = slider8.valueForSlider
                
                let slider9 = audio.shared.getEQValues(id: cellId, slider: 9)
                cell.slider9Title.text = slider9.name
                cell.slider9Value.text = slider9.value
                cell.slider9.minimumValue = slider9.min
                cell.slider9.maximumValue = slider9.max
                cell.slider9.value = slider9.valueForSlider
                
                let slider10 = audio.shared.getEQValues(id: cellId, slider: 10)
                cell.slider10Title.text = slider10.name
                cell.slider10Value.text = slider10.value
                cell.slider10.minimumValue = slider10.min
                cell.slider10.maximumValue = slider10.max
                cell.slider10.value = slider10.valueForSlider
                
                returnCell = cell
            
            }
        
            else if cellId == "eq31" {
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EQ31CollectionViewCell", for: indexPath) as! EQ31CollectionViewCell
                cell.id = cellId
                
                let slider1 = audio.shared.getEQValues(id: cellId, slider: 1)
                cell.slider1Title.text = slider1.name
                cell.slider1Value.text = slider1.value
                cell.slider1.minimumValue = slider1.min
                cell.slider1.maximumValue = slider1.max
                cell.slider1.value = slider1.valueForSlider
                
                let slider2 = audio.shared.getEQValues(id: cellId, slider: 2)
                cell.slider2Title.text = slider2.name
                cell.slider2Value.text = slider2.value
                cell.slider2.minimumValue = slider2.min
                cell.slider2.maximumValue = slider2.max
                cell.slider2.value = slider2.valueForSlider
                
                let slider3 = audio.shared.getEQValues(id: cellId, slider: 3)
                cell.slider3Title.text = slider3.name
                cell.slider3Value.text = slider3.value
                cell.slider3.minimumValue = slider3.min
                cell.slider3.maximumValue = slider3.max
                cell.slider3.value = slider3.valueForSlider
                
                let slider4 = audio.shared.getEQValues(id: cellId, slider: 4)
                cell.slider4Title.text = slider4.name
                cell.slider4Value.text = slider4.value
                cell.slider4.minimumValue = slider4.min
                cell.slider4.maximumValue = slider4.max
                cell.slider4.value = slider4.valueForSlider
                
                let slider5 = audio.shared.getEQValues(id: cellId, slider: 5)
                cell.slider5Title.text = slider5.name
                cell.slider5Value.text = slider5.value
                cell.slider5.minimumValue = slider5.min
                cell.slider5.maximumValue = slider5.max
                cell.slider5.value = slider5.valueForSlider
                
                let slider6 = audio.shared.getEQValues(id: cellId, slider: 6)
                cell.slider6Title.text = slider6.name
                cell.slider6Value.text = slider6.value
                cell.slider6.minimumValue = slider6.min
                cell.slider6.maximumValue = slider6.max
                cell.slider6.value = slider6.valueForSlider
                
                let slider7 = audio.shared.getEQValues(id: cellId, slider: 7)
                cell.slider7Title.text = slider7.name
                cell.slider7Value.text = slider7.value
                cell.slider7.minimumValue = slider7.min
                cell.slider7.maximumValue = slider7.max
                cell.slider7.value = slider7.valueForSlider
                
                let slider8 = audio.shared.getEQValues(id: cellId, slider: 8)
                cell.slider8Title.text = slider8.name
                cell.slider8Value.text = slider8.value
                cell.slider8.minimumValue = slider8.min
                cell.slider8.maximumValue = slider8.max
                cell.slider8.value = slider8.valueForSlider
                
                let slider9 = audio.shared.getEQValues(id: cellId, slider: 9)
                cell.slider9Title.text = slider9.name
                cell.slider9Value.text = slider9.value
                cell.slider9.minimumValue = slider9.min
                cell.slider9.maximumValue = slider9.max
                cell.slider9.value = slider9.valueForSlider
                
                let slider10 = audio.shared.getEQValues(id: cellId, slider: 10)
                cell.slider10Title.text = slider10.name
                cell.slider10Value.text = slider10.value
                cell.slider10.minimumValue = slider10.min
                cell.slider10.maximumValue = slider10.max
                cell.slider10.value = slider10.valueForSlider
                
                let slider11 = audio.shared.getEQValues(id: cellId, slider: 11)
                cell.slider11Title.text = slider11.name
                cell.slider11Value.text = slider11.value
                cell.slider11.minimumValue = slider11.min
                cell.slider11.maximumValue = slider11.max
                cell.slider11.value = slider11.valueForSlider
                
                let slider12 = audio.shared.getEQValues(id: cellId, slider: 12)
                cell.slider12Title.text = slider12.name
                cell.slider12Value.text = slider12.value
                cell.slider12.minimumValue = slider12.min
                cell.slider12.maximumValue = slider12.max
                cell.slider12.value = slider12.valueForSlider
                
                let slider13 = audio.shared.getEQValues(id: cellId, slider: 13)
                cell.slider13Title.text = slider13.name
                cell.slider13Value.text = slider13.value
                cell.slider13.minimumValue = slider13.min
                cell.slider13.maximumValue = slider13.max
                cell.slider13.value = slider13.valueForSlider
                
                let slider14 = audio.shared.getEQValues(id: cellId, slider: 14)
                cell.slider14Title.text = slider14.name
                cell.slider14Value.text = slider14.value
                cell.slider14.minimumValue = slider14.min
                cell.slider14.maximumValue = slider14.max
                cell.slider14.value = slider14.valueForSlider
                
                let slider15 = audio.shared.getEQValues(id: cellId, slider: 15)
                cell.slider15Title.text = slider15.name
                cell.slider15Value.text = slider15.value
                cell.slider15.minimumValue = slider15.min
                cell.slider15.maximumValue = slider15.max
                cell.slider15.value = slider15.valueForSlider
                
                let slider16 = audio.shared.getEQValues(id: cellId, slider: 16)
                cell.slider16Title.text = slider16.name
                cell.slider16Value.text = slider16.value
                cell.slider16.minimumValue = slider16.min
                cell.slider16.maximumValue = slider16.max
                cell.slider16.value = slider16.valueForSlider
                
                let slider17 = audio.shared.getEQValues(id: cellId, slider: 17)
                cell.slider17Title.text = slider17.name
                cell.slider17Value.text = slider17.value
                cell.slider17.minimumValue = slider17.min
                cell.slider17.maximumValue = slider17.max
                cell.slider17.value = slider17.valueForSlider
                
                let slider18 = audio.shared.getEQValues(id: cellId, slider: 18)
                cell.slider18Title.text = slider18.name
                cell.slider18Value.text = slider18.value
                cell.slider18.minimumValue = slider18.min
                cell.slider18.maximumValue = slider18.max
                cell.slider18.value = slider18.valueForSlider
                
                let slider19 = audio.shared.getEQValues(id: cellId, slider: 19)
                cell.slider19Title.text = slider19.name
                cell.slider19Value.text = slider19.value
                cell.slider19.minimumValue = slider19.min
                cell.slider19.maximumValue = slider19.max
                cell.slider19.value = slider19.valueForSlider
                
                let slider20 = audio.shared.getEQValues(id: cellId, slider: 20)
                cell.slider20Title.text = slider20.name
                cell.slider20Value.text = slider20.value
                cell.slider20.minimumValue = slider20.min
                cell.slider20.maximumValue = slider20.max
                cell.slider20.value = slider20.valueForSlider
                
                let slider21 = audio.shared.getEQValues(id: cellId, slider: 21)
                cell.slider12Title.text = slider21.name
                cell.slider21Value.text = slider21.value
                cell.slider21.minimumValue = slider21.min
                cell.slider21.maximumValue = slider21.max
                cell.slider21.value = slider21.valueForSlider
                
                let slider22 = audio.shared.getEQValues(id: cellId, slider: 22)
                cell.slider22Title.text = slider22.name
                cell.slider22Value.text = slider22.value
                cell.slider22.minimumValue = slider22.min
                cell.slider22.maximumValue = slider22.max
                cell.slider22.value = slider22.valueForSlider
                
                let slider23 = audio.shared.getEQValues(id: cellId, slider: 23)
                cell.slider23Title.text = slider23.name
                cell.slider23Value.text = slider23.value
                cell.slider23.minimumValue = slider23.min
                cell.slider23.maximumValue = slider23.max
                cell.slider23.value = slider23.valueForSlider
                
                let slider24 = audio.shared.getEQValues(id: cellId, slider: 24)
                cell.slider24Title.text = slider24.name
                cell.slider24Value.text = slider24.value
                cell.slider24.minimumValue = slider24.min
                cell.slider24.maximumValue = slider24.max
                cell.slider24.value = slider24.valueForSlider
                
                let slider25 = audio.shared.getEQValues(id: cellId, slider: 25)
                cell.slider25Title.text = slider25.name
                cell.slider25Value.text = slider25.value
                cell.slider25.minimumValue = slider25.min
                cell.slider25.maximumValue = slider25.max
                cell.slider25.value = slider25.valueForSlider
                
                let slider26 = audio.shared.getEQValues(id: cellId, slider: 26)
                cell.slider26Title.text = slider26.name
                cell.slider26Value.text = slider26.value
                cell.slider26.minimumValue = slider26.min
                cell.slider26.maximumValue = slider26.max
                cell.slider26.value = slider26.valueForSlider
                
                let slider27 = audio.shared.getEQValues(id: cellId, slider: 27)
                cell.slider27Title.text = slider27.name
                cell.slider27Value.text = slider27.value
                cell.slider27.minimumValue = slider27.min
                cell.slider27.maximumValue = slider27.max
                cell.slider27.value = slider27.valueForSlider
                
                let slider28 = audio.shared.getEQValues(id: cellId, slider: 28)
                cell.slider28Title.text = slider28.name
                cell.slider28Value.text = slider28.value
                cell.slider28.minimumValue = slider28.min
                cell.slider28.maximumValue = slider28.max
                cell.slider28.value = slider28.valueForSlider
                
                let slider29 = audio.shared.getEQValues(id: cellId, slider: 29)
                cell.slider29Title.text = slider9.name
                cell.slider29Value.text = slider29.value
                cell.slider29.minimumValue = slider29.min
                cell.slider29.maximumValue = slider29.max
                cell.slider29.value = slider29.valueForSlider
                
                let slider30 = audio.shared.getEQValues(id: cellId, slider: 30)
                cell.slider30Title.text = slider30.name
                cell.slider30Value.text = slider30.value
                cell.slider30.minimumValue = slider30.min
                cell.slider30.maximumValue = slider30.max
                cell.slider30.value = slider30.valueForSlider
                
                let slider31 = audio.shared.getEQValues(id: cellId, slider: 31)
                cell.slider31Title.text = slider31.name
                cell.slider31Value.text = slider31.value
                cell.slider31.minimumValue = slider31.min
                cell.slider31.maximumValue = slider31.max
                cell.slider31.value = slider31.valueForSlider
                
                returnCell = cell
                
            }
            
            
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
