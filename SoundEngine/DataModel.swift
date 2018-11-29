//
//  DataModel.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 26/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import AudioKit


struct effectData {
    var id = String()           // effect ID
    var opened = Bool()         // for expanding tableviewcells
    var title = String()        // name of effect for users
    var interface = String()    // type of interface for cell
}

class audio {
    static let effect = audio()
    
    
    static var availableUnitsData = [
        effectData(id: "bitCrusher", opened: false, title: "Bit Crusher", interface: "double"),
        effectData(id: "tanhDistortion", opened: false, title: "Tanh Distortion", interface: "quatro"),
        effectData(id: "dynaRageCompressor", opened: false, title: "Compressor", interface: "quatro")
        ]
    
     // VÄLIAIKAINEN MALLI
    static var selectedUnitsAfterData = [effectData(id: "delay", opened: false, title: "Delay", interface: "triple"),
                                         effectData(id: "ringModulator", opened: false, title: "Ring Modulator", interface: "quatro")
    ]
     // VÄLIAIKAINEN MALLI
    static var selectedUnitsBeforeData = [effectData(id: "clipper",opened: false, title: "Clipper", interface: "single"),
                                          effectData(id: "autoWah" , opened: false, title: "Wah Wah!", interface: "triple"),
                                          effectData(id: "decimator" ,opened: false, title: "Decimator", interface: "triple")
    ]
 
    func changeValues(id: String, slider: Int, value: Double) -> String {
        var newValue = String()
        switch id {
        case "bitCrusher" :
            switch slider {
            case 0:
                if  Effects.bitCrusher.isStarted == true {
                    Effects.bitCrusher.isStarted = false
                    bitCrusher?.stop()
                    newValue = "OFF"
                } else {
                    Effects.bitCrusher.isStarted = true
                    bitCrusher?.start()
                    newValue = "ON"
                }
            case 1:
                bitCrusher?.bitDepth = value
                Effects.bitCrusher.bitDepth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                bitCrusher?.sampleRate = value
                Effects.bitCrusher.sampleRate = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "tanhDistortion" :
            switch slider {
            case 0:
                if  Effects.tanhDistortion.isStarted == true {
                    Effects.tanhDistortion.isStarted = false
                    tanhDistortion?.stop()
                    newValue = "OFF"
                } else {
                    Effects.tanhDistortion.isStarted = true
                    tanhDistortion?.start()
                    newValue = "ON"
                }
            case 1:
                tanhDistortion?.pregain = value
                Effects.tanhDistortion.pregain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                tanhDistortion?.postgain = value
                Effects.tanhDistortion.postgain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                tanhDistortion?.positiveShapeParameter = value
                Effects.tanhDistortion.positiveShapeParameter = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                tanhDistortion?.negativeShapeParameter = value
                Effects.tanhDistortion.negativeShapeParameter = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
            
        case "dynaRageCompressor" :
            switch slider {
            case 0:
                if  Effects.dynaRageCompressor.isStarted == true {
                    Effects.dynaRageCompressor.isStarted = false
                    dynaRageCompressor?.stop()
                    newValue = "OFF"
                } else {
                    Effects.dynaRageCompressor.isStarted = true
                    dynaRageCompressor?.start()
                    newValue = "ON"
                }
            case 1:
                dynaRageCompressor?.ratio = value
                Effects.dynaRageCompressor.ratio = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                dynaRageCompressor?.threshold = value
                Effects.dynaRageCompressor.threshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                dynaRageCompressor?.attackDuration = value
                Effects.dynaRageCompressor.attackDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                dynaRageCompressor?.releaseDuration = value
                Effects.dynaRageCompressor.releaseDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
            
        case "autoWah" :
            switch slider {
            case 0:
                if  Effects.autoWah.isStarted == true {
                    Effects.autoWah.isStarted = false
                    autoWah?.stop()
                    newValue = "OFF"
                } else {
                    Effects.autoWah.isStarted = true
                    autoWah?.start()
                    newValue = "ON"
                }
            case 1:
                autoWah?.wah = value
                Effects.autoWah.wah = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                autoWah?.amplitude = value
                Effects.autoWah.amplitude = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                autoWah?.mix = value
                Effects.autoWah.mix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "delay" :
            switch slider {
            case 0:
                if  Effects.delay.isStarted == true {
                    Effects.delay.isStarted = false
                    delay?.stop()
                    newValue = "OFF"
                } else {
                    Effects.delay.isStarted = true
                    delay?.start()
                    newValue = "ON"
                }
            case 1:
                delay?.time = value
                Effects.delay.time = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                delay?.feedback = value
                Effects.delay.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                delay?.dryWetMix = value
                Effects.delay.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "decimator" :
            switch slider {
            case 0:
                if  Effects.decimator.isStarted == true {
                    Effects.decimator.isStarted = false
                    decimator?.stop()
                    newValue = "OFF"
                } else {
                    Effects.decimator.isStarted = true
                    decimator?.start()
                    newValue = "ON"
                }
            case 1:
                decimator?.decimation = value
                Effects.decimator.decimation = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                decimator?.rounding = value
                Effects.decimator.rounding = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                decimator?.mix = value
                Effects.decimator.mix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "clipper" :
            switch slider {
            case 0:
                if  Effects.clipper.isStarted == true {
                    Effects.clipper.isStarted = false
                    clipper?.stop()
                    newValue = "OFF"
                } else {
                    Effects.clipper.isStarted = true
                    clipper?.start()
                    newValue = "ON"
                }
            case 1:
            clipper?.limit = value
            Effects.clipper.limit = value
            let text = String(value)
            newValue = String(text.prefix(3))
            default: break
                
            }
        case "ringModulator" :
            switch slider {
            case 0:
                if  Effects.ringModulator.isStarted == true {
                    Effects.ringModulator.isStarted = false
                    ringModulator?.stop()
                    newValue = "OFF"
                } else {
                    Effects.ringModulator.isStarted = true
                    ringModulator?.start()
                    newValue = "ON"
                }
            case 1:
                ringModulator?.frequency1 = value
                Effects.ringModulator.frequency1 = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                ringModulator?.frequency2 = value
                Effects.ringModulator.frequency2 = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                ringModulator?.balance = value
                Effects.ringModulator.balance = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                ringModulator?.mix = value
                Effects.ringModulator.mix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
        default: break
        }
        return newValue
    }
    
    func getValues(id: String, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String, name : String, isOn: Bool) {
        var min = Float(0.0)
        var max = Float(1.0)
        var valueForSlider = Float(0.69)
        var name = ""
        var value = ""
        var isOn = Bool()
        switch id {
        case "bitCrusher" :
            // BITCRUSHER
            switch slider {
            case 1:
                min = Float(Effects.bitCrusher.bitDepthRange.lowerBound)
                max = Float(Effects.bitCrusher.bitDepthRange.upperBound)
                valueForSlider = Float(Effects.bitCrusher.bitDepth)
                name = "Bit Depth"
                value = String(Effects.bitCrusher.bitDepth)
                value = String(value.prefix(3))
                isOn = Effects.bitCrusher.isStarted
            case 2:
                min = Float(Effects.bitCrusher.sampleRateRange.lowerBound)
                max = Float(Effects.bitCrusher.sampleRateRange.upperBound)
                valueForSlider = Float(Effects.bitCrusher.sampleRate)
                name = "Sample Rate"
                value = String(Effects.bitCrusher.sampleRate)
                value = String(value.prefix(3))
                isOn = Effects.bitCrusher.isStarted
            default: break
            }
            
        case "tanhDistortion" :
            // TANH DISTORTION
            switch slider {
            case 1:
                min = Float(Effects.tanhDistortion.pregainRange.lowerBound)
                max = Float(Effects.tanhDistortion.pregainRange.upperBound)
                valueForSlider = Float(Effects.tanhDistortion.pregain)
                name = "Pregain"
                value = String(Effects.tanhDistortion.pregain)
                value = String(value.prefix(3))
                isOn = Effects.tanhDistortion.isStarted
            case 2:
                min = Float(Effects.tanhDistortion.postgainRange.lowerBound)
                max = Float(Effects.tanhDistortion.postgainRange.upperBound)
                valueForSlider = Float(Effects.tanhDistortion.postgain)
                name = "Postgain"
                value = String(Effects.tanhDistortion.postgain)
                value = String(value.prefix(3))
                isOn = Effects.tanhDistortion.isStarted
            case 3:
                min = Float(Effects.tanhDistortion.positiveShapeParameterRange.lowerBound)
                max = Float(Effects.tanhDistortion.positiveShapeParameterRange.upperBound)
                valueForSlider = Float(Effects.tanhDistortion.positiveShapeParameter)
                name = "+"
                value = String(Effects.tanhDistortion.positiveShapeParameter)
                value = String(value.prefix(3))
                isOn = Effects.tanhDistortion.isStarted
            case 4:
                min = Float(Effects.tanhDistortion.negativeShapeParameterRange.lowerBound)
                max = Float(Effects.tanhDistortion.negativeShapeParameterRange.upperBound)
                valueForSlider = Float(Effects.tanhDistortion.negativeShapeParameter)
                name = "-"
                value = String(Effects.tanhDistortion.negativeShapeParameter)
                value = String(value.prefix(3))
                isOn = Effects.tanhDistortion.isStarted
            default: break
            }
          
        case "dynaRageCompressor" :
            // COMPRESSOR
            switch slider {
            case 1:
                min = Float(Effects.dynaRageCompressor.ratioRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.ratioRange.upperBound)
                valueForSlider = Float(Effects.dynaRageCompressor.ratio)
                name = "Ratio"
                value = String(Effects.dynaRageCompressor.ratio)
                value = String(value.prefix(3))
                isOn = Effects.dynaRageCompressor.isStarted
            case 2:
                min = Float(Effects.dynaRageCompressor.thresholdRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.thresholdRange.upperBound)
                valueForSlider = Float(Effects.dynaRageCompressor.threshold)
                name = "Threshold"
                value = String(Effects.dynaRageCompressor.threshold)
                value = String(value.prefix(3))
                isOn = Effects.dynaRageCompressor.isStarted
            case 3:
                min = Float(Effects.dynaRageCompressor.attackDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.attackDurationRange.upperBound)
                valueForSlider = Float(Effects.dynaRageCompressor.attackDuration)
                name = "Attack"
                value = String(Effects.dynaRageCompressor.attackDuration)
                value = String(value.prefix(3))
                isOn = Effects.dynaRageCompressor.isStarted
            case 4:
                min = Float(Effects.dynaRageCompressor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.releaseDurationRange.upperBound)
                valueForSlider = Float(Effects.dynaRageCompressor.releaseDuration)
                name = "Release"
                value = String(Effects.dynaRageCompressor.releaseDuration)
                value = String(value.prefix(3))
                isOn = Effects.dynaRageCompressor.isStarted
            default: break
            }
           
        case "autoWah" :
            // AUTO WAH
            switch slider {
            case 1:
                min = Float(Effects.autoWah.wahRange.lowerBound)
                max = Float(Effects.autoWah.wahRange.upperBound)
                valueForSlider = Float(Effects.autoWah.wah)
                name = "Wah"
                value = String(Effects.autoWah.wah)
                value = String(value.prefix(3))
                isOn = Effects.autoWah.isStarted
            case 2:
                min = Float(Effects.autoWah.amplitudeRange.lowerBound)
                max = Float(Effects.autoWah.amplitudeRange.upperBound)
                valueForSlider = Float(Effects.autoWah.amplitude)
                name = "Amplitude"
                value = String(Effects.autoWah.amplitude)
                value = String(value.prefix(3))
                isOn = Effects.autoWah.isStarted
            case 3:
                min = Float(Effects.autoWah.mixRange.lowerBound)
                max = Float(Effects.autoWah.mixRange.upperBound)
                valueForSlider = Float(Effects.autoWah.mix)
                name = "Mix"
                value = String(Effects.autoWah.mix)
                value = String(value.prefix(3))
                isOn = Effects.autoWah.isStarted
            default: break
            }
            
        case "delay" :
            // DELAY
            switch slider {
            case 1:
                min = Float(Effects.delay.timeRange.lowerBound)
                max = Float(Effects.delay.timeRange.upperBound)
                valueForSlider = Float(Effects.delay.time)
                name = "Time"
                value = String(Effects.delay.time)
                value = String(value.prefix(3))
                isOn = Effects.delay.isStarted
            case 2:
                min = Float(Effects.delay.feedbackRange.lowerBound)
                max = Float(Effects.delay.feedbackRange.upperBound)
                valueForSlider = Float(Effects.delay.feedback)
                name = "Feedback"
                value = String(Effects.delay.feedback)
                value = String(value.prefix(3))
                isOn = Effects.delay.isStarted
            case 3:
                min = Float(Effects.delay.dryWetMixRange.lowerBound)
                max = Float(Effects.delay.dryWetMixRange.upperBound)
                valueForSlider = Float(Effects.delay.dryWetMix)
                name = "Mix"
                value = String(Effects.delay.dryWetMix)
                value = String(value.prefix(3))
                isOn = Effects.delay.isStarted
           
            default: break
            }
          
        case "decimator" :
            // DECIMATOR
            switch slider {
            case 1:
                min = Float(Effects.decimator.decimationRange.lowerBound)
                max = Float(Effects.decimator.decimationRange.upperBound)
                valueForSlider = Float(Effects.decimator.decimation)
                name = "Decimation"
                value = String(Effects.decimator.decimation)
                value = String(value.prefix(3))
                isOn = Effects.decimator.isStarted
            case 2:
                min = Float(Effects.decimator.roundingRange.lowerBound)
                max = Float(Effects.decimator.roundingRange.upperBound)
                valueForSlider = Float(Effects.decimator.rounding)
                name = "Rounding"
                value = String(Effects.decimator.rounding)
                value = String(value.prefix(3))
                isOn = Effects.decimator.isStarted
            case 3:
                min = Float(Effects.decimator.mixRange.lowerBound)
                max = Float(Effects.decimator.mixRange.upperBound)
                valueForSlider = Float(Effects.decimator.mix)
                name = "Mix"
                value = String(Effects.decimator.mix)
                value = String(value.prefix(3))
                isOn = Effects.decimator.isStarted
            default: break
            }
          
        case "clipper" :
            // CLIPPER
            switch slider {
            case 1:
                min = Float(Effects.clipper.limitRange.lowerBound)
                max = Float(Effects.clipper.limitRange.upperBound)
                valueForSlider = Float(Effects.clipper.limit)
                name = "Limit"
                value = String(Effects.clipper.limit)
                value = String(value.prefix(3))
                isOn = Effects.clipper.isStarted
            default: break
            }
         
        case "ringModulator" :
            // RING MODULATOR
            switch slider {
            case 1:
                min = Float(Effects.ringModulator.frequencyRange.lowerBound)
                max = Float(Effects.ringModulator.frequencyRange.upperBound)
                valueForSlider = Float(Effects.ringModulator.frequency1)
                name = "Freq 1"
                value = String(Effects.ringModulator.frequency1)
                value = String(value.prefix(3))
                isOn = Effects.ringModulator.isStarted
            case 2:
                min = Float(Effects.ringModulator.frequencyRange.lowerBound)
                max = Float(Effects.ringModulator.frequencyRange.upperBound)
                valueForSlider = Float(Effects.ringModulator.frequency2)
                name = "Freq 2"
                value = String(Effects.ringModulator.frequency2)
                value = String(value.prefix(3))
                isOn = Effects.ringModulator.isStarted
            case 3:
                min = Float(Effects.ringModulator.balanceRange.lowerBound)
                max = Float(Effects.ringModulator.balanceRange.upperBound)
                valueForSlider = Float(Effects.ringModulator.balance)
                name = "Balance"
                value = String(Effects.ringModulator.balance)
                value = String(value.prefix(3))
                isOn = Effects.ringModulator.isStarted
            case 4:
                min = Float(Effects.ringModulator.mixRange.lowerBound)
                max = Float(Effects.ringModulator.mixRange.upperBound)
                valueForSlider = Float(Effects.ringModulator.mix)
                name = "Mix"
                value = String(Effects.ringModulator.mix)
                value = String(value.prefix(3))
                isOn = Effects.ringModulator.isStarted
            default: break
            }
        default: break
        }
        return (min, max, valueForSlider, value, name, isOn)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
    
    func start() {
        createEffects()
        audioKitSettings()
       // checkUserDefaults()
        createEffectList()
      //  setEffectValues(initial: true)
      //  newList()
        connectMic()
        connectEffects()
    }
    
   
    func audioKitSettings() {
        
        AKSettings.bufferLength = .shortest
        
        AKSettings.audioInputEnabled = true
        
        AKSettings.playbackWhileMuted = true
        print("audioFormat")
        print(AKSettings.audioFormat.sampleRate) // channels, sample rate, bit depth, interleaved
        
        AKSettings.defaultToSpeaker = true      // Whether to output to the speaker (rather than receiver) when audio input is enabled
        
        AKSettings.useBluetooth = true          // Whether to use bluetooth when audio input is enabled
        
        AKSettings.bluetoothOptions = .mixWithOthers
        
        AKSettings.allowAirPlay = true
        
        AKSettings.notificationsEnabled = false
        
        AKSettings.recordingBufferLength = .veryLong
   
        print("headPhonesPlugged")
        print(AKSettings.headPhonesPlugged)
      
     
        
    }
    
    func createEffectList() {
        
        // initial preps 'n filters
        
        
        // before amp
        for effect in 0..<audio.selectedUnitsBeforeData.count {
            let id = audio.selectedUnitsBeforeData[effect].id
            switch id {
            case "bitCrusher" : self.soundEffectsBefore.append(bitCrusher!)
            case "clipper":  self.soundEffectsBefore.append(clipper!)
            case "dynaRageCompressor":  self.soundEffectsBefore.append(dynaRageCompressor!)
            case "autoWah":  self.soundEffectsBefore.append(autoWah!)
            case "delay":  self.soundEffectsBefore.append(delay!)
            case "decimator": self.soundEffectsBefore.append(decimator!)
            case "tanhDistortion": self.soundEffectsBefore.append(tanhDistortion!)
            case "ringModulator": self.soundEffectsBefore.append(ringModulator!)
            default : print("NOTHING to do over HERE")
                
            }
        }
        // amp
        
        
        // after amp
        for effect in 0..<audio.selectedUnitsAfterData.count {
            let id = audio.selectedUnitsAfterData[effect].id
            switch id {
            case "bitCrusher" : self.soundEffectsAfter.append(bitCrusher!)
            case "clipper":  self.soundEffectsAfter.append(clipper!)
            case "dynaRageCompressor":  self.soundEffectsAfter.append(dynaRageCompressor!)
            case "autoWah":  self.soundEffectsAfter.append(autoWah!)
            case "delay":  self.soundEffectsAfter.append(delay!)
            case "decimator": self.soundEffectsAfter.append(decimator!)
            case "tanhDistortion": self.soundEffectsAfter.append(tanhDistortion!)
            case "ringModulator": self.soundEffectsAfter.append(ringModulator!)
            default : print("NOTHING to do over HERE EITHER")
                
            }
        }
        
        // finishing filters
        
    }
    
    func connectMic() {
        
        // mieti tää
        defaultAmp = Amp.model.defaultAmpModel(input: mic!)
        defaultAmp?.connect(to: inputMixer!)
    }
    
    func connectFilters() {
        
        
    }
    
    func connectEffects() {
       
        // CONNECT to input: If there are effects before main unit
        for pedal in 0..<soundEffectsBefore.count {
            
            if pedal == 0 {
                inputMixer?.connect(to: soundEffectsBefore[0])
                
            }
            else {
                soundEffectsBefore[pedal-1].connect(to: soundEffectsBefore[pedal])
            }
        }
        
        if soundEffectsBefore .isEmpty {
            inputMixer!.connect(to: effectsBeforeMixer!)
        } else {
            soundEffectsBefore.last?.connect(to: effectsBeforeMixer!)
        }
        
        
        
        // CONNECT to soundEffectsBefore: If there are units in the main unit
        for pedal in 0..<mainUnits.count {
            
            if pedal == 0 {
                effectsBeforeMixer?.connect(to: mainUnits[0])
                
            }
            else {
                mainUnits[pedal-1].connect(to: mainUnits[pedal])
            }
        }
        
        if mainUnits .isEmpty {
            effectsBeforeMixer!.connect(to: masterMixer!)
        } else {
            mainUnits.last?.connect(to: masterMixer!)
        }
        
        
        
        
        
        
        // CONNECT to mainUnits: If there are units in the soundEffectsAfter
        for pedal in 0..<soundEffectsAfter.count {
            
            if pedal == 0 {
                masterMixer?.connect(to: soundEffectsAfter[0])
                
            }
            else {
                soundEffectsAfter[pedal-1].connect(to: soundEffectsAfter[pedal])
            }
        }
        
        if soundEffectsAfter .isEmpty {
            masterMixer!.connect(to: effectsAfterMixer!)
        } else {
            soundEffectsAfter.last?.connect(to: effectsAfterMixer!)
        }
        
        
        
        // CONNECT to soundEffectsAfter: If there are units in the finishers
        for pedal in 0..<finishers.count {
            
            if pedal == 0 {
                effectsAfterMixer?.connect(to: finishers[0])
                
            }
            else {
                finishers[pedal-1].connect(to: finishers[pedal])
            }
        }
        
        if finishers .isEmpty {
            effectsAfterMixer!.connect(to: outputMixer!)
        } else {
            finishers.last?.connect(to: outputMixer!)
        }
        
        /*
         // TESTING FILTERS
        masterMixer?.connect(to: masterBooster!)
        masterBooster?.connect(to: toneFilter!)
        toneFilter?.connect(to: equalizerFilter1!)
        equalizerFilter1?.connect(to: equalizerFilter2!)
        equalizerFilter2?.connect(to: equalizerFilter3!)
        equalizerFilter3?.connect(to: equalizerFilter4!)
        equalizerFilter4?.connect(to: equalizerFilter5!)
        equalizerFilter5?.connect(to: equalizerFilter6!)
        equalizerFilter6?.connect(to: highPassFilter!)
        highPassFilter?.connect(to: lowPassFilter!)
        lowPassFilter?.connect(to: filterMixer!)
        filterMixer?.connect(to: masterMixer!)
        */
        
        
        
        
        // LAST TO OUTPUT
        AudioKit.output = outputMixer
        if AudioKit.output == nil {
            AudioKit.output = inputMixer
        }
   
        // START AUDIOKIT
        do {
            try AudioKit.start()
            print("START AUDIOKIT")
        } catch {
            print("Could not start AudioKit")
        }
        
    }
    
    func unplugEffects() {
        print("-------------------------    DISCONNECTING")
        print(AudioKit.printConnections())
        do {
            try AudioKit.stop()
        } catch {
            print("Could not stop AudioKit")
        }
        
        for pedal in 0..<soundEffectsBefore.count {
            soundEffectsBefore[pedal].disconnectOutput()
            soundEffectsBefore[pedal].disconnectInput()
            print("DISONNECT \(soundEffectsBefore[pedal])")
        }
        inputMixer?.disconnectOutput()
        print("DISONNECT \(inputMixer)")
        // TESTING FILTERS
        // TESTING EQ
        // CONNECT EQ AFTER EFFECTS
        equalizerFilter1?.disconnectInput()
        equalizerFilter1?.disconnectOutput()
        
        equalizerFilter2?.disconnectInput()
        equalizerFilter2?.disconnectOutput()
        
        equalizerFilter3?.disconnectInput()
        equalizerFilter3?.disconnectOutput()
        
        equalizerFilter4?.disconnectInput()
        equalizerFilter4?.disconnectOutput()
        
        equalizerFilter5?.disconnectInput()
        equalizerFilter5?.disconnectOutput()
        
        equalizerFilter6?.disconnectInput()
        equalizerFilter6?.disconnectOutput()
        print("DISONNECT \(equalizerFilter6)")
        
        highPassFilter?.disconnectInput()
        highPassFilter?.disconnectOutput()
        print("DISONNECT \(highPassFilter)")
        
        lowPassFilter?.disconnectInput()
        lowPassFilter?.disconnectOutput()
        print("DISONNECT \(lowPassFilter)")
        
        toneFilter?.disconnectInput()
        toneFilter?.disconnectOutput()
        
        effectsBeforeMixer?.disconnectInput()
        effectsBeforeMixer?.disconnectOutput()
        filterMixer?.disconnectInput()
        filterMixer?.disconnectOutput()
        
        masterBooster?.disconnectInput()
        masterBooster?.disconnectOutput()
        
        print("\n-------------------------DISCONNECT READY")
        print(AudioKit.printConnections())
        
        /*
         bitCrusher?.detach()
         decimator?.detach()
         clipper?.detach()
         dynaRageCompressor?.detach()
         autoWah?.detach()
         tanhDistortion?.detach()
         distortion?.detach()
         delay?.detach()
         */
    }
    
    func resetEffectChain() {
        unplugEffects()
        connectEffects()
        print(soundEffectsBefore)
        UserDefaults.standard.set(Effects.selectedEffects, forKey: "effectChain")
    }

    
    
    
    
    
    
    
    
    
    

    var defaultAmp: AKNode?
    
    
    var inputMixer: AKMixer?
    var effectsBeforeMixer: AKMixer?
    var masterMixer: AKMixer?
    var effectsAfterMixer: AKMixer?
    var outputMixer: AKMixer?
    
    
    
    var filterMixer: AKMixer?
    
    var mic: AKMicrophone?
    
    
    // EFFECTS
    var bitCrusher: AKBitCrusher?                   // 1
    var tanhDistortion: AKTanhDistortion?           // 2
    var dynaRageCompressor: AKDynaRageCompressor?   // 3
    var autoWah: AKAutoWah?                         // 4
    var delay: AKDelay?                             // 5
    var decimator: AKDecimator?                     // 6
    var clipper: AKClipper?                         // 7
    var ringModulator: AKRingModulator?             // 8
    
    
    // FILTERS
    var equalizerFilter1: AKEqualizerFilter?
    var equalizerFilter2: AKEqualizerFilter?
    var equalizerFilter3: AKEqualizerFilter?
    var equalizerFilter4: AKEqualizerFilter?
    var equalizerFilter5: AKEqualizerFilter?
    var equalizerFilter6: AKEqualizerFilter?
    var equalizerFilter7: AKEqualizerFilter?
    var equalizerFilter8: AKEqualizerFilter?
    var equalizerFilter9: AKEqualizerFilter?
    var equalizerFilter10: AKEqualizerFilter?
    var equalizerFilter11: AKEqualizerFilter?
    var equalizerFilter12: AKEqualizerFilter?
    
    var highPassFilter : AKHighPassFilter?
    var lowPassFilter: AKLowPassFilter?
    var toneFilter: AKToneFilter?
    
    
    var masterBooster: AKBooster?
    
    // ARRAYS FOR CONSTRUCTING THE SOUND
    var soundEffectsBefore = [AKInput]()
    var soundEffectsAfter = [AKInput]()
    var preparations = [AKInput]()
    var finishers = [AKInput]()
    var mainUnits = [AKInput]()
    
    
    
    func createEffects() {
        
        defaultAmp = AKNode()
        
        // UTILITIES
        mic = AKMicrophone()
        
        // MIXERS
        inputMixer = AKMixer()
        filterMixer = AKMixer()
        effectsBeforeMixer = AKMixer()
        masterMixer = AKMixer()
        effectsAfterMixer = AKMixer()
        outputMixer = AKMixer()
        
        masterMixer?.start()
        inputMixer?.start()
        effectsBeforeMixer?.start()
        effectsAfterMixer?.start()
        filterMixer?.start()
        outputMixer?.start()
        
        // EFFECTS
        delay = AKDelay()
        bitCrusher =  AKBitCrusher()
        clipper =  AKClipper()
        dynaRageCompressor =  AKDynaRageCompressor()
        autoWah =  AKAutoWah()
        tanhDistortion = AKTanhDistortion()
        decimator = AKDecimator()
        ringModulator = AKRingModulator()
        
        
        // FILTERS
        
        equalizerFilter1 = AKEqualizerFilter()
        equalizerFilter1?.bandwidth = 44.7
        equalizerFilter1?.centerFrequency = 32
        equalizerFilter1?.gain = Filters.equalizerFilter.filterBand1Gain
        
        equalizerFilter2 = AKEqualizerFilter()
        equalizerFilter2?.bandwidth = 70.8
        equalizerFilter2?.centerFrequency = 64
        equalizerFilter2?.gain = Filters.equalizerFilter.filterBand2Gain
        
        equalizerFilter3 = AKEqualizerFilter()
        equalizerFilter3?.bandwidth = 141
        equalizerFilter3?.centerFrequency = 125
        equalizerFilter3?.gain = Filters.equalizerFilter.filterBand3Gain
        
        equalizerFilter4 = AKEqualizerFilter()
        equalizerFilter4?.bandwidth = 282
        equalizerFilter4?.centerFrequency = 250
        equalizerFilter4?.gain = Filters.equalizerFilter.filterBand4Gain
        
        equalizerFilter5 = AKEqualizerFilter()
        equalizerFilter5?.bandwidth = 562
        equalizerFilter5?.centerFrequency = 500
        equalizerFilter5?.gain = Filters.equalizerFilter.filterBand5Gain
        
        equalizerFilter6 = AKEqualizerFilter()
        equalizerFilter6?.bandwidth = 1112
        equalizerFilter6?.centerFrequency = 1000
        equalizerFilter6?.gain = Filters.equalizerFilter.filterBand6Gain
        
        equalizerFilter7 = AKEqualizerFilter()
        equalizerFilter7?.bandwidth = 2222
        equalizerFilter7?.centerFrequency = 2000
        equalizerFilter7?.gain = Filters.equalizerFilter.filterBand7Gain
        
        equalizerFilter8 = AKEqualizerFilter()
        equalizerFilter8?.bandwidth = 4444
        equalizerFilter8?.centerFrequency = 4000
        equalizerFilter8?.gain = Filters.equalizerFilter.filterBand8Gain
        
        equalizerFilter9 = AKEqualizerFilter()
        equalizerFilter9?.bandwidth = 8888
        equalizerFilter9?.centerFrequency = 8000
        equalizerFilter9?.gain = Filters.equalizerFilter.filterBand9Gain
        
        equalizerFilter10 = AKEqualizerFilter()
        equalizerFilter10?.bandwidth = 17000
        equalizerFilter10?.centerFrequency = 16000
        equalizerFilter10?.gain = Filters.equalizerFilter.filterBand10Gain
        
        
        highPassFilter = AKHighPassFilter()
        lowPassFilter = AKLowPassFilter()
        
        toneFilter = AKToneFilter()
        toneFilter?.start()
        
        masterBooster = AKBooster()
        masterBooster?.start()
        
    }

}

/*
 Sub-Bass (16 Hz to 60 Hz). ...
 Bass (60 Hz to 250 Hz). ...
 Low Mids (250 Hz to 2 kHz). ...
 High Mids (2 kHz to 4 kHz). ...
 Presence (4 kHz to 6 kHz). ...
 Brilliance (6 kHz to 16 kHz).
 */
