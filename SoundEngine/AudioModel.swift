//
//  DataModel.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 26/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//
/*
Frequency Range    Frequency Values
Sub-bass    20 to 60 Hz
Bass    60 to 250 Hz
Low midrange    250 to 500 Hz
Midrange    500 Hz to 2 kHz
Upper midrange    2 to 4 kHz
Presence    4 to 6 kHz
Brilliance    6 to 20 kHz
*/


import Foundation
import AudioKit
import AudioKitUI


struct effectData {
 
    var id = String()           // effect ID
    var opened = Bool()         // for expanding tableviewcells
    var title = String()        // name of effect for users
    var type = String()         // type of element to get location and type of interface for cell
}

struct eqData {
    var id = String()           // effect ID
    var title = String()        // name of effect for users
    var type = String()
}

class audio {
    static let shared = audio()
    
    static var bufferLength = Int()
    
   static let allPossibleEffectsData = [
    // DISTORTIONS
    effectData(id: "clipper",opened: false, title: "Clipper", type: "1"),
    effectData(id: "bitCrusher", opened: false, title: "Bit Crusher", type: "2"),
    effectData(id: "decimator" ,opened: false, title: "Decimator", type: "3"),
    effectData(id: "tanhDistortion", opened: false, title: "Tanh Distortion", type: "4"),
    effectData(id: "ringModulator", opened: false, title: "Ring Modulator", type: "4"),
    
    // WAH
    effectData(id: "autoWah" , opened: false, title: "Wah Wah!", type: "3"),
    
    // DYNAMICS
    effectData(id: "dynamicRangeCompressor" ,opened: false, title: "Dynamic Range Compressor", type: "4"),
    effectData(id: "dynaRageCompressor", opened: false, title: "Dyna Rage Compressor", type: "5"),
    effectData(id: "compressor" ,opened: false, title: "Compressor", type: "6"),
    effectData(id: "dynamicsProcessor" ,opened: false, title: "Dynamics Processor", type: "8"),
    
  
    effectData(id: "chowningReverb" ,opened: false, title: "Chowning Reverb", type: "0"),
    effectData(id: "flatFrequencyResponseReverb" ,opened: false, title: "Flat Freq Response Reverb", type: "1"),
    effectData(id: "reverb" ,opened: false, title: "Reverb", type: "1"),
    effectData(id: "variableDelay", opened: false, title: "Variable Delay", type: "2"),
    effectData(id: "costelloReverb" ,opened: false, title: "Costello Reverb", type: "2"),
    effectData(id: "tremolo" ,opened: false, title: "Tremolo", type: "2"),
    effectData(id: "delay", opened: false, title: "Delay", type: "4"),
    effectData(id: "flanger" ,opened: false, title: "Flanger", type: "4"),
    effectData(id: "chorus" ,opened: false, title: "Chorus", type: "4"),
    effectData(id: "reverb2" ,opened: false, title: "Reverb 2", type: "7"),
    effectData(id: "phaser" ,opened: false, title: "Phaser", type: "8")
    
    ]
    
    
    static let allPossibleFiltersData = [
        // EQUALIZER either 3 or 7 BAND
        // https://www.teachmeaudio.com/mixing/techniques/audio-spectrum/
        effectData(id: "Equalizer", opened: false, title: "Equalizer", type: "Equalizer"), // Bass , Mid, High
        //effectData(id: "sevenBandFilter", opened: false, title: "7 Band", type: "Equalizer"), // Sub-Bass, Bass, Low Mid, Mid, Upper Mid, Precence, Brilliance
        
        // CUT    " highPassFilter & lowPassFilter  either normal or highPassButterworthFilter & lowPassButterworthFilter"
        effectData(id: "highLowPassFilters", opened: false, title: "Cut off", type: "PassFilters"), // add switch for FLAT as in butterworth for the pass filters
        
        // TONE   " toneFilter & toneComplementFilter "
        effectData(id: "toneFilters", opened: false, title: "Tone", type: "1"),
        effectData(id: "dcBlock", opened: false, title: "DC Block", type: "0"), // Switch
        
        
        
        // These similar tables as in effects
        effectData(id: "moogLadder", opened: false, title: "Moog Ladder", type: "2"),
        effectData(id: "resonantFilter", opened: false, title: "Resonant", type: "2"),
        effectData(id: "stringResonator", opened: false, title: "String Resonator", type: "2"),
        effectData(id: "modalResonanceFilter", opened: false, title: "Modal Resonance", type: "2"),
        
        effectData(id: "combFilterReverb", opened: false, title: "Comb Reverb", type: "2")
    ]
    

    
    static var availableEffectsData = [effectData]()
    
    static var selectedEffectsData = [effectData]()
    
    static var availableFiltersData = [effectData]()
    
    static var selectedFiltersData = [effectData]()
    
    func toggleEQ(id: String) {
        switch id {
        case "threeBandFilter":
            audio.threeBandFilterHigh?.start()
            audio.threeBandFilterMid?.start()
            audio.threeBandFilterLow?.start()
            audio.sevenBandFilterBrilliance?.stop()
            audio.sevenBandFilterPrecence?.stop()
            audio.sevenBandFilterUpperMid?.stop()
            audio.sevenBandFilterMid?.stop()
            audio.sevenBandFilterLowMid?.stop()
            audio.sevenBandFilterBass?.stop()
            audio.sevenBandFilterSubBass?.stop()
            
        case "sevenBandFilter":
            audio.sevenBandFilterBrilliance?.start()
            audio.sevenBandFilterPrecence?.start()
            audio.sevenBandFilterUpperMid?.start()
            audio.sevenBandFilterMid?.start()
            audio.sevenBandFilterLowMid?.start()
            audio.sevenBandFilterBass?.start()
            audio.sevenBandFilterSubBass?.start()
            audio.threeBandFilterHigh?.stop()
            audio.threeBandFilterMid?.stop()
            audio.threeBandFilterLow?.stop()
        default:
            audio.threeBandFilterHigh?.start()
            audio.threeBandFilterMid?.start()
            audio.threeBandFilterLow?.start()
            audio.sevenBandFilterBrilliance?.stop()
            audio.sevenBandFilterPrecence?.stop()
            audio.sevenBandFilterUpperMid?.stop()
            audio.sevenBandFilterMid?.stop()
            audio.sevenBandFilterLowMid?.stop()
            audio.sevenBandFilterBass?.stop()
            audio.sevenBandFilterSubBass?.stop()
        }
    }
    
    func toggleOnOff(id: String, isOn: Bool) {
        switch id {
        case "dynaRageCompressor":
            if isOn == true {
                audio.dynaRageCompressor?.rageIsOn = true
            } else {
                audio.dynaRageCompressor?.rageIsOn = false
                
            }
            print("audio.dynaRageCompressor?.rageIsOn \(audio.dynaRageCompressor?.rageIsOn)")
        case "phaser":
            if isOn == true { audio.phaser?.inverted = 1 } else { audio.phaser?.inverted = 0 }
            print("audio.phaser?.inverted \(audio.phaser?.inverted)")
        case "eq10":
            if isOn == true {
                audio.equalizerFilter3?.start()
                audio.equalizerFilter6?.start()
                audio.equalizerFilter9?.start()
                audio.equalizerFilter12?.start()
                audio.equalizerFilter15?.start()
                audio.equalizerFilter18?.start()
                audio.equalizerFilter21?.start()
                audio.equalizerFilter24?.start()
                audio.equalizerFilter27?.start()
                audio.equalizerFilter30?.start()
            } else {
                audio.equalizerFilter3?.stop()
                audio.equalizerFilter6?.stop()
                audio.equalizerFilter9?.stop()
                audio.equalizerFilter12?.stop()
                audio.equalizerFilter15?.stop()
                audio.equalizerFilter18?.stop()
                audio.equalizerFilter21?.stop()
                audio.equalizerFilter24?.stop()
                audio.equalizerFilter27?.stop()
                audio.equalizerFilter30?.stop()
            }
        case "eq31":
            if isOn == true {
                audio.equalizerFilter1?.start()
                audio.equalizerFilter2?.start()
                audio.equalizerFilter3?.start()
                audio.equalizerFilter4?.start()
                audio.equalizerFilter5?.start()
                audio.equalizerFilter6?.start()
                audio.equalizerFilter7?.start()
                audio.equalizerFilter8?.start()
                audio.equalizerFilter9?.start()
                audio.equalizerFilter10?.start()
                
                audio.equalizerFilter11?.start()
                audio.equalizerFilter12?.start()
                audio.equalizerFilter13?.start()
                audio.equalizerFilter14?.start()
                audio.equalizerFilter15?.start()
                audio.equalizerFilter16?.start()
                audio.equalizerFilter17?.start()
                audio.equalizerFilter18?.start()
                audio.equalizerFilter19?.start()
                audio.equalizerFilter20?.start()
                
                audio.equalizerFilter21?.start()
                audio.equalizerFilter22?.start()
                audio.equalizerFilter23?.start()
                audio.equalizerFilter24?.start()
                audio.equalizerFilter25?.start()
                audio.equalizerFilter26?.start()
                audio.equalizerFilter27?.start()
                audio.equalizerFilter28?.start()
                audio.equalizerFilter29?.start()
                audio.equalizerFilter30?.start()
                audio.equalizerFilter31?.start()
            } else {
                audio.equalizerFilter1?.stop()
                audio.equalizerFilter2?.stop()
                audio.equalizerFilter3?.stop()
                audio.equalizerFilter4?.stop()
                audio.equalizerFilter5?.stop()
                audio.equalizerFilter6?.stop()
                audio.equalizerFilter7?.stop()
                audio.equalizerFilter8?.stop()
                audio.equalizerFilter9?.stop()
                audio.equalizerFilter10?.stop()
                
                audio.equalizerFilter11?.stop()
                audio.equalizerFilter12?.stop()
                audio.equalizerFilter13?.stop()
                audio.equalizerFilter14?.stop()
                audio.equalizerFilter15?.stop()
                audio.equalizerFilter16?.stop()
                audio.equalizerFilter17?.stop()
                audio.equalizerFilter18?.stop()
                audio.equalizerFilter19?.stop()
                audio.equalizerFilter20?.stop()
                
                audio.equalizerFilter21?.stop()
                audio.equalizerFilter22?.stop()
                audio.equalizerFilter23?.stop()
                audio.equalizerFilter24?.stop()
                audio.equalizerFilter25?.stop()
                audio.equalizerFilter26?.stop()
                audio.equalizerFilter27?.stop()
                audio.equalizerFilter28?.stop()
                audio.equalizerFilter29?.stop()
                audio.equalizerFilter30?.stop()
                audio.equalizerFilter31?.stop()
            }
        default:
            break
        }
    }
    
    func convertWithBooster(gain: Double) -> Float {
        let booster = AKBooster()
        booster.gain = gain
        return Float(booster.dB)
    }
    
    func changeEQValues(slider: String, value: Double) -> String {
        var newValue = String()
       
            switch slider {
                
            case "threeBandHighSlider":
                audio.threeBandFilterHigh?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "threeBandMidSlider":
                audio.threeBandFilterMid?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "threeBandLowSlider":
                audio.threeBandFilterLow?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            case "sevenBandBrillianceSlider":
                audio.sevenBandFilterBrilliance?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandPrecenceSlider":
                audio.sevenBandFilterPrecence?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandUpperMidSlider":
                audio.sevenBandFilterUpperMid?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandMidSlider":
                audio.sevenBandFilterMid?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandLowMidSlider":
                audio.sevenBandFilterLowMid?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandBassSlider":
                audio.sevenBandFilterBass?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case "sevenBandSubBassSlider":
                audio.sevenBandFilterSubBass?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
          
                
            default: break
                
            }
        return newValue
    }
    
    func getEQ(id: String, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String) {
        let min = 0.1
        let max = 3
        var valueForSlider = Float(0.69)
        var value = ""
        switch id {
            case "threeBandFilter":
                
            switch slider {
            case 1:
                valueForSlider = Float(audio.threeBandFilterHigh!.gain)
                value = String(audio.threeBandFilterHigh!.gain)
                value = String(value.prefix(3))
  
            case 2:
                valueForSlider = Float(audio.threeBandFilterMid!.gain)
                value = String(audio.threeBandFilterMid!.gain)
                value = String(value.prefix(3))
            case 3:
                valueForSlider = Float(audio.threeBandFilterLow!.gain)
                value = String(audio.threeBandFilterLow!.gain)
                value = String(value.prefix(3))
            default: break
            }
        case "sevenBandFilter":
            
            switch slider {
            case 1:
                valueForSlider = Float(audio.sevenBandFilterBrilliance!.gain)
                value = String(audio.sevenBandFilterBrilliance!.gain)
                value = String(value.prefix(3))
                
            case 2:
                valueForSlider = Float(audio.sevenBandFilterPrecence!.gain)
                value = String(audio.sevenBandFilterPrecence!.gain)
                value = String(value.prefix(3))
            case 3:
                valueForSlider = Float(audio.sevenBandFilterUpperMid!.gain)
                value = String(audio.sevenBandFilterUpperMid!.gain)
                value = String(value.prefix(3))
            case 4:
                valueForSlider = Float(audio.sevenBandFilterMid!.gain)
                value = String(audio.sevenBandFilterMid!.gain)
                value = String(value.prefix(3))
                
            case 5:
                valueForSlider = Float(audio.sevenBandFilterLowMid!.gain)
                value = String(audio.sevenBandFilterLowMid!.gain)
                value = String(value.prefix(3))
            case 6:
                valueForSlider = Float(audio.sevenBandFilterBass!.gain)
                value = String(audio.sevenBandFilterBass!.gain)
                value = String(value.prefix(3))
            case 7:
                valueForSlider = Float(audio.sevenBandFilterSubBass!.gain)
                value = String(audio.sevenBandFilterSubBass!.gain)
                value = String(value.prefix(3))
            default: break
            }
            
        default: break
        }
        
        return (Float(min), Float(max), valueForSlider, value)
    }
 
    func getEQValues(id: String, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String, name : String) {
        let min = -6
        let max = 6
        var valueForSlider = Float(0.69)
        var name = ""
        var value = ""
        switch id {
        case "eq10":
            
            switch slider {
            case 1:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter3!.gain)
                name = String(audio.equalizerFilter3!.centerFrequency)
            case 2:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter6!.gain)
                name = String(audio.equalizerFilter6!.centerFrequency)
            case 3:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter9!.gain)
                name = String(audio.equalizerFilter9!.centerFrequency)
            case 4:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter12!.gain)
                name = String(audio.equalizerFilter12!.centerFrequency)
            case 5:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter15!.gain)
                name = String(audio.equalizerFilter15!.centerFrequency)
            case 6:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter18!.gain)
                name = String(audio.equalizerFilter18!.centerFrequency)
            case 7:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter21!.gain)
                name = String(audio.equalizerFilter21!.centerFrequency)
            case 8:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter24!.gain)
                name = String(audio.equalizerFilter24!.centerFrequency)
            case 9:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter27!.gain)
                name = String(audio.equalizerFilter27!.centerFrequency)
            case 10:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter30!.gain)
                name = String(audio.equalizerFilter30!.centerFrequency)
                
            default: break
            }
            
        case "eq31":
            
            switch slider {
            case 1:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter1!.gain)
                name = String(audio.equalizerFilter1!.centerFrequency)
            case 2:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter2!.gain)
                name = String(audio.equalizerFilter2!.centerFrequency)
            case 3:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter3!.gain)
                name = String(audio.equalizerFilter3!.centerFrequency)
            case 4:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter4!.gain)
                name = String(audio.equalizerFilter4!.centerFrequency)
            case 5:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter5!.gain)
                name = String(audio.equalizerFilter5!.centerFrequency)
            case 6:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter6!.gain)
                name = String(audio.equalizerFilter6!.centerFrequency)
            case 7:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter7!.gain)
                name = String(audio.equalizerFilter7!.centerFrequency)
            case 8:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter8!.gain)
                name = String(audio.equalizerFilter8!.centerFrequency)
            case 9:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter9!.gain)
                name = String(audio.equalizerFilter9!.centerFrequency)
            case 10:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter10!.gain)
                name = String(audio.equalizerFilter10!.centerFrequency)
            case 11:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter11!.gain)
                name = String(audio.equalizerFilter11!.centerFrequency)
            case 12:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter12!.gain)
                name = String(audio.equalizerFilter12!.centerFrequency)
            case 13:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter13!.gain)
                name = String(audio.equalizerFilter13!.centerFrequency)
            case 14:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter14!.gain)
                name = String(audio.equalizerFilter14!.centerFrequency)
            case 15:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter15!.gain)
                name = String(audio.equalizerFilter15!.centerFrequency)
            case 16:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter16!.gain)
                name = String(audio.equalizerFilter16!.centerFrequency)
            case 17:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter17!.gain)
                name = String(audio.equalizerFilter17!.centerFrequency)
            case 18:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter18!.gain)
                name = String(audio.equalizerFilter18!.centerFrequency)
            case 19:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter19!.gain)
                name = String(audio.equalizerFilter19!.centerFrequency)
            case 20:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter20!.gain)
                name = String(audio.equalizerFilter20!.centerFrequency)
            case 21:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter21!.gain)
                name = String(audio.equalizerFilter21!.centerFrequency)
            case 22:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter22!.gain)
                name = String(audio.equalizerFilter22!.centerFrequency)
            case 23:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter23!.gain)
                name = String(audio.equalizerFilter23!.centerFrequency)
            case 24:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter24!.gain)
                name = String(audio.equalizerFilter24!.centerFrequency)
            case 25:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter25!.gain)
                name = String(audio.equalizerFilter25!.centerFrequency)
            case 26:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter26!.gain)
                name = String(audio.equalizerFilter26!.centerFrequency)
            case 27:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter27!.gain)
                name = String(audio.equalizerFilter27!.centerFrequency)
            case 28:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter28!.gain)
                name = String(audio.equalizerFilter28!.centerFrequency)
            case 29:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter29!.gain)
                name = String(audio.equalizerFilter29!.centerFrequency)
            case 30:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter30!.gain)
                name = String(audio.equalizerFilter30!.centerFrequency)
            case 31:
                valueForSlider = convertWithBooster(gain: audio.equalizerFilter31!.gain)
                name = String(audio.equalizerFilter31!.centerFrequency)
                
                
            default: break
            }
        
        
        default:
            break
        }
        
        
        var text = String(valueForSlider)
        text = String(text.prefix(4))
        value = text + "dB"
        
        return (Float(min), Float(max), valueForSlider, value, name)
    }
    
    func convertSliderValue(oldValue:Double) -> Double{
    let oldMax = 1
        let oldMin = 0
        let newMax = 2
        let newMin = 0.5
    let oldRange = (oldMax - oldMin)
    let newRange = (newMax - newMin)
    let newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin
        return newValue
    }
    
    func changeValues(id: String, slider: Int, value: Double) -> String {
        var newValue = String()
        switch id {
            /*
        case "threeBandFilter":
            switch slider {
            
            case 1:
                audio.threeBandFilterHigh?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.threeBandFilterMid?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.threeBandFilterLow?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            */
            
        case "toneFilters":
            switch slider {
            case 0:
                if  audio.toneFilter!.isStarted == true {
                    audio.toneFilter?.stop()
                    audio.toneComplementFilter?.stop()
                    newValue = "OFF"
                } else {
                    audio.toneFilter?.start()
                    audio.toneComplementFilter?.start()
                    newValue = "ON"
                }
            case 1:
                audio.toneFilter?.halfPowerPoint = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.toneComplementFilter?.halfPowerPoint = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "moogLadder":
            switch slider {
            case 0:
                if  audio.moogLadder!.isStarted == true {
                    audio.moogLadder?.stop()
                   
                    newValue = "OFF"
                } else {
                    audio.moogLadder?.start()
      
                    newValue = "ON"
                }
            case 1:
                audio.moogLadder?.cutoffFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.moogLadder?.resonance = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
            
        
       // case "sevenBandFilter":
/*
        case "highLowPassFilters":
        
        case "resonantFilter":
        case "stringResonator":
        case "modalResonanceFilter":
        case "dcBlock":
        case "combFilterReverb":
         */
  
            
        case "eq10" :
            let booster = AKBooster()
            booster.dB = value
            let text = String(value)
            newValue = String(text.prefix(4)) + "dB"
            switch slider {
           
            case 1:
               
                audio.equalizerFilter3?.gain = booster.gain
                
            case 2:
                audio.equalizerFilter6?.gain = booster.gain
               
            case 3:
                audio.equalizerFilter9?.gain = booster.gain
               
            case 4:
                audio.equalizerFilter12?.gain = booster.gain
              
            case 5:
                audio.equalizerFilter15?.gain = booster.gain
          
            case 6:
                audio.equalizerFilter18?.gain = booster.gain
              
            case 7:
                audio.equalizerFilter21?.gain = booster.gain
          
            case 8:
                audio.equalizerFilter24?.gain = booster.gain
               
            case 9:
                audio.equalizerFilter27?.gain = booster.gain
          
            case 10:
                audio.equalizerFilter30?.gain = booster.gain
              
                
            default: break
                
            }
            
        case "eq31" :
            let booster = AKBooster()
            booster.dB = value
            let text = String(value)
            newValue = String(text.prefix(4)) + "dB"
            switch slider {
                
            case 1:
                
                audio.equalizerFilter1?.gain = booster.gain
                
            case 2:
                audio.equalizerFilter2?.gain = booster.gain
                
            case 3:
                audio.equalizerFilter3?.gain = booster.gain
                
            case 4:
                audio.equalizerFilter4?.gain = booster.gain
                
            case 5:
                audio.equalizerFilter5?.gain = booster.gain
                
            case 6:
                audio.equalizerFilter6?.gain = booster.gain
                
            case 7:
                audio.equalizerFilter7?.gain = booster.gain
                
            case 8:
                audio.equalizerFilter8?.gain = booster.gain
                
            case 9:
                audio.equalizerFilter9?.gain = booster.gain
                
            case 10:
                audio.equalizerFilter10?.gain = booster.gain
                
            case 11:
                
                audio.equalizerFilter11?.gain = booster.gain
                
            case 12:
                audio.equalizerFilter12?.gain = booster.gain
                
            case 13:
                audio.equalizerFilter13?.gain = booster.gain
                
            case 14:
                audio.equalizerFilter14?.gain = booster.gain
                
            case 15:
                audio.equalizerFilter15?.gain = booster.gain
                
            case 16:
                audio.equalizerFilter16?.gain = booster.gain
                
            case 17:
                audio.equalizerFilter17?.gain = booster.gain
                
            case 18:
                audio.equalizerFilter18?.gain = booster.gain
                
            case 19:
                audio.equalizerFilter19?.gain = booster.gain
                
            case 20:
                audio.equalizerFilter20?.gain = booster.gain
                
            case 21:
                
                audio.equalizerFilter21?.gain = booster.gain
                
            case 22:
                audio.equalizerFilter22?.gain = booster.gain
                
            case 23:
                audio.equalizerFilter23?.gain = booster.gain
                
            case 24:
                audio.equalizerFilter24?.gain = booster.gain
                
            case 25:
                audio.equalizerFilter25?.gain = booster.gain
                
            case 26:
                audio.equalizerFilter26?.gain = booster.gain
                
            case 27:
                audio.equalizerFilter27?.gain = booster.gain
                
            case 28:
                audio.equalizerFilter28?.gain = booster.gain
                
            case 29:
                audio.equalizerFilter29?.gain = booster.gain
                
            case 30:
                audio.equalizerFilter30?.gain = booster.gain
                
            case 31:
                audio.equalizerFilter31?.gain = booster.gain
                
                
            default: break
                
            }
            
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
            case 5:
                audio.dynaRageCompressor?.rage = value
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
                audio.delay?.lowPassCutoff = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.delay?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "variableDelay" :
            switch slider {
            case 0:
                if  audio.variableDelay!.isStarted == true {
                    audio.variableDelay?.stop()
                    newValue = "OFF"
                } else {
                    audio.variableDelay?.start()
                    newValue = "ON"
                }
            case 1:
                audio.variableDelay?.time = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.variableDelay?.feedback = value
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
            
        case "flanger" :
            switch slider {
            case 0:
                if  audio.flanger!.isStarted == true {
                    audio.flanger?.stop()
                    newValue = "OFF"
                } else {
                    audio.flanger?.start()
                    newValue = "ON"
                }
            case 1:
                audio.flanger?.frequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.flanger?.depth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.flanger?.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.flanger?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
            
        case "phaser" :
            switch slider {
            case 0:
                if  audio.phaser!.isStarted == true {
                    audio.phaser?.stop()
                    newValue = "OFF"
                } else {
                    audio.phaser?.start()
                    newValue = "ON"
                }
            case 1:
                audio.phaser?.notchMinimumFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.phaser?.notchMaximumFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.phaser?.notchWidth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.phaser?.notchFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 5:
                audio.phaser?.vibratoMode = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 6:
                audio.phaser?.depth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 7:
                audio.phaser?.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 8:
                audio.phaser?.lfoBPM = value
                let text = String(value)
                newValue = String(text.prefix(3))
            default: break
                
            }
        case "chorus" :
            switch slider {
            case 0:
                if  audio.chorus!.isStarted == true {
                    audio.chorus?.stop()
                    newValue = "OFF"
                } else {
                    audio.chorus?.start()
                    newValue = "ON"
                }
            case 1:
                audio.chorus?.frequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.chorus?.depth = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.chorus?.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.chorus?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "compressor" :
            switch slider {
            case 0:
                if  audio.compressor!.isStarted == true {
                    audio.compressor?.stop()
                    newValue = "OFF"
                } else {
                    audio.compressor?.start()
                    newValue = "ON"
                }
            case 1:
                audio.compressor?.threshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.compressor?.headRoom = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.compressor?.attackDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.compressor?.releaseDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 5:
                audio.compressor?.masterGain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 6:
                audio.compressor?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "dynamicsProcessor" :
            switch slider {
            case 0:
                if  audio.dynamicsProcessor!.isStarted == true {
                    audio.dynamicsProcessor?.stop()
                    newValue = "OFF"
                } else {
                    audio.dynamicsProcessor?.start()
                    newValue = "ON"
                }
            case 1:
                audio.dynamicsProcessor?.threshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.dynamicsProcessor?.headRoom = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.dynamicsProcessor?.expansionRatio = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.dynamicsProcessor?.expansionThreshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 5:
                audio.dynamicsProcessor?.attackDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 6:
                audio.dynamicsProcessor?.releaseDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 7:
                audio.dynamicsProcessor?.masterGain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            case 8:
                audio.dynamicsProcessor?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
        case "dynamicRangeCompressor" :
            switch slider {
            case 0:
                if  audio.dynamicRangeCompressor!.isStarted == true {
                    audio.dynamicRangeCompressor?.stop()
                    newValue = "OFF"
                } else {
                    audio.dynamicRangeCompressor?.start()
                    newValue = "ON"
                }
            case 1:
                audio.dynamicRangeCompressor?.ratio = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.dynamicRangeCompressor?.threshold = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.dynamicRangeCompressor?.attackDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.dynamicRangeCompressor?.releaseDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
        case "reverb" :
            switch slider {
            case 0:
                if  audio.reverb!.isStarted == true {
                    audio.reverb?.stop()
                    newValue = "OFF"
                } else {
                    audio.reverb?.start()
                    newValue = "ON"
                }
            case 1:
                audio.reverb?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
            default: break
                
            }
            
        case "reverb2" :
            switch slider {
            case 0:
                if  audio.reverb2!.isStarted == true {
                    audio.reverb2?.stop()
                    newValue = "OFF"
                } else {
                    audio.reverb2?.start()
                    newValue = "ON"
                }
            case 1:
                audio.reverb2?.gain = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.reverb2?.minDelayTime = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 3:
                audio.reverb2?.maxDelayTime = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 4:
                audio.reverb2?.decayTimeAt0Hz = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 5:
                audio.reverb2?.decayTimeAtNyquist = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 6:
                audio.reverb2?.randomizeReflections = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 7:
                audio.reverb2?.dryWetMix = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
            
        case "costelloReverb" :
            switch slider {
            case 0:
                if  audio.costelloReverb!.isStarted == true {
                    audio.costelloReverb?.stop()
                    newValue = "OFF"
                } else {
                    audio.costelloReverb?.start()
                    newValue = "ON"
                }
            case 1:
                audio.costelloReverb?.cutoffFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.costelloReverb?.feedback = value
                let text = String(value)
                newValue = String(text.prefix(3))
            
                
            default: break
                
            }
        case "flatFrequencyResponseReverb" :
            switch slider {
            case 0:
                if  audio.flatFrequencyResponseReverb!.isStarted == true {
                    audio.flatFrequencyResponseReverb?.stop()
                    newValue = "OFF"
                } else {
                    audio.flatFrequencyResponseReverb?.start()
                    newValue = "ON"
                }
            case 1:
                audio.flatFrequencyResponseReverb?.reverbDuration = value
                let text = String(value)
                newValue = String(text.prefix(3))
           
            default: break
                
            }
            
        case "tremolo" :
            switch slider {
            case 0:
                if  audio.tremolo!.isStarted == true {
                    audio.tremolo?.stop()
                    newValue = "OFF"
                } else {
                    audio.tremolo?.start()
                    newValue = "ON"
                }
            case 1:
                audio.tremolo?.frequency = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 2:
                audio.tremolo?.depth = value
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
        /*
        case "threeBandFilter":
            switch slider {
            case 1:
                min = 0.1
                max = 3
                valueForSlider = Float(audio.threeBandFilterHigh!.gain)
                name = "Treble"
                value = String(audio.threeBandFilterHigh!.gain)
                value = String(value.prefix(3))
                isOn = audio.threeBandFilterHigh!.isStarted
            case 2:
                min = 0.1
                max = 3
                valueForSlider = Float(audio.threeBandFilterMid!.gain)
                name = "Mid"
                value = String(audio.threeBandFilterMid!.gain)
                value = String(value.prefix(3))
                isOn = audio.threeBandFilterMid!.isStarted
            case 3:
                min = 0.1
                max = 3
                valueForSlider = Float(audio.threeBandFilterLow!.gain)
                name = "Bass"
                value = String(audio.threeBandFilterLow!.gain)
                value = String(value.prefix(3))
                isOn = audio.threeBandFilterLow!.isStarted
            default: break
            }
 */
            
        case "toneFilters":
            switch slider {
            case 1:
                min = 40
                max = 5000
                valueForSlider = Float(audio.toneFilter!.halfPowerPoint)
                name = "Tone"
                value = String(audio.toneFilter!.halfPowerPoint)
                value = String(value.prefix(3))
                isOn = audio.toneFilter!.isStarted
            case 2:
                min = 20
                max = 4000
                valueForSlider = Float(audio.toneComplementFilter!.halfPowerPoint)
                name = "Tone Complement"
                value = String(audio.toneComplementFilter!.halfPowerPoint)
                value = String(value.prefix(3))
                isOn = audio.toneComplementFilter!.isStarted
            
            default: break
            }
            
        case "moogLadder":
            switch slider {
            case 1:
                min = 40
                max = 5000
                valueForSlider = Float(audio.moogLadder!.cutoffFrequency)
                name = "Cut off"
                value = String(audio.moogLadder!.cutoffFrequency)
                value = String(value.prefix(3))
                isOn = audio.moogLadder!.isStarted
            case 2:
                min = 0
                max = 1
                valueForSlider = Float(audio.moogLadder!.resonance)
                name = "Resonance"
                value = String(audio.moogLadder!.resonance)
                value = String(value.prefix(3))
                isOn = audio.moogLadder!.isStarted
                
            default: break
            }
        
       // case "sevenBandFilter":
     /*
        case "highLowPassFilters":
 
        case "resonantFilter":
        case "stringResonator":
        case "modalResonanceFilter":
        case "dcBlock":
        case "combFilterReverb":
 */
 
 
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
                name = "Positive Shape"
                value = String(audio.tanhDistortion!.positiveShapeParameter)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            case 4:
                min = Float(Effects.tanhDistortion.negativeShapeParameterRange.lowerBound)
                max = Float(Effects.tanhDistortion.negativeShapeParameterRange.upperBound)
                valueForSlider = Float(audio.tanhDistortion!.negativeShapeParameter)
                name = "Negative Shape"
                value = String(audio.tanhDistortion!.negativeShapeParameter)
                value = String(value.prefix(3))
                isOn = audio.tanhDistortion!.isStarted
            default: break
            }
          
        case "dynaRageCompressor" :
            // COMPRESSOR
            switch slider {
            case 0:
                name = "Rage"
                if audio.dynaRageCompressor?.rageIsOn == true {
                    valueForSlider = 1
                } else {
                    valueForSlider = 0
                }

                isOn = audio.dynaRageCompressor!.isStarted

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
            case 5:
                min = Float(Effects.dynaRageCompressor.rageRatio.lowerBound)
                max = Float(Effects.dynaRageCompressor.rageRatio.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.rage)
                name = "Rage"
                value = String(audio.dynaRageCompressor!.rage)
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
                min = Float(Effects.delay.lowPassCutOffRange.lowerBound)
                max = Float(Effects.delay.lowPassCutOffRange.upperBound)
                valueForSlider = Float(audio.delay!.lowPassCutoff)
                name = "Low Pass Cut Off"
                value = String(audio.delay!.lowPassCutoff)
                value = String(value.prefix(3))
                isOn = audio.delay!.isStarted
            case 4:
                min = Float(Effects.delay.dryWetMixRange.lowerBound)
                max = Float(Effects.delay.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.delay!.dryWetMix)
                name = "Mix"
                value = String(audio.delay!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.delay!.isStarted
           
            default: break
            }
            
        case "variableDelay" :
            // VARIABLE DELAY
            switch slider {
            case 1:
                min = Float(Effects.variableDelay.timeRange.lowerBound)
                max = Float(Effects.variableDelay.timeRange.upperBound)
                valueForSlider = Float(audio.variableDelay!.time)
                name = "Time"
                value = String(audio.variableDelay!.time)
                value = String(value.prefix(3))
                isOn = audio.variableDelay!.isStarted
            case 2:
                min = Float(Effects.variableDelay.feedbackRange.lowerBound)
                max = Float(Effects.variableDelay.feedbackRange.upperBound)
                valueForSlider = Float(audio.variableDelay!.feedback)
                name = "Feedback"
                value = String(audio.variableDelay!.feedback)
                value = String(value.prefix(3))
                isOn = audio.variableDelay!.isStarted
            
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
            
        case "flanger" :
        
            switch slider {
            case 1:
                min = Float(Effects.flanger.frequencyRange.lowerBound)
                max = Float(Effects.flanger.frequencyRange.upperBound)
                valueForSlider = Float(audio.flanger!.frequency)
                name = "Frequency"
                value = String(audio.flanger!.frequency)
                value = String(value.prefix(3))
                isOn = audio.flanger!.isStarted
            case 2:
                min = Float(Effects.flanger.depthRange.lowerBound)
                max = Float(Effects.flanger.depthRange.upperBound)
                valueForSlider = Float(audio.flanger!.depth)
                name = "Depth"
                value = String(audio.flanger!.depth)
                value = String(value.prefix(3))
                isOn = audio.flanger!.isStarted
            case 3:
                min = Float(Effects.flanger.feedbackRange.lowerBound)
                max = Float(Effects.flanger.feedbackRange.upperBound)
                valueForSlider = Float(audio.flanger!.feedback)
                name = "Feedback"
                value = String(audio.flanger!.feedback)
                value = String(value.prefix(3))
                isOn = audio.flanger!.isStarted
            case 4:
                min = Float(Effects.flanger.dryWetMixRange.lowerBound)
                max = Float(Effects.flanger.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.flanger!.dryWetMix)
                name = "Mix"
                value = String(audio.flanger!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.flanger!.isStarted
            default: break
            }
            
        case "phaser" :
           
            switch slider {
            case 0:
                name = "Inverted"
                valueForSlider = Float(audio.phaser!.inverted)
                isOn = audio.phaser!.isStarted
            case 1:
                min = Float(Effects.phaser.notchMinimumFrequencyRange.lowerBound)
                max = Float(Effects.phaser.notchMinimumFrequencyRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchMinimumFrequency)
                name = "Notch Min Frequency"
                value = String(audio.phaser!.notchMinimumFrequency)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 2:
                min = Float(Effects.phaser.notchMaximumFrequencyRange.lowerBound)
                max = Float(Effects.phaser.notchMaximumFrequencyRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchMaximumFrequency)
                name = "Notch Max Frequency"
                value = String(audio.phaser!.notchMaximumFrequency)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 3:
                min = Float(Effects.phaser.notchWidthRange.lowerBound)
                max = Float(Effects.phaser.notchWidthRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchWidth)
                name = "Notch Width"
                value = String(audio.phaser!.notchWidth)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 4:
                min = Float(Effects.phaser.notchFrequencyRange.lowerBound)
                max = Float(Effects.phaser.notchFrequencyRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchFrequency)
                name = "Notch Frequency"
                value = String(audio.phaser!.notchFrequency)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 5:
                min = Float(Effects.phaser.vibratoModeRange.lowerBound)
                max = Float(Effects.phaser.vibratoModeRange.upperBound)
                valueForSlider = Float(audio.phaser!.vibratoMode)
                name = "Vibrato Mode"
                value = String(audio.phaser!.vibratoMode)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 6:
                min = Float(Effects.phaser.depthRange.lowerBound)
                max = Float(Effects.phaser.depthRange.upperBound)
                valueForSlider = Float(audio.phaser!.depth)
                name = "Depth"
                value = String(audio.phaser!.depth)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 7:
                min = Float(Effects.phaser.feedbackRange.lowerBound)
                max = Float(Effects.phaser.feedbackRange.upperBound)
                valueForSlider = Float(audio.phaser!.feedback)
                name = "Feedback"
                value = String(audio.phaser!.feedback)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 8:
                min = Float(Effects.phaser.lfoBPMRange.lowerBound)
                max = Float(Effects.phaser.lfoBPMRange.upperBound)
                valueForSlider = Float(audio.phaser!.lfoBPM)
                name = "lfo BPM"
                value = String(audio.phaser!.lfoBPM)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            default: break
            }
        case "chorus" :
            
            switch slider {
            case 1:
                min = Float(Effects.chorus.frequencyRange.lowerBound)
                max = Float(Effects.chorus.frequencyRange.upperBound)
                valueForSlider = Float(audio.chorus!.frequency)
                name = "Frequency"
                value = String(audio.chorus!.frequency)
                value = String(value.prefix(3))
                isOn = audio.chorus!.isStarted
            case 2:
                min = Float(Effects.chorus.depthRange.lowerBound)
                max = Float(Effects.chorus.depthRange.upperBound)
                valueForSlider = Float(audio.chorus!.depth)
                name = "Depth"
                value = String(audio.chorus!.depth)
                value = String(value.prefix(3))
                isOn = audio.chorus!.isStarted
            case 3:
                min = Float(Effects.chorus.feedbackRange.lowerBound)
                max = Float(Effects.chorus.feedbackRange.upperBound)
                valueForSlider = Float(audio.chorus!.feedback)
                name = "Feedback"
                value = String(audio.chorus!.feedback)
                value = String(value.prefix(3))
                isOn = audio.chorus!.isStarted
            case 4:
                min = Float(Effects.chorus.dryWetMixRange.lowerBound)
                max = Float(Effects.chorus.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.chorus!.dryWetMix)
                name = "Mix"
                value = String(audio.chorus!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.chorus!.isStarted
            
            default: break
            }
            
        case "compressor" :
            
            switch slider {
            case 1:
                min = Float(Effects.compressor.thresholdRange.lowerBound)
                max = Float(Effects.compressor.thresholdRange.upperBound)
                valueForSlider = Float(audio.compressor!.threshold)
                name = "Threshold"
                value = String(audio.compressor!.threshold)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
            case 2:
                min = Float(Effects.compressor.headRoomRange.lowerBound)
                max = Float(Effects.compressor.headRoomRange.upperBound)
                valueForSlider = Float(audio.compressor!.headRoom)
                name = "Headroom"
                value = String(audio.compressor!.headRoom)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
            case 3:
                min = Float(Effects.compressor.attackDurationRange.lowerBound)
                max = Float(Effects.compressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.compressor!.attackDuration)
                name = "Attack Duration"
                value = String(audio.compressor!.attackDuration)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
            case 4:
                min = Float(Effects.compressor.releaseDurationRange.lowerBound)
                max = Float(Effects.compressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.compressor!.releaseDuration)
                name = "Release Duration"
                value = String(audio.compressor!.releaseDuration)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
            case 5:
                min = Float(Effects.compressor.masterGainRange.lowerBound)
                max = Float(Effects.compressor.masterGainRange.upperBound)
                valueForSlider = Float(audio.compressor!.masterGain)
                name = "Master Gain"
                value = String(audio.compressor!.masterGain)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
           
            case 6:
                min = Float(Effects.compressor.dryWetMixRange.lowerBound)
                max = Float(Effects.compressor.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.compressor!.dryWetMix)
                name = "Mix"
                value = String(audio.compressor!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.compressor!.isStarted
                
            default: break
            }
            
        case "dynamicsProcessor" :
            
            switch slider {
            case 1:
                min = Float(Effects.dynamicsProcessor.thresholdRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.thresholdRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.threshold)
                name = "Threshold"
                value = String(audio.dynamicsProcessor!.threshold)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 2:
                min = Float(Effects.dynamicsProcessor.headRoomRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.headRoomRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.headRoom)
                name = "Headroom"
                value = String(audio.dynamicsProcessor!.headRoom)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 3:
                min = Float(Effects.dynamicsProcessor.expansionRatioRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.expansionRatioRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.expansionRatio)
                name = "Expansion Ratio"
                value = String(audio.dynamicsProcessor!.expansionRatio)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 4:
                min = Float(Effects.dynamicsProcessor.expansionThresholdRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.expansionThresholdRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.expansionThreshold)
                name = "Expansion Threshold"
                value = String(audio.dynamicsProcessor!.expansionThreshold)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 5:
                min = Float(Effects.dynamicsProcessor.attackDurationRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.attackDuration)
                name = "Attack Duration"
                value = String(audio.dynamicsProcessor!.attackDuration)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 6:
                min = Float(Effects.dynamicsProcessor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.releaseDuration)
                name = "Release Duration"
                value = String(audio.dynamicsProcessor!.releaseDuration)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 7:
                min = Float(Effects.dynamicsProcessor.masterGainRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.masterGainRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.masterGain)
                name = "Master Gain"
                value = String(audio.dynamicsProcessor!.masterGain)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
                
            case 8:
                min = Float(Effects.dynamicsProcessor.dryWetMixRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.dryWetMix)
                name = "Mix"
                value = String(audio.dynamicsProcessor!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
                
            default: break
            }
            
        case "dynamicRangeCompressor" :
            
            switch slider {
            case 1:
                min = Float(Effects.dynamicRangeCompressor.ratioRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.ratioRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.ratio)
                name = "Ratio"
                value = String(audio.dynamicRangeCompressor!.ratio)
                value = String(value.prefix(3))
                isOn = audio.dynamicRangeCompressor!.isStarted
            case 2:
                min = Float(Effects.dynamicRangeCompressor.thresholdRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.thresholdRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.threshold)
                name = "Threshold"
                value = String(audio.dynamicRangeCompressor!.threshold)
                value = String(value.prefix(3))
                isOn = audio.dynamicRangeCompressor!.isStarted
           
            case 3:
                min = Float(Effects.dynamicRangeCompressor.attackDurationRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.attackDuration)
                name = "Attack Duration"
                value = String(audio.dynamicRangeCompressor!.attackDuration)
                value = String(value.prefix(3))
                isOn = audio.dynamicRangeCompressor!.isStarted
            case 4:
                min = Float(Effects.dynamicRangeCompressor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.releaseDuration)
                name = "Release Duration"
                value = String(audio.dynamicRangeCompressor!.releaseDuration)
                value = String(value.prefix(3))
                isOn = audio.dynamicRangeCompressor!.isStarted
            
                
            default: break
            }
            
        case "reverb" :
            
            switch slider {
            case 1:
                min = Float(Effects.reverb.dryWetMixRange.lowerBound)
                max = Float(Effects.reverb.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.reverb!.dryWetMix)
                name = "Mix"
                value = String(audio.reverb!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.reverb!.isStarted
         
            default: break
            }
            
        case "reverb2" :
            
            switch slider {
            case 1:
                min = Float(Effects.reverb2.gainRange.lowerBound)
                max = Float(Effects.reverb2.gainRange.upperBound)
                valueForSlider = Float(audio.reverb2!.gain)
                name = "Gain"
                value = String(audio.reverb2!.gain)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 2:
                min = Float(Effects.reverb2.minDelayTimeRange.lowerBound)
                max = Float(Effects.reverb2.minDelayTimeRange.upperBound)
                valueForSlider = Float(audio.reverb2!.minDelayTime)
                name = "Min Delay Time"
                value = String(audio.reverb2!.minDelayTime)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 3:
                min = Float(Effects.reverb2.maxDelayTimeRange.lowerBound)
                max = Float(Effects.reverb2.maxDelayTimeRange.upperBound)
                valueForSlider = Float(audio.reverb2!.maxDelayTime)
                name = "Max Delay Time"
                value = String(audio.reverb2!.maxDelayTime)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 4:
                min = Float(Effects.reverb2.decayTimeAt0HzRange.lowerBound)
                max = Float(Effects.reverb2.decayTimeAt0HzRange.upperBound)
                valueForSlider = Float(audio.reverb2!.decayTimeAt0Hz)
                name = "0Hz Decay Time"
                value = String(audio.reverb2!.decayTimeAt0Hz)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 5:
                min = Float(Effects.reverb2.decayTimeAtNyquistRange.lowerBound)
                max = Float(Effects.reverb2.decayTimeAtNyquistRange.upperBound)
                valueForSlider = Float(audio.reverb2!.decayTimeAtNyquist)
                name = "Nyquist Decay Time"
                value = String(audio.reverb2!.decayTimeAtNyquist)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 6:
                min = Float(Effects.reverb2.randomizeReflectionsRange.lowerBound)
                max = Float(Effects.reverb2.randomizeReflectionsRange.upperBound)
                valueForSlider = Float(audio.reverb2!.randomizeReflections)
                name = "Randomize Reflections"
                value = String(audio.reverb2!.randomizeReflections)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
            case 7:
                min = Float(Effects.reverb2.dryWetMixRange.lowerBound)
                max = Float(Effects.reverb2.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.reverb2!.dryWetMix)
                name = "Mix"
                value = String(audio.reverb2!.dryWetMix)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
                
            default: break
            }
            
        case "costelloReverb" :
            
            switch slider {
            case 1:
                min = Float(Effects.costelloReverb.cutOffRange.lowerBound)
                max = Float(Effects.costelloReverb.cutOffRange.upperBound)
                valueForSlider = Float(audio.costelloReverb!.cutoffFrequency)
                name = "Cut Off Frequency"
                value = String(audio.costelloReverb!.cutoffFrequency)
                value = String(value.prefix(3))
                isOn = audio.costelloReverb!.isStarted
            case 2:
                min = Float(Effects.costelloReverb.feedbackRange.lowerBound)
                max = Float(Effects.costelloReverb.feedbackRange.upperBound)
                valueForSlider = Float(audio.costelloReverb!.feedback)
                name = "Feedback"
                value = String(audio.costelloReverb!.feedback)
                value = String(value.prefix(3))
                isOn = audio.costelloReverb!.isStarted
           
                
            default: break
            }
        case "flatFrequencyResponseReverb" :
            
            switch slider {
            case 1:
                min = Float(Effects.flatFrequencyResponseReverb.reverbDurationRange.lowerBound)
                max = Float(Effects.flatFrequencyResponseReverb.reverbDurationRange.upperBound)
                valueForSlider = Float(audio.flatFrequencyResponseReverb!.reverbDuration)
                name = "Reverb Duration"
                value = String(audio.flatFrequencyResponseReverb!.reverbDuration)
                value = String(value.prefix(3))
                isOn = audio.flatFrequencyResponseReverb!.isStarted
           
                
            default: break
            }
        case "tremolo" :
            
            switch slider {
            case 1:
                min = Float(Effects.tremolo.frequencyRange.lowerBound)
                max = Float(Effects.tremolo.frequencyRange.upperBound)
                valueForSlider = Float(audio.tremolo!.frequency)
                name = "Frequency"
                value = String(audio.tremolo!.frequency)
                value = String(value.prefix(3))
                isOn = audio.tremolo!.isStarted
            case 2:
                min = Float(Effects.tremolo.depthRange.lowerBound)
                max = Float(Effects.tremolo.depthRange.upperBound)
                valueForSlider = Float(audio.tremolo!.depth)
                name = "Depth"
                value = String(audio.tremolo!.depth)
                value = String(value.prefix(3))
                isOn = audio.tremolo!.isStarted
                
            default: break
            }
            
        default: break
        }
        return (min, max, valueForSlider, value, name, isOn)
    }
    
    
    
    
    
    
    
    func switchEQBandwidthRatio(id: String) {
        
        if id == "eq10" {
                audio.eqBandwidthRatio = 0.6
        }
        else if id == "eq31" {
            audio.eqBandwidthRatio = 0.35
        }
        
        setBandwidthsForEQ()
    }
    
    
    
    
    
    
    
    
    
    func ratioToDecibel(ratio: Double) -> Double {
        let dB = 20 * log10(ratio)
        return dB
    }
    
    func decibelToRatio(dB:Double) -> Double {
        let ratio = 10 ^ Int((dB/20))
        return Double(ratio)
    }
    
    
    
    
 
    
    func startAudio() {
        
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
            AKSettings.bufferLength = .long         // 0.01
                                                    // 512
        }
        settings.bufferLength = segment
        
        print("Buffer Legth   \(AKSettings.bufferLength.duration)")
        print("Buffer Legth   \(AKSettings.bufferLength.samplesCount)")
        
    }
    
    func audioKitSettings() {
        
        audio.shared.setBufferLength(segment: settings.bufferLength)
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
  
    func  addBalancer(id : String) {
 
        switch id {
        //effects
        case "bitCrusher" : audio.bitCrusherBalancer = AKBalancer(comparator: audio.bitCrusher!)
                            audio.selectedAudioInputs.append(audio.bitCrusherBalancer!)
        case "clipper" : audio.clipperBalancer = AKBalancer(comparator: audio.clipper!)
                        audio.selectedAudioInputs.append(audio.clipperBalancer!)
        case "autoWah":  audio.autoWahBalancer = AKBalancer(comparator: audio.autoWah!)
                        audio.selectedAudioInputs.append(audio.autoWahBalancer!)
        case "decimator": audio.decimatorBalancer = AKBalancer(comparator: audio.decimator!)
                        audio.selectedAudioInputs.append(audio.decimatorBalancer!)
        case "tanhDistortion": audio.tanhDistortionBalancer = AKBalancer(comparator: audio.tanhDistortion!)
                            audio.selectedAudioInputs.append(audio.tanhDistortionBalancer!)
        case "ringModulator": audio.ringModulatorBalancer = AKBalancer(comparator: audio.ringModulator!)
                            audio.selectedAudioInputs.append(audio.ringModulatorBalancer!)
    
        case "input" : audio.inputBalancer = AKBalancer(comparator: inputAmplitudeTracker!)
                        audio.selectedAudioInputs.append(audio.inputBalancer!)
            default : print("NOTHING to do over HERE either neither")
        }
        
        
    }
    
    func addToselectedEffects(id : String) {
        switch id {
            //effects
        case "bitCrusher" : audio.selectedAudioInputs.append(audio.bitCrusher!)
        case "clipper" : audio.selectedAudioInputs.append(audio.clipper!)
        case "dynaRageCompressor":  audio.selectedAudioInputs.append(audio.dynaRageCompressor!)
        case "autoWah":  audio.selectedAudioInputs.append(audio.autoWah!)
        case "delay":  audio.selectedAudioInputs.append(audio.delay!)
        case "variableDelay": audio.selectedAudioInputs.append(audio.variableDelay!)
        case "decimator": audio.selectedAudioInputs.append(audio.decimator!)
        case "tanhDistortion": audio.selectedAudioInputs.append(audio.tanhDistortion!)
        case "ringModulator": audio.selectedAudioInputs.append(audio.ringModulator!)
        case "flanger": audio.selectedAudioInputs.append(audio.flanger!)
        case "phaser": audio.selectedAudioInputs.append(audio.phaser!)
        case "chorus": audio.selectedAudioInputs.append(audio.chorus!)
        case "compressor": audio.selectedAudioInputs.append(audio.compressor!)
        case "dynamicsProcessor": audio.selectedAudioInputs.append(audio.dynamicsProcessor!)
        case "dynamicRangeCompressor": audio.selectedAudioInputs.append(audio.dynamicRangeCompressor!)
        case "reverb": audio.selectedAudioInputs.append(audio.reverb!)
        case "reverb2": audio.selectedAudioInputs.append(audio.reverb2!)
        case "chowningReverb": audio.selectedAudioInputs.append(audio.chowningReverb!)
        case "costelloReverb": audio.selectedAudioInputs.append(audio.costelloReverb!)
        case "flatFrequencyResponseReverb": audio.selectedAudioInputs.append(audio.flatFrequencyResponseReverb!)
        case "tremolo": audio.selectedAudioInputs.append(audio.tremolo!)
            
        
        // Filters
            
        case "Equalizer": audio.selectedAudioInputs.append(audio.threeBandFilterHigh!)
                                audio.selectedAudioInputs.append(audio.threeBandFilterMid!)
                                audio.selectedAudioInputs.append(audio.threeBandFilterLow!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterBrilliance!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterPrecence!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterUpperMid!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterMid!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterLowMid!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterBass!)
                                audio.selectedAudioInputs.append(audio.sevenBandFilterSubBass!)
            
        
            
        case "toneFilters": audio.selectedAudioInputs.append(audio.toneFilter!)
                            //audio.selectedAudioInputs.append(audio.toneComplementFilter!)
        case "moogLadder": audio.selectedAudioInputs.append(audio.moogLadder!)
            
        case "highLowPassFilters":  audio.selectedAudioInputs.append(audio.lowPassFilter!)
                                    audio.selectedAudioInputs.append(audio.lowPassButterworthFilter!)
                                    audio.selectedAudioInputs.append(audio.highPassFilter!)
                                    audio.selectedAudioInputs.append(audio.highPassButterworthFilter!)
                                     // audio.selectedAudioInputs.append(audio.highShelfFilter!)
                                     // audio.selectedAudioInputs.append(audio.highShelfParametricEqualizerFilter!)
                                     // audio.selectedAudioInputs.append(audio.lowShelfFilter!)
                                     // audio.selectedAudioInputs.append(audio.lowShelfParametricEqualizerFilter!)
            
        case "resonantFilter":      audio.selectedAudioInputs.append(audio.resonantFilter!)
        case "stringResonator":     audio.selectedAudioInputs.append(audio.stringResonator!)
        case "modalResonanceFilter": audio.selectedAudioInputs.append(audio.modalResonanceFilter!)
        case "dcBlock":             audio.selectedAudioInputs.append(audio.dcBlock!)
        case "combFilterReverb":    audio.selectedAudioInputs.append(audio.combFilterReverb!)
            
       
        default : print("NOTHING to do over HERE")
            
        }
    }
    
    func createInputListForSound() {
        // EFFECTS
        for effect in 0..<audio.selectedEffectsData.count {
            let id = audio.selectedEffectsData[effect].id
            
               addToselectedEffects(id:id)
        /*
            if effect > 0 {
                addBalancer(id: audio.selectedEffectsData[effect - 1].id)
                
                }
            else {
                addBalancer(id: "input")
            }
            */
        

            }
        // FILTERS
        for effect in 0..<audio.selectedFiltersData.count {
            let id = audio.selectedFiltersData[effect].id
            addToselectedEffects(id:id)
        }
        
    }
    
    
    func connectMic() {
        mic?.connect(to: inputBooster!)
        inputBooster?.connect(to: inputAmplitudeTracker!)

        startAmplitudeMonitors()
 
    }
    
    func startAmplitudeMonitors() {
    
        let timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            let micAmplitude = self.micTracker?.amplitude
            let inputAmplitude = self.inputAmplitudeTracker?.amplitude
            let outputAmplitude = self.outputAmplitudeTracker?.amplitude
           // print("INPUT AMPLITUDE:    \(inputAmplitude)")
           // print("OUTPUT AMPLITUDE:    \(outputAmplitude)")
           // print("MIC AMP       \(micAmplitude)")
        }
        timer.fire()
    }
    
    func connectAudioInputs() {
        
        for input in 0..<audio.selectedAudioInputs.count {
            
            if input == 0 {
                inputAmplitudeTracker?.connect(to: audio.selectedAudioInputs[0])
               // inputMixer?.connect(to: audio.selectedAudioInputs[0])
                
            }
            else {
                audio.selectedAudioInputs[input-1].connect(to: audio.selectedAudioInputs[input])
            }
        }
        
        if audio.selectedAudioInputs.isEmpty {
            inputAmplitudeTracker!.connect(to: outputMixer!)
           // inputMixer!.connect(to: outputMixer!)
        } else {
            audio.selectedAudioInputs.last?.connect(to: outputMixer!)
        }
        
        /*
        // Connect to EQ
        outputMixer?.connect(to: audio.equalizerFilter1!)
        audio.equalizerFilter1?.connect(to: audio.equalizerFilter2!)
        audio.equalizerFilter2?.connect(to: audio.equalizerFilter3!)
        audio.equalizerFilter3?.connect(to: audio.equalizerFilter4!)
        audio.equalizerFilter4?.connect(to: audio.equalizerFilter5!)
        audio.equalizerFilter5?.connect(to: audio.equalizerFilter6!)
        audio.equalizerFilter6?.connect(to: audio.equalizerFilter7!)
        audio.equalizerFilter7?.connect(to: audio.equalizerFilter8!)
        audio.equalizerFilter8?.connect(to: audio.equalizerFilter9!)
        audio.equalizerFilter9?.connect(to: audio.equalizerFilter10!)
        audio.equalizerFilter10?.connect(to: audio.equalizerFilter11!)
        audio.equalizerFilter11?.connect(to: audio.equalizerFilter12!)
        audio.equalizerFilter12?.connect(to: audio.equalizerFilter13!)
        audio.equalizerFilter13?.connect(to: audio.equalizerFilter14!)
        audio.equalizerFilter14?.connect(to: audio.equalizerFilter15!)
        audio.equalizerFilter15?.connect(to: audio.equalizerFilter16!)
        audio.equalizerFilter16?.connect(to: audio.equalizerFilter17!)
        audio.equalizerFilter17?.connect(to: audio.equalizerFilter18!)
        audio.equalizerFilter18?.connect(to: audio.equalizerFilter19!)
        audio.equalizerFilter19?.connect(to: audio.equalizerFilter20!)
        audio.equalizerFilter20?.connect(to: audio.equalizerFilter21!)
        audio.equalizerFilter21?.connect(to: audio.equalizerFilter22!)
        audio.equalizerFilter22?.connect(to: audio.equalizerFilter23!)
        audio.equalizerFilter23?.connect(to: audio.equalizerFilter24!)
        audio.equalizerFilter24?.connect(to: audio.equalizerFilter25!)
        audio.equalizerFilter25?.connect(to: audio.equalizerFilter26!)
        audio.equalizerFilter26?.connect(to: audio.equalizerFilter27!)
        audio.equalizerFilter27?.connect(to: audio.equalizerFilter28!)
        audio.equalizerFilter28?.connect(to: audio.equalizerFilter29!)
        audio.equalizerFilter29?.connect(to: audio.equalizerFilter30!)
        audio.equalizerFilter30?.connect(to: audio.equalizerFilter31!)
        audio.equalizerFilter31?.connect(to: outputBooster!)
        
        */
        
        outputMixer?.connect(to: outputBooster!)
        
        outputBooster?.connect(to: outputAmplitudeTracker!)
        
        // LAST TO OUTPUT
        AudioKit.output = outputAmplitudeTracker
        if AudioKit.output == nil {
            AudioKit.output =  inputBooster
           // AudioKit.output = inputMixer
        }
        
        if initialStart == true {
            // silence before starting to reduce unnesseccary sounds
            micVolume = mic!.volume
            mic?.volume = 0
            // START AUDIOKIT
            do {
                
                try AudioKit.start()
                
                print("START AUDIOKIT")
            } catch {
                print("Could not start AudioKit")
            }
            turnUpVolume()
            
        }
        else {
            // RESTART AUDIOKIT
            do {
                
                try AudioKit.start()
                
                print("START AUDIOKIT")
            } catch {
                print("Could not start AudioKit")
            }
        }
        
       
       
     
        
    }
    
    func turnUpVolume() {
   
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            print("Waiting for audiokit to start... .... .....")
            if AudioKit.engine.isRunning {
                sleep(1)
                self.mic?.volume = self.micVolume
               self.initialStart = false
                print("Audiokit did start ! !! !!!")
                timer.invalidate()
            }

        }
        timer.fire()
        
    }
    
    
    
    func resetAudioEffects() {
      
        
        for input in 0..<audio.selectedAudioInputs.count {
            audio.selectedAudioInputs[input].disconnectOutput()
            audio.selectedAudioInputs[input].disconnectInput()
            print("DISCONNECT \(audio.selectedAudioInputs[input])")
           
        }
       
        
        // DISCONNECT MONITORS
        outputAmplitudeTracker?.disconnectInput()
        outputAmplitudeTracker?.disconnectOutput()
        
        inputAmplitudeTracker?.disconnectInput()
        inputAmplitudeTracker?.disconnectOutput()
        
        inputBooster?.disconnectOutput()
        inputBooster?.disconnectInput()
        
        outputBooster?.disconnectOutput()
        outputBooster?.disconnectInput()
        //inputMixer?.disconnectOutput()
  
        mic?.disconnectOutput()
        
     
        
        audio.selectedAudioInputs.removeAll()
        
        do {
            try AudioKit.stop()
        } catch {
            print("Could not stop AudioKit")
        }
        
        startAudio()
    }
    
    static var clipperBalancer: AKBalancer?
    static var inputBalancer: AKBalancer?
    static var decimatorBalancer: AKBalancer?
    static var tanhDistortionBalancer: AKBalancer?
    static var ringModulatorBalancer: AKBalancer?
    static var autoWahBalancer: AKBalancer?
    static var bitCrusherBalancer: AKBalancer?
    
    var initialStart = true
    var micVolume = Double()
    
    // MONITORS
    var outputAmplitudeTracker : AKAmplitudeTracker?
    var inputAmplitudeTracker : AKAmplitudeTracker?
    var micTracker : AKMicrophoneTracker?
    
    var inputMixer: AKMixer?
    var mixerForFirstList: AKMixer?
    var mixerForSecondList: AKMixer?
    var mixerForThirdList: AKMixer?
    var outputMixer: AKMixer?
    
    
    var filterMixer: AKMixer?
    
    var mic: AKMicrophone?
    var outputBooster : AKBooster?
    var inputBooster : AKBooster?
    
    
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
    
    
    static var autoWah: AKAutoWah?
    
    // FILTERS
    
    static var eqSelection = Int(0)
  
    static var threeBandFilterHigh: AKEqualizerFilter?
    static var threeBandFilterMid: AKEqualizerFilter?
    static var threeBandFilterLow: AKEqualizerFilter?
    
    static var sevenBandFilterBrilliance: AKEqualizerFilter?
    static var sevenBandFilterPrecence: AKEqualizerFilter?
    static var sevenBandFilterUpperMid: AKEqualizerFilter?
    static var sevenBandFilterMid: AKEqualizerFilter?
    static var sevenBandFilterLowMid: AKEqualizerFilter?
    static var sevenBandFilterBass: AKEqualizerFilter?
    static var sevenBandFilterSubBass: AKEqualizerFilter?
    
    
    static var eqBandwidthRatio = Double(0.6)
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
    static var equalizerFilter13: AKEqualizerFilter?
    static var equalizerFilter14: AKEqualizerFilter?
    static var equalizerFilter15: AKEqualizerFilter?
    static var equalizerFilter16: AKEqualizerFilter?
    static var equalizerFilter17: AKEqualizerFilter?
    static var equalizerFilter18: AKEqualizerFilter?
    static var equalizerFilter19: AKEqualizerFilter?
    static var equalizerFilter20: AKEqualizerFilter?
    
    static var equalizerFilter21: AKEqualizerFilter?
    static var equalizerFilter22: AKEqualizerFilter?
    static var equalizerFilter23: AKEqualizerFilter?
    static var equalizerFilter24: AKEqualizerFilter?
    static var equalizerFilter25: AKEqualizerFilter?
    static var equalizerFilter26: AKEqualizerFilter?
    static var equalizerFilter27: AKEqualizerFilter?
    static var equalizerFilter28: AKEqualizerFilter?
    static var equalizerFilter29: AKEqualizerFilter?
    static var equalizerFilter30: AKEqualizerFilter?
    static var equalizerFilter31: AKEqualizerFilter?
    
    
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
    static var highShelfParametricEqualizerFilter: AKHighShelfParametricEqualizerFilter?
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
    
    
    
    
    
    func setBandwidthsForEQ() {
        audio.equalizerFilter1?.bandwidth = audio.equalizerFilter1!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter2?.bandwidth = audio.equalizerFilter2!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter3?.bandwidth = audio.equalizerFilter3!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter4?.bandwidth = audio.equalizerFilter4!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter5?.bandwidth = audio.equalizerFilter5!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter6?.bandwidth = audio.equalizerFilter6!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter7?.bandwidth = audio.equalizerFilter7!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter8?.bandwidth = audio.equalizerFilter8!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter9?.bandwidth = audio.equalizerFilter9!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter10?.bandwidth = audio.equalizerFilter10!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter11?.bandwidth = audio.equalizerFilter11!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter12?.bandwidth = audio.equalizerFilter12!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter13?.bandwidth = audio.equalizerFilter13!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter14?.bandwidth = audio.equalizerFilter14!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter15?.bandwidth = audio.equalizerFilter15!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter16?.bandwidth = audio.equalizerFilter16!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter17?.bandwidth = audio.equalizerFilter17!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter18?.bandwidth = audio.equalizerFilter18!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter19?.bandwidth = audio.equalizerFilter19!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter20?.bandwidth = audio.equalizerFilter20!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter21?.bandwidth = audio.equalizerFilter21!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter22?.bandwidth = audio.equalizerFilter22!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter23?.bandwidth = audio.equalizerFilter23!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter24?.bandwidth = audio.equalizerFilter24!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter25?.bandwidth = audio.equalizerFilter25!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter26?.bandwidth = audio.equalizerFilter26!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter27?.bandwidth = audio.equalizerFilter27!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter28?.bandwidth = audio.equalizerFilter28!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter29?.bandwidth = audio.equalizerFilter29!.centerFrequency * audio.eqBandwidthRatio
        audio.equalizerFilter30?.bandwidth = audio.equalizerFilter30!.centerFrequency * audio.eqBandwidthRatio
         audio.equalizerFilter31?.bandwidth = audio.equalizerFilter31!.centerFrequency * audio.eqBandwidthRatio
    }
  
    
    func createEffects() {
        
        // MONITORS
        outputAmplitudeTracker = AKAmplitudeTracker()
        inputAmplitudeTracker = AKAmplitudeTracker()
        micTracker = AKMicrophoneTracker()
        
        
        // UTILITIES
        mic = AKMicrophone()
        outputBooster = AKBooster()
        inputBooster = AKBooster()
        
        
        
        // MIXERS
        inputMixer = AKMixer()
        outputMixer = AKMixer()
        
     
        
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
        
        audio.autoWah =  AKAutoWah()
        
        // FILTERS
        
        // 3 - BAND
        let threeRatio = 0.7
        audio.threeBandFilterHigh = AKEqualizerFilter()
        audio.threeBandFilterHigh?.centerFrequency = 2000
        audio.threeBandFilterHigh?.bandwidth = 2000 * threeRatio
        audio.threeBandFilterHigh?.gain = 1
        
        audio.threeBandFilterMid = AKEqualizerFilter()
        audio.threeBandFilterMid?.centerFrequency = 500
        audio.threeBandFilterMid?.bandwidth = 500 * threeRatio
        audio.threeBandFilterMid?.gain = 1
        
        audio.threeBandFilterLow = AKEqualizerFilter()
        audio.threeBandFilterLow?.centerFrequency = 100
        audio.threeBandFilterLow?.bandwidth = 100 * threeRatio
        audio.threeBandFilterLow?.gain = 1
        
        
        // 7 - BAND
        let sevenRatio = (0.5)
        //https://www.teachmeaudio.com/mixing/techniques/audio-spectrum/
        audio.sevenBandFilterBrilliance = AKEqualizerFilter()   // 6 kHz to 20 kHz
        audio.sevenBandFilterBrilliance?.centerFrequency = 6400
        audio.sevenBandFilterBrilliance?.bandwidth = 6400 * sevenRatio
        audio.sevenBandFilterBrilliance?.gain = 1
        
        
        audio.sevenBandFilterPrecence = AKEqualizerFilter()     // 4 kHz to 6 kHz
        audio.sevenBandFilterPrecence?.centerFrequency = 4200
        audio.sevenBandFilterPrecence?.bandwidth = 4200 * sevenRatio
        audio.sevenBandFilterPrecence?.gain = 1
        
        audio.sevenBandFilterUpperMid = AKEqualizerFilter()     // 2 to 4 kHz
        audio.sevenBandFilterUpperMid?.centerFrequency = 2000
        audio.sevenBandFilterUpperMid?.bandwidth = 2000 * sevenRatio
        audio.sevenBandFilterUpperMid?.gain = 1
        
        audio.sevenBandFilterMid = AKEqualizerFilter()          // 500 Hz to 2 kHz
        audio.sevenBandFilterMid?.centerFrequency = 500
        audio.sevenBandFilterMid?.bandwidth = 500 * sevenRatio
        audio.sevenBandFilterMid?.gain = 1
        
        audio.sevenBandFilterLowMid = AKEqualizerFilter()       // 250 to 500 Hz
        audio.sevenBandFilterLowMid?.centerFrequency = 250
        audio.sevenBandFilterLowMid?.bandwidth = 250 * sevenRatio
        audio.sevenBandFilterLowMid?.gain = 1
        
        audio.sevenBandFilterBass = AKEqualizerFilter()    // 60 to 250 Hz
        audio.sevenBandFilterBass?.centerFrequency = 70
        audio.sevenBandFilterBass?.bandwidth = 70 * sevenRatio
        audio.sevenBandFilterBass?.gain = 1
        
        audio.sevenBandFilterSubBass = AKEqualizerFilter() // 20 to 60 Hz
        audio.sevenBandFilterSubBass?.centerFrequency = 30
        audio.sevenBandFilterSubBass?.bandwidth = 30 * sevenRatio
        audio.sevenBandFilterSubBass?.gain = 1
        
        
        audio.toneFilter = AKToneFilter()
        audio.toneComplementFilter = AKToneComplementFilter()
        
        
        
        
        audio.equalizerFilter1 = AKEqualizerFilter()
        audio.equalizerFilter1?.centerFrequency = 20
        audio.equalizerFilter1?.gain = 1
        audio.equalizerFilter1?.bandwidth = audio.equalizerFilter1!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter2 = AKEqualizerFilter()
        audio.equalizerFilter2?.centerFrequency = 25
        audio.equalizerFilter2?.gain = 1
        audio.equalizerFilter2?.bandwidth = audio.equalizerFilter2!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter3 = AKEqualizerFilter()
        audio.equalizerFilter3?.centerFrequency = 31.5
        audio.equalizerFilter3?.gain = 1
        audio.equalizerFilter3?.bandwidth = audio.equalizerFilter3!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter4 = AKEqualizerFilter()
        audio.equalizerFilter4?.centerFrequency = 40
        audio.equalizerFilter4?.gain = 1
        audio.equalizerFilter4?.bandwidth = audio.equalizerFilter4!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter5 = AKEqualizerFilter()
        audio.equalizerFilter5?.centerFrequency = 50
        audio.equalizerFilter5?.gain = 1
        audio.equalizerFilter5?.bandwidth = audio.equalizerFilter5!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter6 = AKEqualizerFilter()
        audio.equalizerFilter6?.centerFrequency = 63
        audio.equalizerFilter6?.gain = 1
        audio.equalizerFilter6?.bandwidth = audio.equalizerFilter6!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter7 = AKEqualizerFilter()
        audio.equalizerFilter7?.centerFrequency = 80
        audio.equalizerFilter7?.gain = 1
        audio.equalizerFilter7!.bandwidth = audio.equalizerFilter7!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter8 = AKEqualizerFilter()
        audio.equalizerFilter8?.centerFrequency = 100
        audio.equalizerFilter8?.gain = 1
        audio.equalizerFilter8?.bandwidth = audio.equalizerFilter8!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter9 = AKEqualizerFilter()
        audio.equalizerFilter9?.centerFrequency = 125
        audio.equalizerFilter9?.gain = 1
        audio.equalizerFilter9?.bandwidth = audio.equalizerFilter9!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter10 = AKEqualizerFilter()
        audio.equalizerFilter10?.centerFrequency = 160
        audio.equalizerFilter10?.gain = 1
        audio.equalizerFilter10?.bandwidth = audio.equalizerFilter10!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter11 = AKEqualizerFilter()
        audio.equalizerFilter11?.centerFrequency = 200
        audio.equalizerFilter11?.gain = 1
        audio.equalizerFilter11?.bandwidth = audio.equalizerFilter11!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter12 = AKEqualizerFilter()
        audio.equalizerFilter12?.centerFrequency = 250
        audio.equalizerFilter12?.gain = 1
        audio.equalizerFilter12?.bandwidth = audio.equalizerFilter12!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter13 = AKEqualizerFilter()
        audio.equalizerFilter13?.centerFrequency = 315
        audio.equalizerFilter13?.gain = 1
        audio.equalizerFilter13?.bandwidth = audio.equalizerFilter13!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter14 = AKEqualizerFilter()
        audio.equalizerFilter14?.centerFrequency = 400
        audio.equalizerFilter14?.gain = 1
        audio.equalizerFilter14?.bandwidth = audio.equalizerFilter14!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter15 = AKEqualizerFilter()
        audio.equalizerFilter15?.centerFrequency = 500
        audio.equalizerFilter15?.gain = 1
        audio.equalizerFilter15?.bandwidth = audio.equalizerFilter15!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter16 = AKEqualizerFilter()
        audio.equalizerFilter16?.centerFrequency = 630
        audio.equalizerFilter16?.gain = 1
        audio.equalizerFilter16?.bandwidth = audio.equalizerFilter16!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter17 = AKEqualizerFilter()
        audio.equalizerFilter17?.centerFrequency = 800
        audio.equalizerFilter17?.gain = 1
        audio.equalizerFilter17!.bandwidth = audio.equalizerFilter17!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter18 = AKEqualizerFilter()
        audio.equalizerFilter18?.centerFrequency = 1000
        audio.equalizerFilter18?.gain = 1
        audio.equalizerFilter18?.bandwidth = audio.equalizerFilter18!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter19 = AKEqualizerFilter()
        audio.equalizerFilter19?.centerFrequency = 1250
        audio.equalizerFilter19?.gain = 1
        audio.equalizerFilter19?.bandwidth = audio.equalizerFilter19!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter20 = AKEqualizerFilter()
        audio.equalizerFilter20?.centerFrequency = 1600
        audio.equalizerFilter20?.gain = 1
        audio.equalizerFilter20?.bandwidth = audio.equalizerFilter10!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter21 = AKEqualizerFilter()
        audio.equalizerFilter21?.centerFrequency = 2000
        audio.equalizerFilter21?.gain = 1
        audio.equalizerFilter21?.bandwidth = audio.equalizerFilter21!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter22 = AKEqualizerFilter()
        audio.equalizerFilter22?.centerFrequency = 2500
        audio.equalizerFilter22?.gain = 1
        audio.equalizerFilter22?.bandwidth = audio.equalizerFilter22!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter23 = AKEqualizerFilter()
        audio.equalizerFilter23?.centerFrequency = 3150
        audio.equalizerFilter23?.gain = 1
        audio.equalizerFilter23?.bandwidth = audio.equalizerFilter23!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter24 = AKEqualizerFilter()
        audio.equalizerFilter24?.centerFrequency = 4000
        audio.equalizerFilter24?.gain = 1
        audio.equalizerFilter24?.bandwidth = audio.equalizerFilter24!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter25 = AKEqualizerFilter()
        audio.equalizerFilter25?.centerFrequency = 5000
        audio.equalizerFilter25?.gain = 1
        audio.equalizerFilter25?.bandwidth = audio.equalizerFilter25!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter26 = AKEqualizerFilter()
        audio.equalizerFilter26?.centerFrequency = 6300
        audio.equalizerFilter26?.gain = 1
        audio.equalizerFilter26?.bandwidth = audio.equalizerFilter26!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter27 = AKEqualizerFilter()
        audio.equalizerFilter27?.centerFrequency = 8000
        audio.equalizerFilter27?.gain = 1
        audio.equalizerFilter27!.bandwidth = audio.equalizerFilter27!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter28 = AKEqualizerFilter()
        audio.equalizerFilter28?.centerFrequency = 10000
        audio.equalizerFilter28?.gain = 1
        audio.equalizerFilter28?.bandwidth = audio.equalizerFilter28!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter29 = AKEqualizerFilter()
        audio.equalizerFilter29?.centerFrequency = 12500
        audio.equalizerFilter29?.gain = 1
        audio.equalizerFilter29?.bandwidth = audio.equalizerFilter29!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter30 = AKEqualizerFilter()
        audio.equalizerFilter30?.centerFrequency = 16000
        audio.equalizerFilter30?.gain = 1
        audio.equalizerFilter30?.bandwidth = audio.equalizerFilter30!.centerFrequency * audio.eqBandwidthRatio
        
        audio.equalizerFilter31 = AKEqualizerFilter()
        audio.equalizerFilter31?.centerFrequency = 20000
        audio.equalizerFilter31?.gain = 1
        audio.equalizerFilter31?.bandwidth = audio.equalizerFilter31!.centerFrequency * audio.eqBandwidthRatio
        
        
        audio.highPassFilter = AKHighPassFilter()
        audio.lowPassFilter = AKLowPassFilter()
        
       
        
        audio.masterBooster = AKBooster()
        //audio.masterBooster?.start()
        
        
        
        
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
        audio.highShelfParametricEqualizerFilter = AKHighShelfParametricEqualizerFilter()
        
        audio.formantFilter = AKFormantFilter()
        audio.rolandTB303Filter = AKRolandTB303Filter()
        audio.korgLowPassFilter = AKKorgLowPassFilter()
        audio.threePoleLowpassFilter = AKThreePoleLowpassFilter()
        
        audio.moogLadder = AKMoogLadder()
        
        
        audio.dcBlock = AKDCBlock()
        audio.stringResonator = AKStringResonator()
        audio.combFilterReverb = AKCombFilterReverb()
        
        
        
        
        
        // start essential units
        
        outputAmplitudeTracker?.start()
        micTracker?.start()
        
        outputBooster?.start()
        inputBooster?.start()
        
        //inputMixer?.start()
        outputMixer?.start()
        
        // stop all effects
     
        // Delay
        audio.delay?.stop()
        audio.variableDelay?.stop()
        
        // Dynamics
        audio.dynaRageCompressor?.stop()
        audio.compressor?.stop()
        audio.dynamicsProcessor?.stop()
        audio.dynamicRangeCompressor?.stop()
        
        // Distorion effects
        audio.bitCrusher?.stop()
        audio.clipper?.stop()
        audio.tanhDistortion?.stop()
        audio.decimator?.stop()
        audio.ringModulator?.stop()
        
        // Modulation effects
        audio.flanger?.stop()
        audio.phaser?.stop()
        audio.chorus?.stop()
        
        
        // Reverb
        audio.chowningReverb?.stop()
        audio.costelloReverb?.stop()
        audio.flatFrequencyResponseReverb?.stop()
        audio.reverb?.stop()
        audio.reverb2?.stop()
        
        // Simulators
        audio.rhinoGuitarProcessor?.stop()
        
        // tremolo
        audio.tremolo?.stop()
        
        // FILTERS
        audio.autoWah?.stop()
        
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
