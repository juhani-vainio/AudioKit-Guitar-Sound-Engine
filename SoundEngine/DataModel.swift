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
    var id = Int()              // effect ID
    var opened = Bool()         // for epanding tableviewcells
    var title = String()        // name of effect for users
    var interface = String()    // type of interface for cell
}


class audio {
    static let effect = audio()
    //var availableUnitsData = [effectData]()        // VÄLIAIKAINEN MALLI
    
    static var availableUnitsData = [
        effectData(id: 1, opened: false, title: "Bit Crusher", interface: "double"),
        effectData(id: 2, opened: false, title: "Tanh Distortion", interface: "quatro"),
        effectData(id: 3, opened: false, title: "Compressor", interface: "quatro")
        ]
    
    func changeValues(id: Int, slider: Int, value: Double) -> String {
        var newValue = String()
        switch id {
        case 1 :
            switch slider {
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
            
        case 2 :
            switch slider {
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
            
        case 3 :
            switch slider {
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
            
        case 4 :
            switch slider {
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
            
        case 5 :
            switch slider {
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
            
        case 6 :
            switch slider {
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
            
        case 7 :
            switch slider {
            case 1:
            clipper?.limit = value
            Effects.clipper.limit = value
            let text = String(value)
            newValue = String(text.prefix(3))
            default: break
                
            }
        case 8 :
            switch slider {
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
    
    func getValues(id: Int, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String, name : String, isOn: Bool) {
        var min = Float(0.0)
        var max = Float(1.0)
        var valueForSlider = Float(0.69)
        var name = ""
        var value = ""
        var isOn = Bool()
        switch id {
        case 1 :
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
            
        case 2 :
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
          
        case 3 :
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
           
        case 4 :
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
            
        case 5 :
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
          
        case 6 :
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
          
        case 7 :
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
         
        case 8 :
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
    
    var defaultAmp: AKNode?
    
    var masterMixer: AKMixer?
    var inputMixer: AKMixer?
    var effectsMixer: AKMixer?
    var filterMixer: AKMixer?
    
    // TRACKERS
    var mic: AKMicrophone?
    var tracker: AKFrequencyTracker!
    var amplitudeTracker: AKAmplitudeTracker!
    
    
    // EFFECTS
    var bitCrusher: AKBitCrusher?                   // 1
    var decimator: AKDecimator?                     // 2
    var delay: AKDelay?                             // 3
    
    var dynaRageCompressor: AKDynaRageCompressor?   // 4
    var autoWah: AKAutoWah?                         // 5
    var tanhDistortion: AKTanhDistortion?           // 6
    var clipper: AKClipper?                         // 7
    
    var ringModulator: AKRingModulator?
    var distortion: AKDistortion?
    
    // FILTERS
    var equalizerFilter1: AKEqualizerFilter?
    var equalizerFilter2: AKEqualizerFilter?
    var equalizerFilter3: AKEqualizerFilter?
    var equalizerFilter4: AKEqualizerFilter?
    var equalizerFilter5: AKEqualizerFilter?
    var equalizerFilter6: AKEqualizerFilter?
    
    var highPassFilter : AKHighPassFilter?
    var lowPassFilter: AKLowPassFilter?
    
    var toneFilter: AKToneFilter?
    var masterBooster: AKBooster?
    
    // EFFECT ARRAYS
    var effect = [AKInput]()
    var effectCellName = [String]()

}

