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
    var sliderRowsForTable = String()    // type of interface for cell
}

class audio {
    static let shared = audio()
    
    static var bufferLength = Int()
    
   static let allPossibleEffectsData = [
    effectData(id: "bitCrusher", opened: false, title: "Bit Crusher", sliderRowsForTable: "double"),
    effectData(id: "tanhDistortion", opened: false, title: "Tanh Distortion", sliderRowsForTable: "quatro"),
    effectData(id: "dynaRageCompressor", opened: false, title: "Compressor", sliderRowsForTable: "quatro"),
    effectData(id: "delay", opened: false, title: "Delay", sliderRowsForTable: "triple"),
    effectData(id: "ringModulator", opened: false, title: "Ring Modulator", sliderRowsForTable: "quatro"),
    effectData(id: "clipper",opened: false, title: "Clipper", sliderRowsForTable: "single"),
    effectData(id: "autoWah" , opened: false, title: "Wah Wah!", sliderRowsForTable: "triple"),
    effectData(id: "decimator" ,opened: false, title: "Decimator", sliderRowsForTable: "triple")
    ]
    
    
    static let finalFiltersData = [effectData(id: "masterBooster", opened: false, title: "Booster", sliderRowsForTable: ""),
                                   effectData(id: "toneFilter", opened: false, title: "Tone", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter1", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter2", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter3", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter4", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter5", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter6", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter7", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter8", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter9", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter10", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter11", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "equalizerFilter12", opened: false, title: "", sliderRowsForTable: ""),
                                   effectData(id: "highPassFilter", opened: false, title: "High Pass", sliderRowsForTable: ""),
                                   effectData(id: "lowPassFilter", opened: false, title: "Low Pass", sliderRowsForTable: "")
    ]
    
    
    static var availableEffectsData = [
        effectData(id: "bitCrusher", opened: false, title: "Bit Crusher", sliderRowsForTable: "double"),
        effectData(id: "tanhDistortion", opened: false, title: "Tanh Distortion", sliderRowsForTable: "quatro"),
        effectData(id: "dynaRageCompressor", opened: false, title: "Compressor", sliderRowsForTable: "quatro"),
        effectData(id: "delay", opened: false, title: "Delay", sliderRowsForTable: "triple"),
        effectData(id: "ringModulator", opened: false, title: "Ring Modulator", sliderRowsForTable: "quatro")
        ]
    
     // VÄLIAIKAINEN MALLI
    /*
    static var selectedUnitsAfterData = [effectData(id: "delay", opened: false, title: "Delay", sliderRowsForTable: "triple"),
                                         effectData(id: "ringModulator", opened: false, title: "Ring Modulator", sliderRowsForTable: "quatro")
    ]
     
     */
     // VÄLIAIKAINEN MALLI
    static var selectedEffectsData = [effectData(id: "clipper",opened: false, title: "Clipper", sliderRowsForTable: "single"),
                                          effectData(id: "autoWah" , opened: false, title: "Wah Wah!", sliderRowsForTable: "triple"),
                                          effectData(id: "decimator" ,opened: false, title: "Decimator", sliderRowsForTable: "triple")
    ]
 
    func changeValues(id: String, slider: Int, value: Double) -> String {
        var newValue = String()
        switch id {
        case "bitCrusher" :
            switch slider {
            case 0:
                if  audio.bitCrusher!.isStarted == true {
                    audio.bitCrusher?.stop()
                    newValue = "OFF"
                } else {
                    audio.bitCrusher?.start()
                    newValue = "ON"
                }
            case 1:
                audio.bitCrusher?.bitDepth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.bitCrusher?.sampleRate = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "tanhDistortion" :
            switch slider {
            case 0:
                if  audio.tanhDistortion!.isStarted == true {
                    audio.tanhDistortion?.stop()
                    newValue = "OFF"
                } else {
                    audio.tanhDistortion?.start()
                    newValue = "ON"
                }
            case 1:
                audio.tanhDistortion?.pregain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.tanhDistortion?.postgain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.tanhDistortion?.positiveShapeParameter = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.tanhDistortion?.negativeShapeParameter = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
            
        case "dynaRageCompressor" :
            switch slider {
            case 0:
                if  audio.dynaRageCompressor!.isStarted == true {
                    audio.dynaRageCompressor?.stop()
                    newValue = "OFF"
                } else {
                    audio.dynaRageCompressor?.start()
                    newValue = "ON"
                }
            case 1:
                audio.dynaRageCompressor?.ratio = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.dynaRageCompressor?.threshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.dynaRageCompressor?.attackDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.dynaRageCompressor?.releaseDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
            
        case "autoWah" :
            switch slider {
            case 0:
                if  audio.autoWah!.isStarted == true {
                    audio.autoWah?.stop()
                    newValue = "OFF"
                } else {
                    audio.autoWah?.start()
                    newValue = "ON"
                }
            case 1:
                audio.autoWah?.wah = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.autoWah?.amplitude = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.autoWah?.mix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "delay" :
            switch slider {
            case 0:
                if  audio.delay!.isStarted == true {
                    audio.delay?.stop()
                    newValue = "OFF"
                } else {
                    audio.delay?.start()
                    newValue = "ON"
                }
            case 1:
                audio.delay?.time = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.delay?.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.delay?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "decimator" :
            switch slider {
            case 0:
                if  audio.decimator?.isStarted == true {
                    audio.decimator?.stop()
                    newValue = "OFF"
                } else {
                    audio.decimator?.start()
                    newValue = "ON"
                }
            case 1:
                audio.decimator?.decimation = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.decimator?.rounding = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.decimator?.mix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "clipper" :
            switch slider {
            case 0:
                if  audio.clipper!.isStarted == true {
                    audio.clipper?.stop()
                    newValue = "OFF"
                } else {
                    audio.clipper?.start()
                    newValue = "ON"
                }
            case 1:
            audio.clipper?.limit = value
            let text = String(value)
            newValue = String(text.prefix(3))
            default: break
                
            }
        case "ringModulator" :
            switch slider {
            case 0:
                if  audio.ringModulator!.isStarted == true {
                    audio.ringModulator?.stop()
                    newValue = "OFF"
                } else {
                    audio.ringModulator?.start()
                    newValue = "ON"
                }
            case 1:
                audio.ringModulator?.frequency1 = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.ringModulator?.frequency2 = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.ringModulator?.balance = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.ringModulator?.mix = value
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
                valueForSlider = Float(audio.bitCrusher!.bitDepth)
                name = "Bit Depth"
                value = String(audio.bitCrusher!.bitDepth)
                value = String(value.prefix(3))
                isOn = audio.bitCrusher!.isStarted
            case 2:
                min = Float(Effects.bitCrusher.sampleRateRange.lowerBound)
                max = Float(Effects.bitCrusher.sampleRateRange.upperBound)
                valueForSlider = Float(audio.bitCrusher!.sampleRate)
                name = "Sample Rate"
                value = String(audio.bitCrusher!.sampleRate)
                value = String(value.prefix(3))
                isOn = audio.bitCrusher!.isStarted
            default: break
            }
            
        case "tanhDistortion" :
            // TANH DISTORTION
            switch slider {
            case 1:
                min = Float(Effects.tanhDistortion.pregainRange.lowerBound)
                max = Float(Effects.tanhDistortion.pregainRange.upperBound)
                valueForSlider = Float(audio.tanhDistortion!.pregain)
                name = "Pregain"
                value = String(audio.tanhDistortion!.pregain)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            case 2:
                min = Float(Effects.tanhDistortion.postgainRange.lowerBound)
                max = Float(Effects.tanhDistortion.postgainRange.upperBound)
                valueForSlider = Float(audio.tanhDistortion!.postgain)
                name = "Postgain"
                value = String(audio.tanhDistortion!.postgain)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            case 3:
                min = Float(Effects.tanhDistortion.positiveShapeParameterRange.lowerBound)
                max = Float(Effects.tanhDistortion.positiveShapeParameterRange.upperBound)
                valueForSlider = Float(audio.tanhDistortion!.positiveShapeParameter)
                name = "+"
                value = String(audio.tanhDistortion!.positiveShapeParameter)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            case 4:
                min = Float(Effects.tanhDistortion.negativeShapeParameterRange.lowerBound)
                max = Float(Effects.tanhDistortion.negativeShapeParameterRange.upperBound)
                valueForSlider = Float(audio.tanhDistortion!.negativeShapeParameter)
                name = "-"
                value = String(audio.tanhDistortion!.negativeShapeParameter)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            default: break
            }
          
        case "dynaRageCompressor" :
            // COMPRESSOR
            switch slider {
            case 1:
                min = Float(Effects.dynaRageCompressor.ratioRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.ratioRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.ratio)
                name = "Ratio"
                value = String(audio.dynaRageCompressor!.ratio)
                value = String(value.prefix(3))
                isOn = audio.dynaRageCompressor!.isStarted
            case 2:
                min = Float(Effects.dynaRageCompressor.thresholdRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.thresholdRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.threshold)
                name = "Threshold"
                value = String(audio.dynaRageCompressor!.threshold)
                value = String(value.prefix(3))
                isOn = audio.dynaRageCompressor!.isStarted
            case 3:
                min = Float(Effects.dynaRageCompressor.attackDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.attackDuration)
                name = "Attack"
                value = String(audio.dynaRageCompressor!.attackDuration)
                value = String(value.prefix(3))
                isOn = audio.dynaRageCompressor!.isStarted
            case 4:
                min = Float(Effects.dynaRageCompressor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.releaseDuration)
                name = "Release"
                value = String(audio.dynaRageCompressor!.releaseDuration)
                value = String(value.prefix(3))
                isOn = audio.dynaRageCompressor!.isStarted
            default: break
            }
           
        case "autoWah" :
            // AUTO WAH
            switch slider {
            case 1:
                min = Float(Effects.autoWah.wahRange.lowerBound)
                max = Float(Effects.autoWah.wahRange.upperBound)
                valueForSlider = Float(audio.autoWah!.wah)
                name = "Wah"
                value = String(audio.autoWah!.wah)
                value = String(value.prefix(3))
                isOn = audio.autoWah!.isStarted
            case 2:
                min = Float(Effects.autoWah.amplitudeRange.lowerBound)
                max = Float(Effects.autoWah.amplitudeRange.upperBound)
                valueForSlider = Float(audio.autoWah!.amplitude)
                name = "Amplitude"
                value = String(audio.autoWah!.amplitude)
                value = String(value.prefix(3))
                isOn = audio.autoWah!.isStarted
            case 3:
                min = Float(Effects.autoWah.mixRange.lowerBound)
                max = Float(Effects.autoWah.mixRange.upperBound)
                valueForSlider = Float(audio.autoWah!.mix)
                name = "Mix"
                value = String(audio.autoWah!.mix)
                value = String(value.prefix(3))
                isOn = audio.autoWah!.isStarted
            default: break
            }
            
        case "delay" :
            // DELAY
            switch slider {
            case 1:
                min = Float(Effects.delay.timeRange.lowerBound)
                max = Float(Effects.delay.timeRange.upperBound)
                valueForSlider = Float(audio.delay!.time)
                name = "Time"
                value = String(audio.delay!.time)
                value = String(value.prefix(3))
                isOn = audio.delay!.isStarted
            case 2:
                min = Float(Effects.delay.feedbackRange.lowerBound)
                max = Float(Effects.delay.feedbackRange.upperBound)
                valueForSlider = Float(audio.delay!.feedback)
                name = "Feedback"
                value = String(audio.delay!.feedback)
                value = String(value.prefix(3))
                isOn = audio.delay!.isStarted
            case 3:
                min = Float(Effects.delay.dryWetMixRange.lowerBound)
                max = Float(Effects.delay.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.delay!.dryWetMix)
                name = "Mix"
                value = String(audio.delay!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.delay!.isStarted
           
            default: break
            }
          
        case "decimator" :
            // DECIMATOR
            switch slider {
            case 1:
                min = Float(Effects.decimator.decimationRange.lowerBound)
                max = Float(Effects.decimator.decimationRange.upperBound)
                valueForSlider = Float(audio.decimator!.decimation)
                name = "Decimation"
                value = String(audio.decimator!.decimation)
                value = String(value.prefix(3))
                isOn = audio.decimator!.isStarted
            case 2:
                min = Float(Effects.decimator.roundingRange.lowerBound)
                max = Float(Effects.decimator.roundingRange.upperBound)
                valueForSlider = Float(audio.decimator!.rounding)
                name = "Rounding"
                value = String(audio.decimator!.rounding)
                value = String(value.prefix(3))
                isOn = audio.decimator!.isStarted
            case 3:
                min = Float(Effects.decimator.mixRange.lowerBound)
                max = Float(Effects.decimator.mixRange.upperBound)
                valueForSlider = Float(audio.decimator!.mix)
                name = "Mix"
                value = String(audio.decimator!.mix)
                value = String(value.prefix(3))
                isOn = audio.decimator!.isStarted
            default: break
            }
          
        case "clipper" :
            // CLIPPER
            switch slider {
            case 1:
                min = Float(Effects.clipper.limitRange.lowerBound)
                max = Float(Effects.clipper.limitRange.upperBound)
                valueForSlider = Float(audio.clipper!.limit)
                name = "Limit"
                value = String(audio.clipper!.limit)
                value = String(value.prefix(3))
                isOn = audio.clipper!.isStarted
            default: break
            }
         
        case "ringModulator" :
            // RING MODULATOR
            switch slider {
            case 1:
                min = Float(Effects.ringModulator.frequencyRange.lowerBound)
                max = Float(Effects.ringModulator.frequencyRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.frequency1)
                name = "Freq 1"
                value = String(audio.ringModulator!.frequency1)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            case 2:
                min = Float(Effects.ringModulator.frequencyRange.lowerBound)
                max = Float(Effects.ringModulator.frequencyRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.frequency2)
                name = "Freq 2"
                value = String(audio.ringModulator!.frequency2)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            case 3:
                min = Float(Effects.ringModulator.balanceRange.lowerBound)
                max = Float(Effects.ringModulator.balanceRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.balance)
                name = "Balance"
                value = String(audio.ringModulator!.balance)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            case 4:
                min = Float(Effects.ringModulator.mixRange.lowerBound)
                max = Float(Effects.ringModulator.mixRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.mix)
                name = "Mix"
                value = String(audio.ringModulator!.mix)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            default: break
            }
        default: break
        }
        return (min, max, valueForSlider, value, name, isOn)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
 
    
    func startAudio() {
        
        audioKitSettings()
        createInputListForSound()
       // createEffectList()
      //  setEffectValues(initial: true)
      //  newList()
        connectMic()
        connectAudioInputs()
        //connectEffects()
        
        print("---------- STARTING AUDIO WITH ----------")
        print("selectedAudioInputs \(audio.selectedAudioInputs)")
     
    }
    
    func setBufferLength(segment: Int) {
        
        switch segment {
        case 1:
            AKSettings.bufferLength = .shortest     // 0.0007
                                                    // 32
        case 2:
            AKSettings.bufferLength = .veryShort    // 0.001
                                                    // 64
        case 3:
            AKSettings.bufferLength = .short        // 0.002
                                                    // 128
        case 4:
            AKSettings.bufferLength = .medium       // 0.006
                                                    // 256
        case 5:
            AKSettings.bufferLength = .long         // 0.01
                                                    // 512
        case 6:
            AKSettings.bufferLength = .veryLong     // 0.02
                                                    // 1024
        case 7:
            AKSettings.bufferLength = .huge         // 0.05
                                                    // 2048
        case 8:
            AKSettings.bufferLength = .longest      // 0.09
                                                    // 4096
        default:
            AKSettings.bufferLength = .huge         // 0.05
                                                    // 2048
        }
        settings.bufferLenght = segment
        
        print("Buffer Legth   \(AKSettings.bufferLength.duration)")
        print("Buffer Legth   \(AKSettings.bufferLength.samplesCount)")
    }
    
    func audioKitSettings() {
        
        audio.shared.setBufferLength(segment: settings.bufferLenght)
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
   /*
    func createEffectList() {
        
        
        
       
        for effect in 0..<audio.selectedUnitsBeforeData.count {
            let id = audio.selectedUnitsBeforeData[effect].id
            switch id {
            case "bitCrusher" : self.firstList.append(audio.bitCrusher!)
            case "clipper":  self.firstList.append(clipper!)
            case "dynaRageCompressor":  self.firstList.append(dynaRageCompressor!)
            case "autoWah":  self.firstList.append(autoWah!)
            case "delay":  self.firstList.append(delay!)
            case "decimator": self.firstList.append(decimator!)
            case "tanhDistortion": self.firstList.append(tanhDistortion!)
            case "ringModulator": self.firstList.append(ringModulator!)
            default : print("NOTHING to do over HERE")
                
            }
        }
     
     
        for effect in 0..<audio.selectedUnitsAfterData.count {
            let id = audio.selectedUnitsAfterData[effect].id
            switch id {
            case "bitCrusher" : self.thirdList.append(audio.bitCrusher!)
            case "clipper":  self.thirdList.append(clipper!)
            case "dynaRageCompressor":  self.thirdList.append(dynaRageCompressor!)
            case "autoWah":  self.thirdList.append(autoWah!)
            case "delay":  self.thirdList.append(delay!)
            case "decimator": self.thirdList.append(decimator!)
            case "tanhDistortion": self.thirdList.append(tanhDistortion!)
            case "ringModulator": self.thirdList.append(ringModulator!)
            default : print("NOTHING to do over HERE EITHER")
                
            }
        }
        
        for effect in 0..<audio.finalFiltersData.count {
            let id = audio.finalFiltersData[effect].id
            switch id {
            case "toneFilter" : self.audioOut.append(audio.toneFilter!)
            
            default : print("NOTHING to do over HERE EITHER neither here")
                
            }
        }
        
  
        // Make one big list for the whole sound
        
        
    }
  
    */
    
    func addToselectedEffects(id : String) {
        switch id {
            //effects
        case "bitCrusher" : audio.selectedAudioInputs.append(audio.bitCrusher!)
        case "clipper":  audio.selectedAudioInputs.append(audio.clipper!)
        case "dynaRageCompressor":  audio.selectedAudioInputs.append(audio.dynaRageCompressor!)
        case "autoWah":  audio.selectedAudioInputs.append(audio.autoWah!)
        case "delay":  audio.selectedAudioInputs.append(audio.delay!)
        case "decimator": audio.selectedAudioInputs.append(audio.decimator!)
        case "tanhDistortion": audio.selectedAudioInputs.append(audio.tanhDistortion!)
        case "ringModulator": audio.selectedAudioInputs.append(audio.ringModulator!)
        
        // Filters
            
            
        default : print("NOTHING to do over HERE")
            
        }
    }
    
    func createInputListForSound() {
        
        for effect in 0..<audio.selectedEffectsData.count {
            let id = audio.selectedEffectsData[effect].id
            addToselectedEffects(id:id)
            }
         /*
        for effect in 0..<audio.selectedUnitsAfterData.count {
            let id = audio.selectedUnitsAfterData[effect].id
            addToselectedEffects(id:id)
        }
       
        for effect in 0..<audio.finalFiltersData.count {
            let id = audio.finalFiltersData[effect].id
            addToselectedEffects(id:id)
        }
         */
    }
    
    
    func connectMic() {
        
        
        mic?.connect(to: inputMixer!)
        
        // mieti tää
       // defaultAmp = Amp.model.defaultAmpModel(input: mic!)
        //defaultAmp?.connect(to: inputMixer!)
    }
    
    func connectFilters() {
        
        
    }
    
    func connectAudioInputs() {
        
        for input in 0..<audio.selectedAudioInputs.count {
            
            if input == 0 {
                inputMixer?.connect(to: audio.selectedAudioInputs[0])
                
            }
            else {
                audio.selectedAudioInputs[input-1].connect(to: audio.selectedAudioInputs[input])
            }
        }
        
        if audio.selectedAudioInputs.isEmpty {
            inputMixer!.connect(to: outputMixer!)
        } else {
            audio.selectedAudioInputs.last?.connect(to: outputMixer!)
        }
        
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
    
    
    func resetAudioEffects() {
        do {
            try AudioKit.stop()
        } catch {
            print("Could not stop AudioKit")
        }
        for input in 0..<audio.selectedAudioInputs.count {
            audio.selectedAudioInputs[input].disconnectOutput()
            audio.selectedAudioInputs[input].disconnectInput()
            print("DISCONNECT \(audio.selectedAudioInputs[input])")
        }
        inputMixer?.disconnectOutput()
        print("DISCONNECT \(String(describing: inputMixer))")
        mic?.disconnectOutput()
        print("DISCONNECT \(String(describing: mic))")
        audio.selectedAudioInputs.removeAll()
        startAudio()
    }
    
    /*
    func connectEffects() {
        
        
        // TODO:
        // Kokeile DryWeMixeriä joka väliin???
        // Splittaa ensin
       
        // CONNECT to input: If there are effects before main unit
        for pedal in 0..<firstList.count {
            
            if pedal == 0 {
                inputMixer?.connect(to: firstList[0])
                
            }
            else {
                firstList[pedal-1].connect(to: firstList[pedal])
            }
        }
        
        if firstList .isEmpty {
            inputMixer!.connect(to: mixerForFirstList!)
        } else {
            firstList.last?.connect(to: mixerForFirstList!)
        }
        
        
        
        // CONNECT to soundEffectsBefore: If there are units in the main unit
        for pedal in 0..<secondList.count {
            
            if pedal == 0 {
                mixerForFirstList?.connect(to: secondList[0])
                
            }
            else {
                secondList[pedal-1].connect(to: secondList[pedal])
            }
        }
        
        if secondList .isEmpty {
            mixerForFirstList!.connect(to: mixerForSecondList!)
        } else {
            secondList.last?.connect(to: mixerForSecondList!)
        }
        
        
        
        
        
        
        // CONNECT to mainUnits: If there are units in the soundEffectsAfter
        for pedal in 0..<thirdList.count {
            
            if pedal == 0 {
                mixerForSecondList?.connect(to: thirdList[0])
                
            }
            else {
                thirdList[pedal-1].connect(to: thirdList[pedal])
            }
        }
        
        if thirdList .isEmpty {
            mixerForSecondList!.connect(to: mixerForThirdList!)
        } else {
            thirdList.last?.connect(to: mixerForThirdList!)
        }
        
        
        
        // CONNECT to soundEffectsAfter: If there are units in the finishers
        for pedal in 0..<audioOut.count {
            
            if pedal == 0 {
                mixerForThirdList?.connect(to: audioOut[0])
                
            }
            else {
                audioOut[pedal-1].connect(to: audioOut[pedal])
            }
        }
        
        if audioOut .isEmpty {
            mixerForThirdList!.connect(to: outputMixer!)
        } else {
            audioOut.last?.connect(to: outputMixer!)
        }
        
        
        // CONNECT last  efefcts to the finalFilters
        for pedal in 0..<finalFilters.count {
            
            if pedal == 0 {
                outputMixer?.connect(to: finalFilters[0])
                
            }
            else {
                finalFilters[pedal-1].connect(to: finalFilters[pedal])
            }
        }
        
        if finalFilters .isEmpty {
            outputMixer!.connect(to: filterMixer!)
        } else {
            finalFilters.last?.connect(to: filterMixer!)
        }
        
        // LAST TO OUTPUT
        AudioKit.output = filterMixer
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
    
  */
    
    
    
    
    
    
    
    
    

    var defaultAmp: AKNode?
    
    
    var inputMixer: AKMixer?
    var mixerForFirstList: AKMixer?
    var mixerForSecondList: AKMixer?
    var mixerForThirdList: AKMixer?
    var outputMixer: AKMixer?
    
    
    
    var filterMixer: AKMixer?
    
    var mic: AKMicrophone?
    
    
    // EFFECTS
   
    // Dynamics
    static var compressor: AKCompressor?
    static var dynaRageCompressor: AKDynaRageCompressor?
    static var dynamicsProcessor: AKDynamicsProcessor?
    static var dynamicRangeCompressor: AKDynamicRangeCompressor?
    
    // Delay
    static var delay: AKDelay?
    static var variableDelay: AKVariableDelay?
    
    // Distorion effects
    static var decimator: AKDecimator?
    static var clipper: AKClipper?
    static var ringModulator: AKRingModulator?
    static var bitCrusher: AKBitCrusher?
    static var tanhDistortion: AKTanhDistortion?
    
    // Modulation effects
    static var flanger: AKFlanger?
    static var phaser: AKPhaser?
    static var chorus: AKChorus?
    
    // Reverb
    static var chowningReverb: AKChowningReverb?
    static var costelloReverb : AKCostelloReverb?
    static var flatFrequencyResponseReverb: AKFlatFrequencyResponseReverb?
    static var reverb: AKReverb?
    static var reverb2: AKReverb2?
   
  
    // Simulators
    static var rhinoGuitarProcessor: AKRhinoGuitarProcessor?
    
    // tremolo
    static var tremolo: AKTremolo?
    
    
    // FILTERS
     static var autoWah: AKAutoWah?
    
    
    static var equalizerFilter1: AKEqualizerFilter?
    static var equalizerFilter2: AKEqualizerFilter?
    static var equalizerFilter3: AKEqualizerFilter?
    static var equalizerFilter4: AKEqualizerFilter?
    static var equalizerFilter5: AKEqualizerFilter?
    static var equalizerFilter6: AKEqualizerFilter?
    static var equalizerFilter7: AKEqualizerFilter?
    static var equalizerFilter8: AKEqualizerFilter?
    static var equalizerFilter9: AKEqualizerFilter?
    static var equalizerFilter10: AKEqualizerFilter?
    static var equalizerFilter11: AKEqualizerFilter?
    static var equalizerFilter12: AKEqualizerFilter?
    
    static var highPassFilter : AKHighPassFilter?
    static var lowPassFilter: AKLowPassFilter?
    
    static var toneFilter: AKToneFilter?
    

    static var toneComplementFilter : AKToneComplementFilter?
    
    static var highShelfFilter : AKHighShelfFilter?
    static var lowShelfFilter: AKLowShelfFilter?
    
    static var bandPassButterworthFilter : AKBandPassButterworthFilter?
    static var bandRejectButterworthFilter : AKBandRejectButterworthFilter?
    static var lowPassButterworthFilter: AKLowPassButterworthFilter?
    static var highPassButterworthFilter: AKHighPassButterworthFilter?
    
    
    static var modalResonanceFilter : AKModalResonanceFilter?
    static var resonantFilter : AKResonantFilter?
    static var lowShelfParametricEqualizerFilter: AKLowShelfParametricEqualizerFilter?
    var highShelfParametricEqualizerFilter: AKHighShelfParametricEqualizerFilter?
    static var peakingParametricEqualizerFilter : AKPeakingParametricEqualizerFilter?
    
    static var formantFilter : AKFormantFilter?
    static var rolandTB303Filter : AKRolandTB303Filter?
    static var korgLowPassFilter : AKKorgLowPassFilter?
    static var threePoleLowpassFilter: AKThreePoleLowpassFilter?
    
    static var moogLadder: AKMoogLadder?
    
    static var combFilterReverb: AKCombFilterReverb?
    
    static var dcBlock: AKDCBlock?
    
    static var stringResonator : AKStringResonator?
    
    static var masterBooster: AKBooster?
    
    // ARRAYS FOR CONSTRUCTING THE SOUND
    
    static var selectedAudioInputs = [AKInput]()
    
    var audioIn = [AKInput]()
    var firstList = [AKInput]()
    var secondList = [AKInput]()
    var thirdList = [AKInput]()
    var audioOut = [AKInput]()
    
    var finalFilters = [AKInput]()
    
    
    func createEffects() {
        
        defaultAmp = AKNode()
        
        // UTILITIES
        mic = AKMicrophone()
        
        // MIXERS
        inputMixer = AKMixer()
        filterMixer = AKMixer()
        mixerForFirstList = AKMixer()
        mixerForSecondList = AKMixer()
        mixerForThirdList = AKMixer()
        outputMixer = AKMixer()
        
        mixerForSecondList?.start()
        inputMixer?.start()
        mixerForFirstList?.start()
        mixerForThirdList?.start()
        filterMixer?.start()
        outputMixer?.start()
        
        // EFFECTS
        // Delay
        audio.delay = AKDelay()
        audio.variableDelay = AKVariableDelay()
        
        // Dynamics
        audio.dynaRageCompressor =  AKDynaRageCompressor()
        audio.compressor = AKCompressor()
        audio.dynamicsProcessor = AKDynamicsProcessor()
        audio.dynamicRangeCompressor = AKDynamicRangeCompressor()
        
        // Distorion effects
        audio.bitCrusher =  AKBitCrusher()
        audio.clipper =  AKClipper()
        audio.tanhDistortion = AKTanhDistortion()
        audio.decimator = AKDecimator()
        audio.ringModulator = AKRingModulator()
        
        // Modulation effects
        audio.flanger = AKFlanger()
        audio.phaser = AKPhaser()
        audio.chorus = AKChorus()
        
        
        // Reverb
        audio.chowningReverb = AKChowningReverb()
        audio.costelloReverb = AKCostelloReverb()
        audio.flatFrequencyResponseReverb = AKFlatFrequencyResponseReverb()
        audio.reverb = AKReverb()
        audio.reverb2 = AKReverb2()
        
        // Simulators
        audio.rhinoGuitarProcessor = AKRhinoGuitarProcessor()
        
        // tremolo
        audio.tremolo = AKTremolo()
        
        // FILTERS
        audio.autoWah =  AKAutoWah()
        
        
        audio.equalizerFilter1 = AKEqualizerFilter()
        audio.equalizerFilter1?.bandwidth = 44.7
        audio.equalizerFilter1?.centerFrequency = 32
        audio.equalizerFilter1?.gain = Filters.equalizerFilter.filterBand1Gain
        
        audio.equalizerFilter2 = AKEqualizerFilter()
        audio.equalizerFilter2?.bandwidth = 70.8
        audio.equalizerFilter2?.centerFrequency = 64
        audio.equalizerFilter2?.gain = Filters.equalizerFilter.filterBand2Gain
        
        audio.equalizerFilter3 = AKEqualizerFilter()
        audio.equalizerFilter3?.bandwidth = 141
        audio.equalizerFilter3?.centerFrequency = 125
        audio.equalizerFilter3?.gain = Filters.equalizerFilter.filterBand3Gain
        
        audio.equalizerFilter4 = AKEqualizerFilter()
        audio.equalizerFilter4?.bandwidth = 282
        audio.equalizerFilter4?.centerFrequency = 250
        audio.equalizerFilter4?.gain = Filters.equalizerFilter.filterBand4Gain
        
        audio.equalizerFilter5 = AKEqualizerFilter()
        audio.equalizerFilter5?.bandwidth = 562
        audio.equalizerFilter5?.centerFrequency = 500
        audio.equalizerFilter5?.gain = Filters.equalizerFilter.filterBand5Gain
        
        audio.equalizerFilter6 = AKEqualizerFilter()
        audio.equalizerFilter6?.bandwidth = 1112
        audio.equalizerFilter6?.centerFrequency = 1000
        audio.equalizerFilter6?.gain = Filters.equalizerFilter.filterBand6Gain
        
        audio.equalizerFilter7 = AKEqualizerFilter()
        audio.equalizerFilter7?.bandwidth = 2222
        audio.equalizerFilter7?.centerFrequency = 2000
        audio.equalizerFilter7?.gain = Filters.equalizerFilter.filterBand7Gain
        
        audio.equalizerFilter8 = AKEqualizerFilter()
        audio.equalizerFilter8?.bandwidth = 4444
        audio.equalizerFilter8?.centerFrequency = 4000
        audio.equalizerFilter8?.gain = Filters.equalizerFilter.filterBand8Gain
        
        audio.equalizerFilter9 = AKEqualizerFilter()
        audio.equalizerFilter9?.bandwidth = 8888
        audio.equalizerFilter9?.centerFrequency = 8000
        audio.equalizerFilter9?.gain = Filters.equalizerFilter.filterBand9Gain
        
        audio.equalizerFilter10 = AKEqualizerFilter()
        audio.equalizerFilter10?.bandwidth = 17000
        audio.equalizerFilter10?.centerFrequency = 16000
        audio.equalizerFilter10?.gain = Filters.equalizerFilter.filterBand10Gain
        
    
        
        
        audio.highPassFilter = AKHighPassFilter()
        audio.lowPassFilter = AKLowPassFilter()
        
        audio.toneFilter = AKToneFilter()
        audio.toneFilter?.start()
        
        audio.masterBooster = AKBooster()
        audio.masterBooster?.start()
        
        
        
        
        audio.toneComplementFilter = AKToneComplementFilter()
        
        audio.highShelfFilter = AKHighShelfFilter()
        audio.lowShelfFilter = AKLowShelfFilter()
        
        audio.bandPassButterworthFilter = AKBandPassButterworthFilter()
        audio.bandRejectButterworthFilter = AKBandRejectButterworthFilter()
        audio.lowPassButterworthFilter = AKLowPassButterworthFilter()
        audio.highPassButterworthFilter = AKHighPassButterworthFilter()
        
        audio.modalResonanceFilter = AKModalResonanceFilter()
        audio.resonantFilter = AKResonantFilter()
        audio.peakingParametricEqualizerFilter = AKPeakingParametricEqualizerFilter()
        audio.lowShelfParametricEqualizerFilter = AKLowShelfParametricEqualizerFilter()
        highShelfParametricEqualizerFilter = AKHighShelfParametricEqualizerFilter()
        
        audio.formantFilter = AKFormantFilter()
        audio.rolandTB303Filter = AKRolandTB303Filter()
        audio.korgLowPassFilter = AKKorgLowPassFilter()
        audio.threePoleLowpassFilter = AKThreePoleLowpassFilter()
        
        audio.moogLadder = AKMoogLadder()
        
        
        audio.dcBlock = AKDCBlock()
        audio.stringResonator = AKStringResonator()
        audio.combFilterReverb = AKCombFilterReverb()
        
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
