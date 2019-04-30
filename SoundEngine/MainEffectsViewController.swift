//
//  MainEffectsViewController.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 12/02/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//
//
import AudioKit
import AudioKitUI
import UIKit
import MediaPlayer

fileprivate var longPressGesture: UILongPressGestureRecognizer!

class MainEffectsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    @IBOutlet weak var switchesFrame: UIView!
    
    @IBOutlet weak var deviceVolumeView: UIView!
    var volumeView = MPVolumeView()
    
    // "BUTTONS"
    @IBOutlet weak var saveSoundsButton: UIButton!
    @IBOutlet weak var soundsTab: UIView!
    @IBOutlet weak var effectsTab: UIView!
    @IBOutlet weak var hamburgerView: UIView!
    
    // "CONTROLS"
    @IBOutlet weak var inputLevel: UISlider!
    @IBOutlet weak var inputLevelValue: UILabel!
    @IBOutlet weak var outputLevel: UISlider!
    @IBOutlet weak var outputLevelValue: UILabel!
    @IBOutlet weak var bufferLengthSegment: UISegmentedControl!
    @IBOutlet weak var colorSegment: UISegmentedControl!
  
    @IBOutlet weak var noiseGateSwitch: UISwitch!
    @IBOutlet weak var lowCutSwitch: UISwitch!
    @IBOutlet weak var highCutSwitch: UISwitch!
    
   

    
    
    var gradient: CAGradientLayer = CAGradientLayer()
    
    // TEXT LABELS
    @IBOutlet weak var mainSoundTitleView: UIView!
    @IBOutlet weak var mainSoundTitle: UILabel!
    

  
    
    @IBOutlet weak var soundTitle: UILabel!
    @IBOutlet weak var effectsTitle: UILabel!
    @IBOutlet weak var settingsTitle: UILabel!
    @IBOutlet weak var soundsLibraryTitle: UILabel!
    @IBOutlet weak var tunerNoteLabel: UILabel!
    @IBOutlet weak var sharp: UILabel!
    @IBOutlet weak var octave: UILabel!
    @IBOutlet weak var flat5: UILabel!
    @IBOutlet weak var flat4: UILabel!
    @IBOutlet weak var flat3: UILabel!
    @IBOutlet weak var flat2: UILabel!
    @IBOutlet weak var flat1: UILabel!
    @IBOutlet weak var inTune: UILabel!
    @IBOutlet weak var sharp1: UILabel!
    @IBOutlet weak var sharp2: UILabel!
    @IBOutlet weak var sharp3: UILabel!
    @IBOutlet weak var sharp4: UILabel!
    @IBOutlet weak var sharp5: UILabel!
   
    
    // VIEWS
    @IBOutlet weak var fftView: UIView!
    
    @IBOutlet weak var mainFrame: UIView!
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var topControls: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var waveformView: UIView! // inside bottom
    @IBOutlet weak var soundsView: UIView!
    @IBOutlet weak var soundEngine: UIView!

    @IBOutlet weak var settingsView: UIView!
    @IBOutlet weak var settingControlsFrame: UIView!
    @IBOutlet weak var settingControls: UIView!
    @IBOutlet weak var settingsEmptyAreaView: UIView!
    @IBOutlet weak var availableEffectsView: UIView!
    @IBOutlet weak var inputLevelView: UIView!
    @IBOutlet weak var outputLevelView: UIView!
    
    @IBOutlet weak var eqTableView: UITableView!
    @IBOutlet weak var savedSoundsTableView: UITableView!
    @IBOutlet weak var availableEffects: UITableView!
    @IBOutlet weak var availableEffectsCopy: UITableView!
    @IBOutlet weak var selectedEffects: UITableView!
    
    // CONSTRAINTS
    @IBOutlet weak var eqLeadingToEngineCenterX: NSLayoutConstraint!
    @IBOutlet weak var eqTrailingToEngineTrailing: NSLayoutConstraint!
    @IBOutlet weak var soundEngineHeight: NSLayoutConstraint!
    @IBOutlet weak var soundsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var availableEffectsHeight: NSLayoutConstraint!
    
    
    // MISC STUFF
    fileprivate var sourceIndexPath: IndexPath?
    fileprivate var snapshot: UIView?
        
    var nameCheck = Bool()
    var effectChainNeedsReset = Bool(false)
    var viewForSoundGraphic = UIView()
    var stack = UIStackView()
        
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            setVolumeBounds()
            
        } else {
            print("Portrait")
            setVolumeBounds()
        }
    }
    
    func disableAllTunerLabels() {
        
        self.flat1.isEnabled = false
        self.flat2.isEnabled = false
        self.flat3.isEnabled = false
        self.flat4.isEnabled = false
        self.flat5.isEnabled = false
        self.inTune.isEnabled = false
        self.sharp1.isEnabled = false
        self.sharp2.isEnabled = false
        self.sharp3.isEnabled = false
        self.sharp4.isEnabled = false
        self.sharp5.isEnabled = false
    }
    
    func startAmplitudeMonitors() {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let volume = audio.outputAmplitudeTracker?.amplitude
           
            let tuner = audio.shared.updateTrackerUI()
           // print("TUNER : \(tuner)")
            
            if tuner.note == "" {
                self.sharp.isHidden = true
                self.octave.isHidden = true
                self.tunerNoteLabel.isEnabled = false
                self.disableAllTunerLabels()
     
            }
            else {
                self.sharp.isHidden = false
                self.octave.isHidden = false
                self.tunerNoteLabel.isEnabled = true
                if self.tunerNoteLabel.text != tuner.note {
                    self.tunerNoteLabel.text = tuner.note
                }
                if self.octave.text != tuner.octave {
                    if tuner.octave != "0" {
                        self.octave.text = tuner.octave
                    }
                }
                if self.sharp.text != tuner.sharp {
                    self.sharp.text = tuner.sharp
                }
                
                let absolute = fabsf(tuner.direction)
                
                if absolute < 3 {
                    self.disableAllTunerLabels()
                    self.inTune.isEnabled = true
                }
                else {
                    self.disableAllTunerLabels()
                    if tuner.direction > 0 && tuner.direction < 5 {
                        self.inTune.isEnabled = true
                        self.flat1.isEnabled = true
                    }
                    else if tuner.direction < 0 && tuner.direction > -5 {
                        self.inTune.isEnabled = true
                        self.sharp1.isEnabled = true
                    }
                    else if tuner.direction > 5 && tuner.direction < 10 {
                        self.flat1.isEnabled = true
                    }
                    else if tuner.direction < -5 && tuner.direction > -10 {
                        self.sharp1.isEnabled = true
                    }
                    else if tuner.direction > 10 && tuner.direction < 20 {
                        self.flat2.isEnabled = true
                    }
                    else if tuner.direction < -10 && tuner.direction > -20 {
                        self.sharp2.isEnabled = true
                    }
                    else if tuner.direction > 20 && tuner.direction < 30 {
                        self.flat3.isEnabled = true
                    }
                    else if tuner.direction < -20 && tuner.direction > -30 {
                        self.sharp3.isEnabled = true
                    }
                    else if tuner.direction > 40 && tuner.direction < 50 {
                        self.flat4.isEnabled = true
                    }
                    else if tuner.direction < -40 && tuner.direction > -50 {
                        self.sharp4.isEnabled = true
                    }
                    
                }
                
            }
            
        
            
            
        }
        timer.fire()
    }
    
    
    func moveEqToPosition(value: Int) {
        let width = self.soundEngine.bounds.width / 2
        let distance = width / 2
        if value == 0 {
            if self.eqLeadingToEngineCenterX.constant != -distance {
                self.eqLeadingToEngineCenterX.constant = -distance
                self.eqTrailingToEngineTrailing.constant = distance
                self.eqTableView.layoutIfNeeded()
            }
        } else {
             if self.eqLeadingToEngineCenterX.constant != 0 {
                self.eqLeadingToEngineCenterX.constant = 0
                self.eqTrailingToEngineTrailing.constant = 0
            }
        }
    }
    
        func setSoundsViewHeight() {
            let newHeight = CGFloat(Collections.savedSounds.count * 44 + 78)
            let maxHeight = CGFloat(self.soundEngineHeight.constant - 52)
            if newHeight < maxHeight {
                self.soundsViewHeight.constant = newHeight
            }
            else {
                self.soundsViewHeight.constant = maxHeight
            }
            
            
        }
        
        func setAvailableEffectsHeight() {
            let newHeight = CGFloat(audio.availableEffectsData.count * 44 + 40)
            let maxHeight = CGFloat(self.soundEngineHeight.constant - 52)
            if newHeight < maxHeight {
                self.availableEffectsHeight.constant = newHeight
            }
            else {
                self.availableEffectsHeight.constant = maxHeight
            }
            
        }
        
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            
            self.soundsTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSoundsTap))
            self.soundsTab.addGestureRecognizer(soundsTapGesture)
            self.soundsTab.isUserInteractionEnabled = true
       
            
            self.effectsTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEffectsTap))
            self.effectsTab.addGestureRecognizer(effectsTapGesture)
            self.effectsTab.isUserInteractionEnabled = true
     
            self.hamburgerTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleHamburgerTap))
            self.hamburgerView.addGestureRecognizer(hamburgerTapGesture)
            self.hamburgerView.isUserInteractionEnabled = true
            
            self.cancelTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCancelTap))
            self.settingsEmptyAreaView.addGestureRecognizer(cancelTapGesture)
            self.settingsEmptyAreaView.isUserInteractionEnabled = true
            
            
            
            
            
            
            
            
            audio.shared.createEffects()
            
            helper.shared.checkUserDefaults()
            
            
            
            createTableViews()
            
            audio.shared.audioKitSettings()
            
            audio.shared.startAudio()
            interfaceSetup()
            startAmplitudeMonitors()
            
            self.moveEqToPosition(value: audio.selectedEffectsData.count)
            printFilters()
        }
        
        func resetEffectChain() {
            print("RESETTING EFFECTS")
            var wasOn = [effectData]()
            
            for effect in audio.selectedEffectsData {
                if helper.shared.isOn(id: effect.id) == true {
                    wasOn.append(effect)
                }
            }
            audio.shared.stopAll()
            for effect in wasOn {
                audio.shared.turnOn(id: effect.id)
            }
            checkConnections()
            resetInterface()
        }
    
    func convertDBValueToText(dB: Double) -> String {
        var text = ""
        if dB > 0 {
            text = "+" + String(dB).prefix(3) + " dB"
        }
        else {
            text = String(dB).prefix(4) + " dB"
        }
        return text
    }
    
    func resetInterface() {
        noiseGateSwitch.setOn(audio.gateIsOn, animated: true)
        highCutSwitch.setOn(audio.lowPassIsStarted, animated: true)
        lowCutSwitch.setOn(audio.highPassIsStarted, animated: true)
        inputLevel.setValue(Float((audio.inputBooster?.dB)!), animated: true)
        inputLevelValue.text = convertDBValueToText(dB: audio.inputBooster!.dB)
        outputLevel.setValue(Float((audio.outputBooster?.dB)!), animated: true)
        outputLevelValue.text = convertDBValueToText(dB: audio.outputBooster!.dB)
        
    }
    func setVolumeBounds(){
    
        volumeView.frame = deviceVolumeView.bounds
        deviceVolumeView.addSubview(volumeView)
    }
    
        func interfaceSetup() {
            
            setVolumeBounds()
            
            noiseGateSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            highCutSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            lowCutSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            noiseGateSwitch.onTintColor = interface.highlight
            highCutSwitch.onTintColor = interface.highlight
            lowCutSwitch.onTintColor = interface.highlight
            
            resetInterface()
            
            
            // inputLevel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            inputLevel.minimumValue = Float(Effects.booster.dBRange.lowerBound)
            inputLevel.maximumValue = Float(Effects.booster.dBRange.upperBound)
           
         
            inputLevel.addTarget(self, action: #selector(inputLevelChanged), for: .valueChanged)
           // inputLevel.addTarget(self, action: #selector(inputLevelChangeEnded), for: .touchUpInside)
            
            //  outputLevel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/2))
            outputLevel.minimumValue = Float(Effects.booster.dBRange.lowerBound)
            outputLevel.maximumValue = Float(Effects.booster.dBRange.upperBound)
            
            
            outputLevel.addTarget(self, action: #selector(outputLevelChanged), for: .valueChanged)
           // outputLevel.addTarget(self, action: #selector(outputLevelChangeEnded), for: .touchUpInside)
            
            bufferLengthSegment.selectedSegmentIndex = settings.bufferLength - 1
            colorSegment.selectedSegmentIndex = setColorSegment()
            savedSoundsTableView.layer.cornerRadius = 8
            soundsView.layer.cornerRadius = 8
   
            availableEffects.layer.cornerRadius = 8
            selectedEffects.layer.cornerRadius = 8
            eqTableView.layer.cornerRadius = 8
        
            availableEffectsView.layer.cornerRadius = 8
            
            soundTitle.layer.cornerRadius = 4
            effectsTitle.layer.cornerRadius = 4
           // deviceVolumeView.layer.cornerRadius = 4
            
            soundTitle.layer.borderWidth = 1
            effectsTitle.layer.borderWidth = 1
           // deviceVolumeView.layer.borderWidth = 1
            
            switchesFrame.layer.cornerRadius = 8
         
            hamburgerView.layer.cornerRadius = 4
            hamburgerView.layer.borderWidth = 1
            settingControlsFrame.layer.cornerRadius = 8
            settingControls.layer.cornerRadius = 8
            mainSoundTitleView.layer.cornerRadius = 4
            mainSoundTitleView.layer.borderColor = interface.textIdle.cgColor
           // mainSoundTitleView.layer.borderWidth = 1
            
           // mainFrame.layer.cornerRadius = 8
            
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.distribution = .fillEqually
            stack.axis = .horizontal
            stack.alignment = .center
            stack.spacing = 0
            viewForSoundGraphic = UIView(frame: CGRect(x: 0, y: 0, width: waveformView.frame.width, height: waveformView.frame.height))
            viewForSoundGraphic.addSubview(stack)
            waveformView.addSubview(viewForSoundGraphic)
            stack.centerXAnchor.constraint(equalTo: waveformView.centerXAnchor).isActive = true
            stack.centerYAnchor.constraint(equalTo: waveformView.centerYAnchor).isActive = true
            
            buildWaveforStackView()
          //  buildFFTView()
            setColors()
            mainSoundTitle.text = audio.nameOfCurrentSound
        }
    
        func setColors() {
            // "BUTTONS"
            saveSoundsButton.backgroundColor = interface.transparent
            saveSoundsButton.tintColor = interface.text
            saveSoundsButton.layer.borderWidth = 1
            saveSoundsButton.layer.cornerRadius = 4
            saveSoundsButton.layer.borderColor = interface.text.cgColor
            soundsTab.backgroundColor = interface.tabs
            effectsTab.backgroundColor = interface.tabs
            deviceVolumeView.backgroundColor = interface.tabs
            hamburgerView.backgroundColor = interface.tabs
            
            soundsTab.layer.borderColor = interface.text.cgColor
            effectsTab.layer.borderColor = interface.text.cgColor
            deviceVolumeView.layer.borderColor = interface.text.cgColor
            hamburgerView.layer.borderColor = interface.text.cgColor
            
            switchesFrame.backgroundColor = interface.tableBackground
           
            // CONTROLS
            inputLevel.minimumTrackTintColor = interface.sliderMin
            inputLevel.maximumTrackTintColor = interface.sliderMax
            inputLevel.thumbTintColor = interface.sliderThumb
            outputLevel.minimumTrackTintColor = interface.sliderMin
            outputLevel.maximumTrackTintColor = interface.sliderMax
            outputLevel.thumbTintColor = interface.sliderThumb
            bufferLengthSegment.tintColor = interface.segmentTint
            bufferLengthSegment.backgroundColor = interface.segmentBackground
            colorSegment.tintColor = interface.segmentTint
            colorSegment.backgroundColor = interface.transparent
            
            // TEXT LABELS
            mainSoundTitle.textColor = interface.textIdle
            soundTitle.textColor = interface.textAlt
            effectsTitle.textColor = interface.textAlt
            settingsTitle.textColor = interface.textAlt
            soundsLibraryTitle.textColor = interface.text
            tunerNoteLabel.textColor = interface.text
            sharp.textColor = interface.text
            octave.textColor = interface.text
            flat5.textColor = interface.text
            flat4.textColor = interface.text
            flat3.textColor = interface.text
            flat2.textColor = interface.text
            flat1.textColor = interface.extra
            inTune.textColor = interface.highlight
            sharp1.textColor = interface.extra
            sharp2.textColor = interface.text
            sharp3.textColor = interface.text
            sharp4.textColor = interface.text
            sharp5.textColor = interface.text
            
            inputLevelValue.textColor = interface.text
            outputLevelValue.textColor = interface.text
            
            
            
            //VIEWS
            //mainFrame.backgroundColor = interface.main
            soundsView.backgroundColor = interface.tableFrame
            top.backgroundColor = interface.top
            mainSoundTitleView.backgroundColor = interface.tableHeading
            
            bottom.backgroundColor = interface.tableBackground
            savedSoundsTableView.backgroundColor = interface.tableBackground
            availableEffects.backgroundColor = interface.tableBackground
            availableEffectsView.backgroundColor = interface.tableFrame
            settingControlsFrame.backgroundColor = interface.tableFrame
            settingControls.backgroundColor = interface.tableBackground
            
            // TRANSPARENT
            topControls.backgroundColor = interface.transparent
            waveformView.backgroundColor = interface.transparent
            soundEngine.backgroundColor = interface.transparent
            settingsView.backgroundColor = interface.transparent
            settingsEmptyAreaView.backgroundColor = interface.transparent
            inputLevelView.backgroundColor = interface.transparent
            outputLevelView.backgroundColor = interface.transparent
            eqTableView.backgroundColor = interface.transparent
            selectedEffects.backgroundColor = interface.transparent
        
            gradientBackground()
        }
    
    func gradientBackground() {
      
        gradient.colors = [UIColor.black.cgColor, interface.highlight.cgColor]
        gradient.locations = [0.2 , 2.0]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        if self.view.frame.size.width > self.view.frame.size.height {
            gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.width)
        }
        else {
             gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.height, height: self.view.frame.size.height)
        }
      
        
    
        self.view.layer.insertSublayer(gradient, at: 0)
    }
    
    func buildFFTView(){
        // FFT
        
        let plot = AKNodeFFTPlot(audio.outputAmplitudeTracker, frame: CGRect(x: 0, y: 0, width: fftView.frame.width, height: fftView.frame.height))
        plot.shouldFill = true
        plot.shouldMirror = false
        plot.shouldCenterYAxis = false
        plot.color = AKColor.purple.withAlphaComponent(0.5)
        plot.backgroundColor = UIColor.clear
        plot.gain = 100
        self.fftView.addSubview(plot)
       
        
    }
    
        
        func buildWaveforStackView() {
            
            for subview in stack.arrangedSubviews {
                stack.removeArrangedSubview(subview)
                subview.isHidden = true
            }
      
            let stackUnitWidth = CGFloat(600)
          
            let inputUnit = AKNodeOutputPlot(audio.wave as! AKNode, frame: CGRect(x: 0, y: 0, width: stackUnitWidth, height: 80))
                        inputUnit.heightAnchor.constraint(equalToConstant: 80).isActive = true
                        inputUnit.widthAnchor.constraint(equalToConstant: stackUnitWidth).isActive = true
                        inputUnit.plotType = .buffer
                        inputUnit.shouldFill = false
                        inputUnit.shouldMirror = false
                        inputUnit.color = UIColor.cyan
                        inputUnit.backgroundColor = UIColor.clear
                        stack.addArrangedSubview(inputUnit)
            
            let outputUnit = AKNodeOutputPlot(audio.finalBooster as! AKNode, frame: CGRect(x: 0, y: 0, width: stackUnitWidth, height: 80))
                        outputUnit.heightAnchor.constraint(equalToConstant: 80).isActive = true
                        outputUnit.widthAnchor.constraint(equalToConstant: stackUnitWidth).isActive = true
                        outputUnit.plotType = .buffer
                        outputUnit.shouldFill = false
                        outputUnit.shouldMirror = false
                        outputUnit.color = UIColor.cyan
                        outputUnit.backgroundColor = UIColor.clear
                        stack.addArrangedSubview(outputUnit)
        
        }
    
    @IBAction func highCutSwitchAction(_ sender: Any) {
        // 6000
        if highCutSwitch.isOn {
            audio.lowPassFilter?.start()
        } else {
            audio.lowPassFilter?.stop()
        }
    }
    @IBAction func lowCutSwitchAction(_ sender: Any) {
        // 100
        if lowCutSwitch.isOn {
            audio.highPassFilter?.start()
        } else {
            audio.highPassFilter?.stop()
        }
    }
    @IBAction func noiseGateSwitchAction(_ sender: Any) {
        if noiseGateSwitch.isOn {
            audio.gateIsOn = true
        } else {
             audio.gateIsOn = false
        }
    }
    
    @IBAction func checkFiltersAction(_ sender: Any) {
        printFilters()
        
    }
    
    func printFilters() {
        print("HIGH CUT \(String(describing: audio.lowPassFilter?.isStarted))")
        print("LOW CUT \(String(describing: audio.highPassFilter?.isStarted))")
        print("GATE \(audio.gateIsOn)")
        
 
    }
    
   
    
        @objc func inputLevelChanged(slider: UISlider) {
            audio.inputBooster?.dB = Double(slider.value)
            inputLevelValue.text = convertDBValueToText(dB: Double(slider.value))
       
            //  print("Input --- \(audio.shared.inputBooster?.dB) dB")
        }
        
        @objc func inputLevelChangeEnded(slider: UISlider) {
            
            UserDefaults.standard.set(audio.inputBooster?.dB, forKey: "inputBooster")
        }
        
        @objc func outputLevelChanged(slider: UISlider) {
            audio.outputBooster?.dB = Double(slider.value)
            outputLevelValue.text = convertDBValueToText(dB: Double(slider.value))
        
            //  print("Output --- \(audio.shared.outputBooster?.dB) dB --- \(audio.shared.outputBooster?.gain)")
        }
        
        @objc func outputLevelChangeEnded(slider: UISlider) {
            
            UserDefaults.standard.set(audio.outputBooster?.dB, forKey: "outputBooster")
        }
        
        
        // MARK: TABLEVIEWS
        func createTableViews() {
            // Arrange available units list aplhabetically
            audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
            availableEffects.delegate = self
            availableEffects.dataSource = self
            
            availableEffectsCopy.delegate = self
            availableEffectsCopy.dataSource = self
           
            selectedEffects.delegate = self
            selectedEffects.dataSource = self
            
            eqTableView.delegate = self
            eqTableView.dataSource = self
            
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
           
            let eqNib = UINib(nibName: "EqualizerTableViewCell", bundle: nil)
            
            selectedEffects.register(nib, forCellReuseIdentifier: "TableViewCell")
            selectedEffects.register(doubleNib, forCellReuseIdentifier: "DoubleTableViewCell")
            selectedEffects.register(tripleNib, forCellReuseIdentifier: "TripleTableViewCell")
            selectedEffects.register(quatroNib, forCellReuseIdentifier: "QuatroTableViewCell")
            selectedEffects.register(pentaNib, forCellReuseIdentifier: "PentaTableViewCell")
            selectedEffects.register(hexaNib, forCellReuseIdentifier: "HexaTableViewCell")
            selectedEffects.register(heptaNib, forCellReuseIdentifier: "HeptaTableViewCell")
            selectedEffects.register(octaNib, forCellReuseIdentifier: "OctaTableViewCell")

         
            eqTableView.register(eqNib, forCellReuseIdentifier: "EqualizerTableViewCell")
            eqTableView.allowsSelection = false
            
            
           // longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(longPress:)))
          //  selectedEffects.addGestureRecognizer(longPressGesture)
            
            
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
                
            }
            else if tableView == availableEffectsCopy {
                value = audio.availableEffectsData.count
                
            }
       
            else if tableView == selectedEffects {
                // unitsAfter List
                value = audio.selectedEffectsData.count
            }
            
            else if tableView == eqTableView {
                value = 1
            }
            return value
        }
        
        @objc func toggleEQ(toggle:UISegmentedControl) {
            let selection = toggle.selectedSegmentIndex
            switch selection {
            case 0 :
                print("switch to three band EQ") // switch to threeband EQ
                audio.shared.toggleEQ(id: "threeBandFilter")
                audio.eqSelection = 0
            case 1 :
                print("switch to seven band EQ") // switch to 7 EQ
                audio.shared.toggleEQ(id: "sevenBandFilter")
                audio.eqSelection = 1
            default:
                print("three band EQ") // threeband EQ
            }
            
           // selectedEffects.reloadData()
            eqTableView.reloadData()
        }
        
        @objc func toggleOnOff() {
           // buildWaveforStackView()
        }
    
    func shortNameFor(name: String) -> String {
        
        return "SHORT"
        
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
            var cellColorCoding = UIColor()
            
            if tableView == savedSoundsTableView{
                cellTitle = Collections.savedSounds[indexPath.row]
            }
            
            else if tableView == eqTableView {
                
                cellType = "Equalizer"
            }
                
            else if tableView == selectedEffects {
                cellOpened = audio.selectedEffectsData[indexPath.row].opened
                cellTitle = audio.selectedEffectsData[indexPath.row].title
                cellType = audio.selectedEffectsData[indexPath.row].type
                cellIsLast = audio.selectedEffectsData.endIndex - 1 == indexPath.row
                cellId = audio.selectedEffectsData[indexPath.row].id
                cellColorCoding = Colors.palette.colorForEffect(name: cellId)
                
                if Collections.specialEffects.contains(cellId) {
                    cellIsSpecial = true
                }
                else {
                    cellIsSpecial = false
                }
            }
                
           
            else {
                cellTitle = audio.availableEffectsData[indexPath.row].title
                cellId = audio.availableEffectsData[indexPath.row].id
                cellColorCoding = Colors.palette.colorForEffect(name: cellId)
            }
            
            if tableView == availableEffects || tableView == savedSoundsTableView {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell()}
                cell.textLabel?.text = cellTitle
                cell.textLabel?.textColor = interface.text
                cell.backgroundColor = interface.tableBackground
                cell.selectedBackgroundView = backgroundView
                
                returnCell = cell
                
            }
                
            else if tableView == availableEffectsCopy {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellCopy") else {return UITableViewCell()}
                // GET SHORT NAME
                let shortName = shortNameFor(name: cellTitle)
                cell.textLabel?.text = shortName
                cell.textLabel?.textColor = interface.text
                cell.backgroundColor = interface.tableBackground
                cell.selectedBackgroundView = backgroundView
                
                returnCell = cell
                
            }
                
                
            else {
                
                switch cellType {
                
                    
                case "Equalizer":
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EqualizerTableViewCell", for: indexPath) as! EqualizerTableViewCell
                    cell.selectedBackgroundView = backgroundView
                    cell.segmentControl.selectedSegmentIndex = audio.eqSelection
                    cell.segmentControl.addTarget(self, action: #selector(toggleEQ), for: .valueChanged)
                   // cell.soundTitle.text = audio.nameOfCurrentSound.uppercased()
                    if cell.segmentControl.selectedSegmentIndex == 1 {
                        
                        cell.controllersHeight.constant = CGFloat(350 + 8)
                        cell.threeStack.isHidden = true
                        cell.sevenStack.isHidden = false
                        cell.segmentControl.selectedSegmentIndex = 1
                        audio.shared.toggleEQ(id: "sevenBandFilter")
                        
                        // Sub-Bass, Bass, Low Mid, Mid, Upper Mid, Precence, Brilliance
                        
                        let brilliance = audio.shared.getEQ(id: "sevenBandFilter", slider: 1)
                        cell.sevenBandBrillianceValue.text = brilliance.value
                        cell.sevenBandBrillianceSlider.minimumValue = brilliance.min
                        cell.sevenBandBrillianceSlider.maximumValue = brilliance.max
                        cell.sevenBandBrillianceSlider.value = brilliance.valueForSlider
                        
                        let precence = audio.shared.getEQ(id: "sevenBandFilter", slider: 2)
                        cell.sevenBandPrecenceValue.text = precence.value
                        cell.sevenBandPrecenceSlider.minimumValue = precence.min
                        cell.sevenBandPrecenceSlider.maximumValue = precence.max
                        cell.sevenBandPrecenceSlider.value = precence.valueForSlider
                        
                        
                        
                        let uMid = audio.shared.getEQ(id: "sevenBandFilter", slider: 3)
                        cell.sevenBandUpperMidValue.text = uMid.value
                        cell.sevenBandUpperMidSlider.minimumValue = uMid.min
                        cell.sevenBandUpperMidSlider.maximumValue = uMid.max
                        cell.sevenBandUpperMidSlider.value = uMid.valueForSlider
                        
                        
                        let mid = audio.shared.getEQ(id: "sevenBandFilter", slider: 4)
                        cell.sevenBandMidValue.text = mid.value
                        cell.sevenBandMidSlider.minimumValue = mid.min
                        cell.sevenBandMidSlider.maximumValue = mid.max
                        cell.sevenBandMidSlider.value = mid.valueForSlider
                        
                        
                        let lMid = audio.shared.getEQ(id: "sevenBandFilter", slider: 5)
                        cell.sevenBandLowMidValue.text = lMid.value
                        cell.sevenBandLowMidSlider.minimumValue = lMid.min
                        cell.sevenBandLowMidSlider.maximumValue = lMid.max
                        cell.sevenBandLowMidSlider.value = lMid.valueForSlider
                        
                        
                        let low = audio.shared.getEQ(id: "sevenBandFilter", slider: 6)
                        cell.sevenBandBassValue.text = low.value
                        cell.sevenBandBassSlider.minimumValue = low.min
                        cell.sevenBandBassSlider.maximumValue = low.max
                        cell.sevenBandBassSlider.value = low.valueForSlider
                        
                        
                        let bass = audio.shared.getEQ(id: "sevenBandFilter", slider: 7)
                        cell.sevenBandSubBassValue.text = bass.value
                        cell.sevenBandSubBassSlider.minimumValue = bass.min
                        cell.sevenBandSubBassSlider.maximumValue = bass.max
                        cell.sevenBandSubBassSlider.value = bass.valueForSlider
                        
                        
                    } else if cell.segmentControl.selectedSegmentIndex == 0 {
                        cell.controllersHeight.constant = CGFloat(150 + 8)
                        cell.threeStack.isHidden = false
                        cell.sevenStack.isHidden = true
                        cell.segmentControl.selectedSegmentIndex = 0
                        audio.shared.toggleEQ(id: "threeBandFilter")
                        
                        let high = audio.shared.getEQ(id: "threeBandFilter", slider: 1)
                        cell.threeBandHighValue.text = high.value
                        cell.threeBandHighSlider.minimumValue = high.min
                        cell.threeBandHighSlider.maximumValue = high.max
                        cell.threeBandHighSlider.value = high.valueForSlider
                        
                        
                        let mid = audio.shared.getEQ(id: "threeBandFilter", slider: 2)
                        cell.threeBandMidValue.text = mid.value
                        cell.threeBandMidSlider.minimumValue = mid.min
                        cell.threeBandMidSlider.maximumValue = mid.max
                        cell.threeBandMidSlider.value = mid.valueForSlider
                        
                        
                        let low = audio.shared.getEQ(id: "threeBandFilter", slider: 3)
                        cell.threeBandLowValue.text = low.value
                        cell.threeBandLowSlider.minimumValue = low.min
                        cell.threeBandLowSlider.maximumValue = low.max
                        cell.threeBandLowSlider.value = low.valueForSlider
                    }
                    
                    
                        if cell.segmentControl.selectedSegmentIndex == 1 {
                            cell.controllersHeight.constant = CGFloat(350 + 8)
                            cell.controllersView.isHidden = false
                        } else {
                            cell.controllersHeight.constant = CGFloat(150 + 8)
                            cell.controllersView.isHidden = false
                        }
                        
                   // set colors
                    cell.setColors()
                    
                    returnCell = cell
                    
                    
                case "1":
                    // One slider
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        //cell.onOffButton.setTitleColor(interface.text, for: .normal)
                    } else {
                        cell.onOffButton.setTitle("OFF", for: .normal)
                        //cell.onOffButton.setTitleColor(interface.textIdle, for: .normal)
                        if slider.name.contains("ix") || slider.name.contains("Volume")  {
                            cell.slider.isEnabled = false
                        }
                        
                    }
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "2":
                    // Has two sliders
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DoubleTableViewCell", for: indexPath) as! DoubleTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider2.name.contains("ix")  || slider2.name.contains("Volume") {
                            cell.slider2.isEnabled = false
                        }
                        
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "3":
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TripleTableViewCell", for: indexPath) as! TripleTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider3.name.contains("ix")  || slider3.name.contains("Volume")  {
                            cell.slider3.isEnabled = false
                        }
                      
                        
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "4":
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuatroTableViewCell", for: indexPath) as! QuatroTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider4.name.contains("ix")  || slider4.name.contains("Volume") {
                            cell.slider4.isEnabled = false
                        }
                        
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "5":
                    // Has two sliders
                    let cell = tableView.dequeueReusableCell(withIdentifier: "PentaTableViewCell", for: indexPath) as! PentaTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider5.name.contains("ix")  || slider5.name.contains("Volume") {
                            cell.slider5.isEnabled = false
                        }
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "6":
                    // Has two sliders
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HexaTableViewCell", for: indexPath) as! HexaTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider6.name.contains("ix")  || slider6.name.contains("Volume") {
                            cell.slider6.isEnabled = false
                        }
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "7":
                    // Has two sliders
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HeptaTableViewCell", for: indexPath) as! HeptaTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider7.name.contains("ix")  || slider7.name.contains("Volume") {
                            cell.slider7.isEnabled = false
                        }
                    }
                    
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                case "8":
                    // Has two sliders
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OctaTableViewCell", for: indexPath) as! OctaTableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider8.name.contains("ix") || slider8.name.contains("Volume")  {
                            cell.slider8.isEnabled = false
                        }
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
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
                    cell.setColors()
                    
                    returnCell = cell
                    
                default:
                    // One slider
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
                    cell.coloringView.layer.borderColor = cellColorCoding.cgColor
                    
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
                        if slider.name.contains("ix")  || slider.name.contains("Volume") {
                            cell.slider.isEnabled = false
                        }
                        
                    }
                    
                    cell.onOffButton.addTarget(self, action: #selector(toggleOnOff), for: .touchUpInside)
                    
                    cell.controllerHeight.constant = CGFloat(0)
                    cell.controllersView.isHidden = true
                    cell.specialViewHeight.constant = CGFloat(0)
                    cell.specialView.isHidden = true
                    
                    cell.setColors()
                    
                    returnCell = cell
                }
            }
            
            return returnCell
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if tableView == savedSoundsTableView {
                
                let sound = Collections.savedSounds[indexPath.row]
                UserDefaults.standard.setValue(sound, forKey: "NameOfSound")
                audio.nameOfCurrentSound = sound
                self.mainSoundTitle.text = sound
                //self.soundTitle.text = sound
                
                helper.shared.getSavedChain(name: sound)
                self.selectedEffects.reloadData()
               
                self.availableEffects.reloadData()
                self.availableEffectsCopy.reloadData()
                self.eqTableView.reloadData()
                
                resetEffectChain()
                
               // buildWaveforStackView()
                
                handleSoundsTap()
                self.moveEqToPosition(value: audio.selectedEffectsData.count)
            }
                
            else if tableView == availableEffects {
                // resetEffectChain()
                let tempData = audio.availableEffectsData[indexPath.row]
                audio.selectedEffectsData.append(tempData)
                self.selectedEffects.reloadData()
                audio.availableEffectsData.remove(at: indexPath.row)
                let row = IndexPath(item: indexPath.row, section: 0)
                self.availableEffects.deleteRows(at: [row], with: .none)
                self.availableEffectsCopy.deleteRows(at: [row], with: .none)
                handleEffectsTap()
                
                self.moveEqToPosition(value: audio.selectedEffectsData.count)
            }
                
           
            else if tableView == selectedEffects {
                // expand and collapse cells
                if audio.selectedEffectsData[indexPath.row].opened == false {
                    // close previous cell
                    if let previous = audio.selectedEffectsData.firstIndex(where: {$0.opened == true}) {
                        audio.selectedEffectsData[previous].opened = false
                   //     let row = IndexPath(item: previous, section: 0)
                   //     tableView.reloadRows(at: [row], with: .fade)
                    }
                    // open this cell
                    audio.selectedEffectsData[indexPath.row].opened = true
                   // let row = IndexPath(item: indexPath.row, section: 0)
                   // tableView.reloadRows(at: [row], with: .fade)
                   // tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                else {
                    audio.selectedEffectsData[indexPath.row].opened = false
                   // let row = IndexPath(item: indexPath.row, section: 0)
                   // tableView.reloadRows(at: [row], with: .fade)
                    
                }
                tableView.reloadData()
            }
           

        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            
            if tableView == eqTableView {
                return false
            }
            
            else if tableView == selectedEffects {
                if audio.selectedEffectsData[indexPath.row].opened {
                    return false
                }
                else {
                    return true
                }
            }
       
            else if tableView == savedSoundsTableView {
                return true
            }
            else {
                return false
            }
        }
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if tableView == selectedEffects {
                if (editingStyle == .delete) {
                    
                    // remove and insert data between arrays
                    audio.selectedEffectsData[indexPath.row].opened = false
                    let tempData = audio.selectedEffectsData[indexPath.row]
                    audio.availableEffectsData.append(tempData)
                    // Arrange available units list aplhabetically
                    audio.availableEffectsData = audio.availableEffectsData.sorted{ $0.title < $1.title }
                    self.availableEffects.reloadData()
                    self.availableEffectsCopy.reloadData()
                    audio.selectedEffectsData.remove(at: indexPath.row)
                    let row = IndexPath(item: indexPath.row, section: 0)
                    self.selectedEffects.deleteRows(at: [row], with: .none)
                    resetEffectChain()
                    self.moveEqToPosition(value: audio.selectedEffectsData.count)
                }
            }
  
                
            else if tableView == savedSoundsTableView {
                if (editingStyle == .delete) {
                    let name = Collections.savedSounds[indexPath.row]
                    print("DELETE THIS KEY : \(name)")
                    UserDefaults.standard.removeObject(forKey: name)
                    Collections.savedSounds.remove(at: indexPath.row)
                    UserDefaults.standard.set(Collections.savedSounds, forKey: "savedSounds")
                    let row = IndexPath(item: indexPath.row, section: 0)
                    savedSoundsTableView.deleteRows(at: [row], with: .none)
                    if name == audio.nameOfCurrentSound {
                       // self.soundTitle.text = "Sounds"
                        self.mainSoundTitle.text = ""
                        audio.nameOfCurrentSound = ""
                        UserDefaults.standard.setValue("", forKey: "NameOfSound")
                    }
                    resetEffectChain()
                    self.moveEqToPosition(value: audio.selectedEffectsData.count)
                }
            }
            
        }
        
        
        func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            /*
             if tableView == selectedEffects {
             return true
             }
             else {
             return false
             }
             */
            return false
        }
        
        func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
            
            // resetEffectChain()
        }
        
        func checkConnections() {
            print(AudioKit.printConnections())
            /* print("SELECTED UNITS")
             for effect in audio.selectedEffectsData {
             helper.shared.printValues(id: effect.id)
             print(helper.shared.isOn(id: effect.id))
             */
             
             print("ALL POSSIBLE")
             // print(AudioKit.printConnections())
             for effect in audio.allPossibleEffectsData {
             helper.shared.printValues(id: effect.id)
             print(helper.shared.isOn(id: effect.id))
             }
            
 
            
        }
    
    func setColorSegment() -> Int {
        var value = 0
        switch Colors.selected
        {
        case "Candy" : value = 0
        case "YellowBlue" : value = 1
        case "Polka" : value = 2
        case "PinkBlue" : value = 3
        case "Spotify" : value = 4
        case "Yle" : value = 5
        case "Chrome" : value = 6
        case "Chess" : value = 7
        default : value = 0
        }
       
        return value
    }
        

    @IBAction func colorAction(_ sender: UISegmentedControl) {
        var colorCode = ""
        switch sender.selectedSegmentIndex
        {
        case 0: colorCode = "Candy" // white colorful pastels
        case 1 : colorCode = "YellowBlue" // dark colorful
        case 2 : colorCode = "Polka" // white and pink
        case 3 : colorCode = "PinkBlue" // steve vai theme
        case 4 : colorCode = "Spotify"  // white boring grey
        case 5 : colorCode = "Chrome" // dark boring grey
        default: colorCode = "Spotify"
        }
       
        Colors.palette.setInterfaceColorScheme(name: colorCode)
        setColors()
        eqTableView.reloadData()
        selectedEffects.reloadData()
        availableEffects.reloadData()
        self.availableEffectsCopy.reloadData()
        savedSoundsTableView.reloadData()
        UserDefaults.standard.setValue(colorCode, forKey: "Color")
    }
    
    
        @IBAction func bufferLengthSegmentAction(_ sender: UISegmentedControl) {
            let name = sender.selectedSegmentIndex + 1
            audio.shared.setBufferLength(segment: name)
            UserDefaults.standard.set(name, forKey: "bufferLength")
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
 
        
        @IBAction func saveSoundButtonAction(_ sender: Any) {
            popUpDialogueForNewSound()
        }
        
        // MARK: DIALOGUES
        
        func popUpDialogueForNewSound() {
            let alert = UIAlertController(title: "Save new sound?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            // Create an OK Button
            let okAction = UIAlertAction(title: "Save", style: .default, handler: { action in
                
                if let name = alert.textFields?.first?.text {
                    print("Your new sound is: \(name)")
                    if self.nameCheck {
                        
                        
                        helper.shared.saveEffectChain(name: name)
                        self.savedSoundsTableView.reloadData()
                        self.setSoundsViewHeight()
                       // self.soundTitle.text = name
                        audio.nameOfCurrentSound = name
                        self.mainSoundTitle.text = name
                        UserDefaults.standard.setValue(name, forKey: "NameOfSound")
                        self.handleSoundsTap()
                        self.eqTableView.reloadData()
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
                /*
                if self.soundTitle.text == "Sounds" {
                    textField.placeholder = "Name this sound"
                }
                else {
                    textField.text = self.soundTitle.text
                }
                */
                textField.placeholder = "Name this sound"
                
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).characters.count ?? 0
                let textIsNotEmpty = textCount > 0
                self.nameCheck = textIsNotEmpty
                okAction.isEnabled = textIsNotEmpty
                
                // Observe the UITextFieldTextDidChange notification to be notified in the below block when text is changed
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object:textField , queue: OperationQueue.main, using: {_ in
                    // Being in this block means that something fired the UITextFieldTextDidChange notification.
                    let text = textField.text
                    if  Collections.cantTouchThis.contains(text!) {
                        okAction.isEnabled = false
                        self.nameCheck = false
                    }
                        /*
                         else if Collections.savedSounds.contains(text!) {
                         okAction.isEnabled = true
                         self.nameCheck = false
                         }
                         */
                        
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
        
        var soundsTapGesture = UITapGestureRecognizer()
    
        var effectsTapGesture = UITapGestureRecognizer()
       
        var hamburgerTapGesture = UITapGestureRecognizer()
        var cancelTapGesture = UITapGestureRecognizer()
        
        
        @objc func handleSoundsTap(){
            print("SOUNDS TAPPED")
            
            if self.soundsView.isHidden {
                self.setSoundsViewHeight()
                self.soundsView.isHidden = false
                self.soundsTab.backgroundColor = interface.highlight
                
                // hide other tabs
                self.availableEffects.isHidden = true
                self.availableEffectsView.isHidden = true
                self.effectsTab.backgroundColor = interface.tabs
            }
            else {
                self.soundsView.isHidden = true
                self.soundsTab.backgroundColor = interface.tabs
            }
        }
        @objc func handleEffectsTap(){
            print("EFFECTS TAPPED")
            if self.availableEffects.isHidden {
                self.setAvailableEffectsHeight()
                self.availableEffects.isHidden = false
                self.availableEffectsView.isHidden = false
                self.effectsTab.backgroundColor = interface.highlight
                
                // hide other tabs
                self.soundsView.isHidden = true
                self.soundsTab.backgroundColor = interface.tabs
         
            } else {
                self.availableEffects.isHidden = true
                self.availableEffectsView.isHidden = true
                self.effectsTab.backgroundColor = interface.tabs
            }
            
        }
    
        
        @objc func handleHamburgerTap() {
            if settingsView.isHidden {
                self.settingsView.isHidden = false
                self.hamburgerView.backgroundColor = interface.highlight
                
                // hide other tabs
                self.availableEffects.isHidden = true
                self.availableEffectsView.isHidden = true
                self.effectsTab.backgroundColor = interface.tabs
                self.soundsView.isHidden = true
                self.soundsTab.backgroundColor = interface.tabs
            }
            else {
                self.settingsView.isHidden = true
                self.hamburgerView.backgroundColor = interface.tabs
            }
        }
        
        
        @objc func handleCancelTap() {
            self.settingsView.isHidden = true
            self.hamburgerView.backgroundColor = interface.tabs
        }
    

    
}

class SystemVolumeView: MPVolumeView {
    override func volumeSliderRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.volumeSliderRect(forBounds: bounds)
        newBounds.origin.y = bounds.origin.y
        newBounds.size.height = bounds.size.height
        return newBounds
    }
    override func routeButtonRect(forBounds bounds: CGRect) -> CGRect {
        var newBounds = super.routeButtonRect(forBounds: bounds)
        newBounds.origin.y = bounds.origin.y
        newBounds.size.height = bounds.size.height
        return newBounds
    }
}
