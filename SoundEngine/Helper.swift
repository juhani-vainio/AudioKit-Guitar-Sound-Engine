//
//  Helper.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 26/10/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import UIKit

class helper {
    
    
    // COLLECTION VIEW LAYOUTS
    static var activeLayout = ""
    static var smallLayoutSize = CGFloat()
    static var activeEffectCell = Int()
    static var activeSoundCell = Int()
    
    static var newEffectAdded = Bool(false)
    static var newChainSelected = Bool(false)
    
    static let shared = helper()
    

    
   
    
    func replaceEffectDataArrays(name: String) {
        
        // get interface relevant data and place to relevant lists
        if audio.allPossibleEffectsData.contains(where: {$0.id == name}) {
            if let thisEffectData = audio.allPossibleEffectsData.first(where: {$0.id == name}) {
  
                  audio.selectedEffectsData.append(thisEffectData)
                
            } else {
                print("Not found in all possible effects data \(name)")
            }
        }
        else if audio.allPossibleFiltersData.contains(where: {$0.id == name}) {
             if let thisFilterData = audio.allPossibleFiltersData.first(where: {$0.id == name}) {
     
                audio.selectedFiltersData.append(thisFilterData)
                
            }
        }
        
    }
    
    func rearrangeLists() {
        
        // add unused effects to the list of available effects
        for effect in audio.allPossibleEffectsData {
            if audio.selectedEffectsData.contains(where: {$0.id == effect.id})   {
                
            }
  
            else {
                audio.availableEffectsData.append(effect)
            }
        }
        // same or filters
        
        for effect in audio.allPossibleFiltersData {
            if audio.selectedFiltersData.contains(where: {$0.id == effect.id})   {
                
            }
                
            else {
                audio.availableFiltersData.append(effect)
            }
        }
    }
    
    
    
    
    
    func getSavedChain(name: String) {
        
        if name == "activeSound" {
            print("Get values for \(name)")
            let chainArray = UserDefaults.standard.array(forKey: name) ?? [[String:String]]()
            if chainArray.isNotEmpty{
                setValuesForReceivedChain(valuesForChain: chainArray)
            }
            else {
                // FIRST TIMER
                print("FIRST TIME OPENING APP...... NO SOUNDS......")
                setValuesForReceivedChain(valuesForChain: chainArray)
            }
        }
        
        else if Collections.savedSounds.contains(name) {
            print("Get values for \(name)")
            let chainArray = UserDefaults.standard.array(forKey: name) ?? [[String:String]]()
            setValuesForReceivedChain(valuesForChain: chainArray)
        } else {
            print("NO \(name) found.")
        }
    }
    
    
    // which effects are saved into this saved sound
    func getDataForATable(name: String) -> [String] {
        
        var returnArray = [String]()
        
        if Collections.savedSounds.contains(name) {
            print("Get values for \(name)")
            let chainArray = UserDefaults.standard.array(forKey: name) ?? [[String:String]]()
            
            for effect in chainArray {
                let name:String = (effect as AnyObject).value(forKey: "name") as! String
                print(name)
                returnArray.append(name)
            }
            
        } else {
            print("NO \(name) found.")
        }
        return returnArray
        
    }
    

    func saveCurrentSettings() {
        
        var dictionary = [[String:String]]()
        
        for effect in audio.selectedEffectsData {
            let array = createEffectDataArray(effect: effect, location: "Effects")
            if array.isNotEmpty{
                dictionary.append(array)
            }
            
        }
        // same for filters
        for effect in audio.selectedFiltersData {
            let array = createEffectDataArray(effect: effect, location: "Filters")
            if array.isNotEmpty{
                dictionary.append(array)
            }
            
        }
        
        UserDefaults.standard.set(dictionary, forKey: "activeSound")
        
        
    }
    
    func saveEffectChain(name: String) {
        
        var dictionary = [[String:String]]()
        
        for effect in audio.selectedEffectsData {
            let array = createEffectDataArray(effect: effect, location: "Effects")
            if array.isNotEmpty {
                dictionary.append(array)
            }
        }
        // same for filters
        for effect in audio.selectedFiltersData {
            let array = createEffectDataArray(effect: effect, location: "Filters")
            if array.isNotEmpty{
                dictionary.append(array)
            }
            
        }
        
        /*
         let eqDataArray = createEQDataArray()
         if eqDataArray.isNotEmpty{
         dictionary.append(eqDataArray)
         }
         */
        
        /*
         for effect in audio.selectedUnitsAfterData {
         let array = createEffectDataArray(effect: effect, location: "selectedUnitsAfterData")
         if array.isNotEmpty {
         dictionary.append(array)
         }
         }
         
         for effect in audio.finalFiltersData {
         let array = createEffectDataArray(effect: effect, location: "finalFiltersData")
         dictionary.append(array)
         }
         */
        saveNameForChain(name: name)
        UserDefaults.standard.set(dictionary, forKey: name)
    }
 
    func saveNameForChain(name: String){
        
        if Collections.savedSounds.isNotEmpty {
            if Collections.savedSounds.contains(name) {
                print("\(name) found. Update values for this chain.")
            } else {
                Collections.savedSounds.append(name)
                print("NO \(name) found. Save values for a new chain.")
                UserDefaults.standard.set(Collections.savedSounds, forKey: "savedSounds")
            }
        } else {
            Collections.savedSounds.append(name)
            print("\(name) will be the first effect chain. Save values for a new chain.")
            UserDefaults.standard.set(Collections.savedSounds, forKey: "savedSounds")
        }
        
        
    }
    
    func checkUserDefaults() {
        
        print("checkUserDefaults")
        
        let savedBufferLength = UserDefaults.standard.integer(forKey: "bufferLength")
        if savedBufferLength != 0 {
            settings.bufferLength = savedBufferLength
        }
        let inputBooster = UserDefaults.standard.double(forKey: "inputBooster")
        if inputBooster != 0 {
            audio.shared.inputBooster?.dB = inputBooster
        }
        let outputBooster = UserDefaults.standard.double(forKey: "outputBooster")
        if outputBooster != 0 {
            audio.shared.outputBooster?.dB = outputBooster
        }
        
        // all saved sounds
        let savedSounds = UserDefaults.standard.stringArray(forKey: "savedSounds")  ?? [String]()
        if savedSounds.isNotEmpty {
            print("savedSOunds is NOT empty")
            Collections.savedSounds = savedSounds
            print(Collections.savedSounds)
        } else {
            print("savedSounds is empty")
        }
        
        getSavedChain(name: "activeSound")
  
        
    }
    
    func addSpaces(text: String) -> String {
        var newText = text
        var charCount = 0
        for char in text {
            if char.isUpper(string: String(char)) {
                newText.insert(" ", at: newText.index(newText.startIndex, offsetBy: charCount))
                charCount = charCount + 1
            }
            charCount = charCount + 1
        }
        newText = newText.deletingPrefix(" ")
        return newText
    }
    
    func clipValue(text: String) -> String {
        var newText = text
        newText = String(newText.prefix(3))
        return newText
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func createEffectDataArray(effect: effectData, location: String) -> [String: String] {
        var array = [String: String]()
        switch effect.id {
        case "bitCrusher" :
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(location, forKey: "location")
            array.updateValue(String(audio.bitCrusher!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.bitCrusher!.bitDepth), forKey: "bitDepth")
            array.updateValue(String(audio.bitCrusher!.sampleRate), forKey: "sampleRate")
            
        case "tanhDistortion" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.tanhDistortion!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.tanhDistortion!.pregain), forKey: "pregain")
            array.updateValue(String(audio.tanhDistortion!.postgain), forKey: "postgain")
            array.updateValue(String(audio.tanhDistortion!.positiveShapeParameter), forKey: "positiveShapeParameter")
            array.updateValue(String(audio.tanhDistortion!.negativeShapeParameter), forKey: "negativeShapeParameter")
            
            
        case "clipper" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.clipper!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.clipper!.limit), forKey: "limit")
            
            
            
        case "dynaRageCompressor" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.dynaRageCompressor!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.dynaRageCompressor!.ratio), forKey: "ratio")
            array.updateValue(String(audio.dynaRageCompressor!.threshold), forKey: "threshold")
            array.updateValue(String(audio.dynaRageCompressor!.attackDuration), forKey: "attackDuration")
            array.updateValue(String(audio.dynaRageCompressor!.releaseDuration), forKey: "releaseDuration")
            array.updateValue(String(audio.dynaRageCompressor!.rage), forKey: "rage")
            array.updateValue(String(audio.dynaRageCompressor!.rageIsOn), forKey: "rageIsOn")
            
        case "autoWah" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.autoWah!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.autoWah!.wah), forKey: "wah")
            array.updateValue(String(audio.autoWah!.amplitude), forKey: "amplitude")
            array.updateValue(String(audio.autoWah!.mix), forKey: "mix")
            
            
        case "delay" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.delay!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.delay!.time), forKey: "time")
            array.updateValue(String(audio.delay!.feedback), forKey: "feedback")
            array.updateValue(String(audio.delay!.lowPassCutoff), forKey: "lowPassCutOff")
            array.updateValue(String(audio.delay!.dryWetMix), forKey: "dryWetMix")
            
        case "variableDelay" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.variableDelay!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.variableDelay!.time), forKey: "time")
            array.updateValue(String(audio.variableDelay!.feedback), forKey: "feedback")
            
            
        case "decimator" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.decimator!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.decimator!.decimation), forKey: "decimation")
            array.updateValue(String(audio.decimator!.rounding), forKey: "rounding")
            array.updateValue(String(audio.decimator!.mix), forKey: "mix")
            
            
        case "ringModulator" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.ringModulator!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.ringModulator!.frequency1), forKey: "frequency1")
            array.updateValue(String(audio.ringModulator!.frequency2), forKey: "frequency2")
            array.updateValue(String(audio.ringModulator!.balance), forKey: "balance")
            array.updateValue(String(audio.ringModulator!.mix), forKey: "mix")
            
            
        case "flanger" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.flanger!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.flanger!.frequency), forKey: "frequency")
            array.updateValue(String(audio.flanger!.depth), forKey: "depth")
            array.updateValue(String(audio.flanger!.feedback), forKey: "feedback")
            array.updateValue(String(audio.flanger!.dryWetMix), forKey: "dryWetMix")
            
        case "phaser" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.phaser!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.phaser!.notchMinimumFrequency), forKey: "notchMinimumFrequency")
            array.updateValue(String(audio.phaser!.notchMaximumFrequency), forKey: "notchMaximumFrequency")
            array.updateValue(String(audio.phaser!.notchWidth), forKey: "notchWidth")
            array.updateValue(String(audio.phaser!.notchFrequency), forKey: "notchFrequency")
            array.updateValue(String(audio.phaser!.vibratoMode), forKey: "vibratoMode")
            array.updateValue(String(audio.phaser!.depth), forKey: "depth")
            array.updateValue(String(audio.phaser!.feedback), forKey: "feedback")
            array.updateValue(String(audio.phaser!.lfoBPM), forKey: "lfoBPM")
            array.updateValue(String(audio.phaser!.inverted), forKey: "inverted")
            
        case "chorus" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.chorus!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.chorus!.frequency), forKey: "frequency")
            array.updateValue(String(audio.chorus!.depth), forKey: "depth")
            array.updateValue(String(audio.chorus!.feedback), forKey: "feedback")
            array.updateValue(String(audio.chorus!.dryWetMix), forKey: "dryWetMix")
            
        case "compressor" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.compressor!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.compressor!.threshold), forKey: "threshold")
            array.updateValue(String(audio.compressor!.headRoom), forKey: "headRoom")
            array.updateValue(String(audio.compressor!.attackDuration), forKey: "attackDuration")
            array.updateValue(String(audio.compressor!.releaseDuration), forKey: "releaseDuration")
            array.updateValue(String(audio.compressor!.masterGain), forKey: "masterGain")
            array.updateValue(String(audio.compressor!.dryWetMix), forKey: "dryWetMix")
            
        case "dynamicsProcessor" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.dynamicsProcessor!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.dynamicsProcessor!.threshold), forKey: "threshold")
            array.updateValue(String(audio.dynamicsProcessor!.headRoom), forKey: "headRoom")
            array.updateValue(String(audio.dynamicsProcessor!.expansionRatio), forKey: "expansionRatio")
            array.updateValue(String(audio.dynamicsProcessor!.expansionThreshold), forKey: "expansionThreshold")
            array.updateValue(String(audio.dynamicsProcessor!.attackDuration), forKey: "attackDuration")
            array.updateValue(String(audio.dynamicsProcessor!.releaseDuration), forKey: "releaseDuration")
            array.updateValue(String(audio.dynamicsProcessor!.masterGain), forKey: "masterGain")
            array.updateValue(String(audio.dynamicsProcessor!.dryWetMix), forKey: "dryWetMix")
            
        case "dynamicRangeCompressor" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.dynamicRangeCompressor!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.dynamicRangeCompressor!.ratio), forKey: "ratio")
            array.updateValue(String(audio.dynamicRangeCompressor!.threshold), forKey: "threshold")
            array.updateValue(String(audio.dynamicRangeCompressor!.attackDuration), forKey: "attackDuration")
            array.updateValue(String(audio.dynamicRangeCompressor!.releaseDuration), forKey: "releaseDuration")
            
        case "reverb" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.reverb!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.reverb!.dryWetMix), forKey: "dryWetMix")
            
        case "reverb2" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.reverb2!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.reverb2!.gain), forKey: "gain")
            array.updateValue(String(audio.reverb2!.minDelayTime), forKey: "minDelayTime")
            array.updateValue(String(audio.reverb2!.maxDelayTime), forKey: "maxDelayTime")
            array.updateValue(String(audio.reverb2!.decayTimeAtNyquist), forKey: "decayTimeAtNyquist")
            array.updateValue(String(audio.reverb2!.decayTimeAt0Hz), forKey: "decayTimeAt0Hz")
            array.updateValue(String(audio.reverb2!.randomizeReflections), forKey: "randomizeReflections")
            array.updateValue(String(audio.reverb2!.dryWetMix), forKey: "dryWetMix")
            
        case "chowningReverb" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.chowningReverb!.isStarted), forKey: "isStarted")
            
        case "costelloReverb" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.costelloReverb!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.costelloReverb!.cutoffFrequency), forKey: "cutoffFrequency")
            array.updateValue(String(audio.costelloReverb!.feedback), forKey: "feedback")
            
        case "flatFrequencyResponseReverb" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.flatFrequencyResponseReverb!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.flatFrequencyResponseReverb!.reverbDuration), forKey: "reverbDuration")
            
        case "tremolo" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.tremolo!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.tremolo!.frequency), forKey: "frequency")
            array.updateValue(String(audio.tremolo!.depth), forKey: "depth")
            
            
        // FILTERS
            
        case "Equalizer" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.eqSelection), forKey: "eqSelection")
            if audio.eqSelection == 0 {
                array.updateValue(String(audio.threeBandFilterHigh!.gain), forKey: "threeBandFilterHigh")
                array.updateValue(String(audio.threeBandFilterMid!.gain), forKey: "threeBandFilterMid")
                array.updateValue(String(audio.threeBandFilterLow!.gain), forKey: "threeBandFilterLow")
            }
            else if audio.eqSelection == 1 {
                array.updateValue(String(audio.sevenBandFilterSubBass!.gain), forKey: "sevenBandFilterSubBass")
                array.updateValue(String(audio.sevenBandFilterBass!.gain), forKey: "sevenBandFilterBass")
                array.updateValue(String(audio.sevenBandFilterLowMid!.gain), forKey: "sevenBandFilterLowMid")
                array.updateValue(String(audio.sevenBandFilterMid!.gain), forKey: "sevenBandFilterMid")
                array.updateValue(String(audio.sevenBandFilterUpperMid!.gain), forKey: "sevenBandFilterUpperMid")
                array.updateValue(String(audio.sevenBandFilterPrecence!.gain), forKey: "sevenBandFilterPrecence")
                array.updateValue(String(audio.sevenBandFilterBrilliance!.gain), forKey: "sevenBandFilterBrilliance")
            }
            
           
        case "moogLadder" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.moogLadder!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.moogLadder!.cutoffFrequency), forKey: "cutoffFrequency")
            array.updateValue(String(audio.moogLadder!.resonance), forKey: "resonance")
            
        case "resonantFilter" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.resonantFilter!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.resonantFilter!.frequency), forKey: "frequency")
            array.updateValue(String(audio.resonantFilter!.bandwidth), forKey: "bandwidth")
            
        case "stringResonator" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.stringResonator!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.stringResonator!.fundamentalFrequency), forKey: "fundamentalFrequency")
            array.updateValue(String(audio.stringResonator!.feedback), forKey: "feedback")
            
        case "modalResonanceFilter" :
            array.updateValue(location, forKey: "location")
            array.updateValue(effect.id, forKey: "name")
            array.updateValue(String(audio.modalResonanceFilter!.isStarted), forKey: "isStarted")
            array.updateValue(String(audio.modalResonanceFilter!.frequency), forKey: "frequency")
            array.updateValue(String(audio.modalResonanceFilter!.qualityFactor), forKey: "qualityFactor")
            
            
            
        default : print("addToDictionaryToSave default hmmm?")
            
        }
        return array
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setValuesForReceivedChain(valuesForChain: [Any]) {
        print("setValuesForReceivedChain")
        print(valuesForChain)
        audio.selectedEffectsData.removeAll()
        // audio.selectedUnitsAfterData.removeAll()
        audio.availableEffectsData.removeAll()
        audio.selectedFiltersData.removeAll()
        audio.availableFiltersData.removeAll()
        for effect in valuesForChain {
            let name:String = (effect as AnyObject).value(forKey: "name") as! String
            // let location:String = (effect as AnyObject).value(forKey: "location") as! String
            // tyhjennä listat ennen lisäystä....
            
            replaceEffectDataArrays(name:name)
            
            /*
            if name != "equalizerFilter" {
                replaceEffectDataArrays(name:name)
            }
            */
            
            switch name {
                
            // EFFECTS
                
            case "bitCrusher" :
                guard let sampleRate = (effect as AnyObject).value(forKey: "sampleRate")! as? String else {
                    return
                }
                guard let bitDepth = (effect as AnyObject).value(forKey: "bitDepth")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                audio.bitCrusher!.sampleRate = Double(sampleRate)!
                audio.bitCrusher!.bitDepth = Double(bitDepth)!
                let started = Bool(isStarted)!
                if started == true {audio.bitCrusher!.start()} else {audio.bitCrusher!.stop()}
                
                
            case "tanhDistortion" :
                guard let pregain = (effect as AnyObject).value(forKey: "pregain")! as? String else {
                    return
                }
                guard let postgain = (effect as AnyObject).value(forKey: "postgain")! as? String else {
                    return
                }
                guard let negativeShapeParameter = (effect as AnyObject).value(forKey: "negativeShapeParameter")! as? String else {
                    return
                }
                guard let positiveShapeParameter = (effect as AnyObject).value(forKey: "positiveShapeParameter")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                audio.tanhDistortion!.pregain = Double(pregain)!
                audio.tanhDistortion!.postgain = Double(postgain)!
                audio.tanhDistortion!.negativeShapeParameter = Double(negativeShapeParameter)!
                audio.tanhDistortion!.positiveShapeParameter = Double(positiveShapeParameter)!
                let started = Bool(isStarted)!
                if started == true {audio.tanhDistortion!.start()} else {audio.tanhDistortion!.stop()}
                
                
            case "clipper" :
                
                guard let limit = (effect as AnyObject).value(forKey: "limit")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                audio.clipper!.limit = Double(limit)!
                let started = Bool(isStarted)!
                if started == true {audio.clipper!.start()} else {audio.clipper!.stop()}
                
                
            case "dynaRageCompressor" :
                
                guard let attackDuration = (effect as AnyObject).value(forKey: "attackDuration")! as? String else {
                    return
                }
                guard let releaseDuration = (effect as AnyObject).value(forKey: "releaseDuration")! as? String else {
                    return
                }
                guard let ratio = (effect as AnyObject).value(forKey: "ratio")! as? String else {
                    return
                }
                guard let threshold = (effect as AnyObject).value(forKey: "threshold")! as? String else {
                    return
                }
                guard let rage = (effect as AnyObject).value(forKey: "rage")! as? String else {
                    return
                }
                guard let rageIsOn = (effect as AnyObject).value(forKey: "rageIsOn")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                audio.dynaRageCompressor!.rageIsOn = Bool(rageIsOn)!
                audio.dynaRageCompressor!.rage = Double(rage)!
                audio.dynaRageCompressor!.attackDuration = Double(attackDuration)!
                audio.dynaRageCompressor!.releaseDuration = Double(releaseDuration)!
                audio.dynaRageCompressor!.ratio = Double(ratio)!
                audio.dynaRageCompressor!.threshold = Double(threshold)!
                let started = Bool(isStarted)!
                if started == true {audio.dynaRageCompressor!.start()} else {audio.dynaRageCompressor!.stop()}
                
                
                
            case "autoWah" :
                guard let wah = (effect as AnyObject).value(forKey: "wah")! as? String else {
                    return
                }
                guard let amplitude = (effect as AnyObject).value(forKey: "amplitude")! as? String else {
                    return
                }
                guard let mix = (effect as AnyObject).value(forKey: "mix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.autoWah!.wah = Double(wah)!
                audio.autoWah!.amplitude = Double(amplitude)!
                audio.autoWah!.mix = Double(mix)!
                let started = Bool(isStarted)!
                if started == true {audio.autoWah!.start()} else {audio.autoWah!.stop()}
                
                
            case "delay" :
                
                
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                guard let lowPassCutOff = (effect as AnyObject).value(forKey: "lowPassCutOff")! as? String else {
                    return
                }
                guard let time = (effect as AnyObject).value(forKey: "time")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.delay!.dryWetMix = Double(dryWetMix)!
                audio.delay!.feedback = Double(feedback)!
                audio.delay!.lowPassCutoff = Double(lowPassCutOff)!
                audio.delay!.time = TimeInterval(time)!
                let started = Bool(isStarted)!
                if started == true {audio.delay!.start()} else {audio.delay!.stop()}
                
            case "variableDelay" :
                
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                
                guard let time = (effect as AnyObject).value(forKey: "time")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.variableDelay!.feedback = Double(feedback)!
                audio.variableDelay!.time = TimeInterval(time)!
                
                let started = Bool(isStarted)!
                if started == true {audio.variableDelay!.start()} else {audio.variableDelay!.stop()}
                
                
            case "decimator" :
                guard let decimation = (effect as AnyObject).value(forKey: "decimation")! as? String else {
                    return
                }
                guard let mix = (effect as AnyObject).value(forKey: "mix")! as? String else {
                    return
                }
                guard let rounding = (effect as AnyObject).value(forKey: "rounding")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.decimator!.decimation = Double(decimation)!
                audio.decimator!.mix = Double(mix)!
                audio.decimator!.rounding = Double(rounding)!
                let started = Bool(isStarted)!
                if started == true {audio.decimator!.start()} else {audio.decimator!.stop()}
                
                
                
            case "ringModulator" :
                guard let balance = (effect as AnyObject).value(forKey: "balance")! as? String else {
                    return
                }
                guard let mix = (effect as AnyObject).value(forKey: "mix")! as? String else {
                    return
                }
                guard let frequency1 = (effect as AnyObject).value(forKey: "frequency1")! as? String else {
                    return
                }
                guard let frequency2 = (effect as AnyObject).value(forKey: "frequency2")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.ringModulator!.balance = Double(balance)!
                audio.ringModulator!.mix = Double(mix)!
                audio.ringModulator!.frequency1 = Double(frequency1)!
                audio.ringModulator!.frequency2 = Double(frequency2)!
                let started = Bool(isStarted)!
                if started == true {audio.ringModulator!.start()} else {audio.ringModulator!.stop()}
                
            case "flanger" :
                
                guard let frequency = (effect as AnyObject).value(forKey: "frequency")! as? String else {
                    return
                }
                guard let depth = (effect as AnyObject).value(forKey: "depth")! as? String else {
                    return
                }
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.flanger!.frequency = Double(frequency)!
                audio.flanger!.depth = Double(depth)!
                audio.flanger!.feedback = Double(feedback)!
                audio.flanger!.dryWetMix = Double(dryWetMix)!
                let started = Bool(isStarted)!
                if started == true {audio.flanger!.start()} else {audio.flanger!.stop()}
                
            case "phaser" :
                
                guard let notchMinimumFrequency = (effect as AnyObject).value(forKey: "notchMinimumFrequency")! as? String else {
                    return
                }
                guard let notchMaximumFrequency = (effect as AnyObject).value(forKey: "notchMaximumFrequency")! as? String else {
                    return
                }
                guard let notchWidth = (effect as AnyObject).value(forKey: "notchWidth")! as? String else {
                    return
                }
                guard let notchFrequency = (effect as AnyObject).value(forKey: "notchFrequency")! as? String else {
                    return
                }
                guard let vibratoMode = (effect as AnyObject).value(forKey: "vibratoMode")! as? String else {
                    return
                }
                guard let depth = (effect as AnyObject).value(forKey: "depth")! as? String else {
                    return
                }
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                guard let lfoBPM = (effect as AnyObject).value(forKey: "lfoBPM")! as? String else {
                    return
                }
                guard let inverted = (effect as AnyObject).value(forKey: "inverted")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                audio.phaser!.inverted = Double(inverted)!
                audio.phaser!.vibratoMode = Double(vibratoMode)!
                audio.phaser!.notchMinimumFrequency = Double(notchMinimumFrequency)!
                audio.phaser!.notchMaximumFrequency = Double(notchMaximumFrequency)!
                audio.phaser!.notchWidth = Double(notchWidth)!
                audio.phaser!.notchFrequency = Double(notchFrequency)!
                audio.phaser!.depth = Double(depth)!
                audio.phaser!.feedback = Double(feedback)!
                audio.phaser!.lfoBPM = Double(lfoBPM)!
                let started = Bool(isStarted)!
                if started == true {audio.phaser!.start()} else {audio.phaser!.stop()}
                
            case "chorus" :
                
                guard let frequency = (effect as AnyObject).value(forKey: "frequency")! as? String else {
                    return
                }
                guard let depth = (effect as AnyObject).value(forKey: "depth")! as? String else {
                    return
                }
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.chorus!.frequency = Double(frequency)!
                audio.chorus!.depth = Double(depth)!
                audio.chorus!.feedback = Double(feedback)!
                audio.chorus!.dryWetMix = Double(dryWetMix)!
                let started = Bool(isStarted)!
                if started == true {audio.chorus!.start()} else {audio.chorus!.stop()}
                
            case "compressor" :
                
                guard let threshold = (effect as AnyObject).value(forKey: "threshold")! as? String else {
                    return
                }
                guard let headRoom = (effect as AnyObject).value(forKey: "headRoom")! as? String else {
                    return
                }
                guard let attackDuration = (effect as AnyObject).value(forKey: "attackDuration")! as? String else {
                    return
                }
                guard let releaseDuration = (effect as AnyObject).value(forKey: "releaseDuration")! as? String else {
                    return
                }
                
                guard let masterGain = (effect as AnyObject).value(forKey: "masterGain")! as? String else {
                    return
                }
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.compressor!.threshold = Double(threshold)!
                audio.compressor!.headRoom = Double(headRoom)!
                audio.compressor!.attackDuration = Double(attackDuration)!
                audio.compressor!.releaseDuration = Double(releaseDuration)!
                audio.compressor!.masterGain = Double(masterGain)!
                audio.compressor!.dryWetMix = Double(dryWetMix)!
                
                let started = Bool(isStarted)!
                if started == true {audio.compressor!.start()} else {audio.compressor!.stop()}
                
            case "dynamicsProcessor" :
                
                guard let threshold = (effect as AnyObject).value(forKey: "threshold")! as? String else {
                    return
                }
                guard let headRoom = (effect as AnyObject).value(forKey: "headRoom")! as? String else {
                    return
                }
                guard let expansionRatio = (effect as AnyObject).value(forKey: "expansionRatio")! as? String else {
                    return
                }
                guard let expansionThreshold = (effect as AnyObject).value(forKey: "expansionThreshold")! as? String else {
                    return
                }
                
                guard let attackDuration = (effect as AnyObject).value(forKey: "attackDuration")! as? String else {
                    return
                }
                guard let releaseDuration = (effect as AnyObject).value(forKey: "releaseDuration")! as? String else {
                    return
                }
                
                guard let masterGain = (effect as AnyObject).value(forKey: "masterGain")! as? String else {
                    return
                }
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.dynamicsProcessor!.threshold = Double(threshold)!
                audio.dynamicsProcessor!.headRoom = Double(headRoom)!
                audio.dynamicsProcessor!.expansionRatio = Double(expansionRatio)!
                audio.dynamicsProcessor!.expansionThreshold = Double(expansionThreshold)!
                audio.dynamicsProcessor!.attackDuration = Double(attackDuration)!
                audio.dynamicsProcessor!.releaseDuration = Double(releaseDuration)!
                audio.dynamicsProcessor!.masterGain = Double(masterGain)!
                audio.dynamicsProcessor!.dryWetMix = Double(dryWetMix)!
                
                let started = Bool(isStarted)!
                if started == true {audio.dynamicsProcessor!.start()} else {audio.dynamicsProcessor!.stop()}
                
                
            case "dynamicRangeCompressor" :
                
                guard let threshold = (effect as AnyObject).value(forKey: "threshold")! as? String else {
                    return
                }
                
                guard let ratio = (effect as AnyObject).value(forKey: "ratio")! as? String else {
                    return
                }
                
                guard let attackDuration = (effect as AnyObject).value(forKey: "attackDuration")! as? String else {
                    return
                }
                guard let releaseDuration = (effect as AnyObject).value(forKey: "releaseDuration")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.dynamicRangeCompressor!.ratio = Double(ratio)!
                audio.dynamicRangeCompressor!.threshold = Double(threshold)!
                
                audio.dynamicRangeCompressor!.attackDuration = Double(attackDuration)!
                audio.dynamicRangeCompressor!.releaseDuration = Double(releaseDuration)!
                
                
                let started = Bool(isStarted)!
                if started == true {audio.dynamicRangeCompressor!.start()} else {audio.dynamicRangeCompressor!.stop()}
                
            case "reverb" :
                
                
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.reverb!.dryWetMix = Double(dryWetMix)!
                let started = Bool(isStarted)!
                if started == true {audio.reverb!.start()} else {audio.reverb!.stop()}
                
            case "reverb2" :
                
                guard let gain = (effect as AnyObject).value(forKey: "gain")! as? String else {
                    return
                }
                guard let minDelayTime = (effect as AnyObject).value(forKey: "minDelayTime")! as? String else {
                    return
                }
                guard let maxDelayTime = (effect as AnyObject).value(forKey: "maxDelayTime")! as? String else {
                    return
                }
                guard let dryWetMix = (effect as AnyObject).value(forKey: "dryWetMix")! as? String else {
                    return
                }
                guard let decayTimeAt0Hz = (effect as AnyObject).value(forKey: "decayTimeAt0Hz")! as? String else {
                    return
                }
                guard let decayTimeAtNyquist = (effect as AnyObject).value(forKey: "decayTimeAtNyquist")! as? String else {
                    return
                }
                guard let randomizeReflections = (effect as AnyObject).value(forKey: "randomizeReflections")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.reverb2!.gain = Double(gain)!
                audio.reverb2!.minDelayTime = Double(minDelayTime)!
                audio.reverb2!.maxDelayTime = Double(maxDelayTime)!
                audio.reverb2!.decayTimeAt0Hz = Double(decayTimeAt0Hz)!
                audio.reverb2!.decayTimeAtNyquist = Double(decayTimeAtNyquist)!
                audio.reverb2!.randomizeReflections = Double(randomizeReflections)!
                audio.reverb2!.dryWetMix = Double(dryWetMix)!
                let started = Bool(isStarted)!
                if started == true {audio.reverb2!.start()} else {audio.reverb2!.stop()}
                
            case "chowningReverb" :
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                let started = Bool(isStarted)!
                if started == true {audio.chowningReverb!.start()} else {audio.chowningReverb!.stop()}
                
            case "costelloReverb" :
                
                guard let cutoffFrequency = (effect as AnyObject).value(forKey: "cutoffFrequency")! as? String else {
                    return
                }
                
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                
                audio.costelloReverb!.cutoffFrequency = Double(cutoffFrequency)!
                audio.costelloReverb!.feedback = Double(feedback)!
                
                let started = Bool(isStarted)!
                if started == true {audio.costelloReverb!.start()} else {audio.costelloReverb!.stop()}
                
            case "flatFrequencyResponseReverb" :
                
                guard let reverbDuration = (effect as AnyObject).value(forKey: "reverbDuration")! as? String else {
                    return
                }
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.flatFrequencyResponseReverb!.reverbDuration = Double(reverbDuration)!
                
                let started = Bool(isStarted)!
                if started == true {audio.flatFrequencyResponseReverb!.start()} else {audio.flatFrequencyResponseReverb!.stop()}
                
            case "tremolo" :
                
                guard let frequency = (effect as AnyObject).value(forKey: "frequency")! as? String else {
                    return
                }
                guard let depth = (effect as AnyObject).value(forKey: "depth")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.tremolo!.frequency = Double(frequency)!
                audio.tremolo!.depth = Double(depth)!
                
                let started = Bool(isStarted)!
                if started == true {audio.tremolo!.start()} else {audio.tremolo!.stop()}
                
                
                
                
                // FILTERS
                
            case "Equalizer" :
                
                
                guard let eqSelection = (effect as AnyObject).value(forKey: "eqSelection")! as? String else {
                    return
                }
    
                audio.eqSelection = Int(eqSelection)!
                
                if eqSelection == "0" {
                    guard let threeBandFilterHigh = (effect as AnyObject).value(forKey: "threeBandFilterHigh")! as? String else {
                        return
                    }
                    guard let threeBandFilterMid = (effect as AnyObject).value(forKey: "threeBandFilterMid")! as? String else {
                        return
                    }
                    guard let threeBandFilterLow = (effect as AnyObject).value(forKey: "threeBandFilterLow")! as? String else {
                        return
                    }
                    audio.threeBandFilterHigh?.gain = Double(threeBandFilterHigh)!
                    audio.threeBandFilterMid?.gain = Double(threeBandFilterMid)!
                    audio.threeBandFilterLow?.gain = Double(threeBandFilterLow)!
                    
                } else if eqSelection == "1" {
                    guard let sevenBandFilterSubBass = (effect as AnyObject).value(forKey: "sevenBandFilterSubBass")! as? String else {
                        return
                    }
                    guard let sevenBandFilterBass = (effect as AnyObject).value(forKey: "sevenBandFilterBass")! as? String else {
                        return
                    }
                    guard let sevenBandFilterLowMid = (effect as AnyObject).value(forKey: "sevenBandFilterLowMid")! as? String else {
                        return
                    }
                    guard let sevenBandFilterMid = (effect as AnyObject).value(forKey: "sevenBandFilterMid")! as? String else {
                        return
                    }
                    guard let sevenBandFilterUpperMid = (effect as AnyObject).value(forKey: "sevenBandFilterUpperMid")! as? String else {
                        return
                    }
                    guard let sevenBandFilterPrecence = (effect as AnyObject).value(forKey: "sevenBandFilterPrecence")! as? String else {
                        return
                    }
                    guard let sevenBandFilterBrilliance = (effect as AnyObject).value(forKey: "sevenBandFilterBrilliance")! as? String else {
                        return
                    }
                    audio.sevenBandFilterSubBass?.gain = Double(sevenBandFilterSubBass)!
                    audio.sevenBandFilterBass?.gain = Double(sevenBandFilterBass)!
                    audio.sevenBandFilterLowMid?.gain = Double(sevenBandFilterLowMid)!
                    audio.sevenBandFilterMid?.gain = Double(sevenBandFilterMid)!
                    audio.sevenBandFilterUpperMid?.gain = Double(sevenBandFilterUpperMid)!
                    audio.sevenBandFilterPrecence?.gain = Double(sevenBandFilterPrecence)!
                    audio.sevenBandFilterBrilliance?.gain = Double(sevenBandFilterBrilliance)!
                    
                }
                
                
            case "moogLadder" :
                
                guard let cutoffFrequency = (effect as AnyObject).value(forKey: "cutoffFrequency")! as? String else {
                    return
                }
                guard let resonance = (effect as AnyObject).value(forKey: "resonance")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.moogLadder!.cutoffFrequency = Double(cutoffFrequency)!
                audio.moogLadder!.resonance = Double(resonance)!
                
                let started = Bool(isStarted)!
                if started == true {audio.moogLadder!.start()} else {audio.moogLadder!.stop()}
                
            case "resonantFilter" :
                
                guard let frequency = (effect as AnyObject).value(forKey: "frequency")! as? String else {
                    return
                }
                guard let bandwidth = (effect as AnyObject).value(forKey: "bandwidth")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.resonantFilter!.frequency = Double(frequency)!
                audio.resonantFilter!.bandwidth = Double(bandwidth)!
                
                let started = Bool(isStarted)!
                if started == true {audio.resonantFilter!.start()} else {audio.resonantFilter!.stop()}
                
            case "stringResonator" :
                
                guard let fundamentalFrequency = (effect as AnyObject).value(forKey: "fundamentalFrequency")! as? String else {
                    return
                }
                guard let feedback = (effect as AnyObject).value(forKey: "feedback")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.stringResonator!.fundamentalFrequency = Double(fundamentalFrequency)!
                audio.stringResonator!.feedback = Double(feedback)!
                
                let started = Bool(isStarted)!
                if started == true {audio.stringResonator!.start()} else {audio.stringResonator!.stop()}
                
            case "modalResonanceFilter" :
                
                guard let frequency = (effect as AnyObject).value(forKey: "frequency")! as? String else {
                    return
                }
                guard let qualityFactor = (effect as AnyObject).value(forKey: "qualityFactor")! as? String else {
                    return
                }
                
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
                
                audio.modalResonanceFilter!.frequency = Double(frequency)!
                audio.modalResonanceFilter!.qualityFactor = Double(qualityFactor)!
                
                let started = Bool(isStarted)!
                if started == true {audio.modalResonanceFilter!.start()} else {audio.modalResonanceFilter!.stop()}
                
                
                /*
                 case "equalizerFilter" :
                 guard let gain1 = (effect as AnyObject).value(forKey: "gain1")! as? String else {
                 return
                 }
                 guard let gain2 = (effect as AnyObject).value(forKey: "gain2")! as? String else {
                 return
                 }
                 guard let gain3 = (effect as AnyObject).value(forKey: "gain3")! as? String else {
                 return
                 }
                 guard let gain4 = (effect as AnyObject).value(forKey: "gain4")! as? String else {
                 return
                 }
                 guard let gain5 = (effect as AnyObject).value(forKey: "gain5")! as? String else {
                 return
                 }
                 guard let gain6 = (effect as AnyObject).value(forKey: "gain6")! as? String else {
                 return
                 }
                 guard let gain7 = (effect as AnyObject).value(forKey: "gain7")! as? String else {
                 return
                 }
                 guard let gain8 = (effect as AnyObject).value(forKey: "gain8")! as? String else {
                 return
                 }
                 guard let gain9 = (effect as AnyObject).value(forKey: "gain9")! as? String else {
                 return
                 }
                 guard let gain10 = (effect as AnyObject).value(forKey: "gain10")! as? String else {
                 return
                 }
                 
                 guard let gain11 = (effect as AnyObject).value(forKey: "gain11")! as? String else {
                 return
                 }
                 guard let gain12 = (effect as AnyObject).value(forKey: "gain12")! as? String else {
                 return
                 }
                 guard let gain13 = (effect as AnyObject).value(forKey: "gain13")! as? String else {
                 return
                 }
                 guard let gain14 = (effect as AnyObject).value(forKey: "gain14")! as? String else {
                 return
                 }
                 guard let gain15 = (effect as AnyObject).value(forKey: "gain15")! as? String else {
                 return
                 }
                 guard let gain16 = (effect as AnyObject).value(forKey: "gain16")! as? String else {
                 return
                 }
                 guard let gain17 = (effect as AnyObject).value(forKey: "gain17")! as? String else {
                 return
                 }
                 guard let gain18 = (effect as AnyObject).value(forKey: "gain18")! as? String else {
                 return
                 }
                 guard let gain19 = (effect as AnyObject).value(forKey: "gain19")! as? String else {
                 return
                 }
                 guard let gain20 = (effect as AnyObject).value(forKey: "gain20")! as? String else {
                 return
                 }
                 
                 guard let gain21 = (effect as AnyObject).value(forKey: "gain21")! as? String else {
                 return
                 }
                 guard let gain22 = (effect as AnyObject).value(forKey: "gain22")! as? String else {
                 return
                 }
                 guard let gain23 = (effect as AnyObject).value(forKey: "gain23")! as? String else {
                 return
                 }
                 guard let gain24 = (effect as AnyObject).value(forKey: "gain24")! as? String else {
                 return
                 }
                 guard let gain25 = (effect as AnyObject).value(forKey: "gain25")! as? String else {
                 return
                 }
                 guard let gain26 = (effect as AnyObject).value(forKey: "gain26")! as? String else {
                 return
                 }
                 guard let gain27 = (effect as AnyObject).value(forKey: "gain27")! as? String else {
                 return
                 }
                 guard let gain28 = (effect as AnyObject).value(forKey: "gain28")! as? String else {
                 return
                 }
                 guard let gain29 = (effect as AnyObject).value(forKey: "gain29")! as? String else {
                 return
                 }
                 guard let gain30 = (effect as AnyObject).value(forKey: "gain30")! as? String else {
                 return
                 }
                 guard let gain31 = (effect as AnyObject).value(forKey: "gain31")! as? String else {
                 return
                 }
                 
                 audio.equalizerFilter1?.gain = Double(gain1)!
                 audio.equalizerFilter2?.gain = Double(gain2)!
                 audio.equalizerFilter3?.gain = Double(gain3)!
                 audio.equalizerFilter4?.gain = Double(gain4)!
                 audio.equalizerFilter5?.gain = Double(gain5)!
                 audio.equalizerFilter6?.gain = Double(gain6)!
                 audio.equalizerFilter7?.gain = Double(gain7)!
                 audio.equalizerFilter8?.gain = Double(gain8)!
                 audio.equalizerFilter9?.gain = Double(gain9)!
                 audio.equalizerFilter10?.gain = Double(gain10)!
                 
                 audio.equalizerFilter11?.gain = Double(gain11)!
                 audio.equalizerFilter12?.gain = Double(gain12)!
                 audio.equalizerFilter13?.gain = Double(gain13)!
                 audio.equalizerFilter14?.gain = Double(gain14)!
                 audio.equalizerFilter15?.gain = Double(gain15)!
                 audio.equalizerFilter16?.gain = Double(gain16)!
                 audio.equalizerFilter17?.gain = Double(gain17)!
                 audio.equalizerFilter18?.gain = Double(gain18)!
                 audio.equalizerFilter19?.gain = Double(gain19)!
                 audio.equalizerFilter20?.gain = Double(gain20)!
                 
                 audio.equalizerFilter21?.gain = Double(gain21)!
                 audio.equalizerFilter22?.gain = Double(gain22)!
                 audio.equalizerFilter23?.gain = Double(gain23)!
                 audio.equalizerFilter24?.gain = Double(gain24)!
                 audio.equalizerFilter25?.gain = Double(gain25)!
                 audio.equalizerFilter26?.gain = Double(gain26)!
                 audio.equalizerFilter27?.gain = Double(gain27)!
                 audio.equalizerFilter28?.gain = Double(gain28)!
                 audio.equalizerFilter29?.gain = Double(gain29)!
                 audio.equalizerFilter30?.gain = Double(gain30)!
                 audio.equalizerFilter31?.gain = Double(gain31)!
                 
                 */
                
                
            default : print("NOTHIN HERE")
                
            }
            
        }
        
        // TODO tarviiko ei käytössä olevat laittaa erikseen pois päältä
        
        
        rearrangeLists()
        
    }
    

    
    
    
    
    
    
    
    
    
    
    
    
    /*
 func createEQDataArray() -> [String: String] {
 var array = [String: String]()
 array.updateValue("equalizerFilter", forKey: "name")
 array.updateValue(String(audio.equalizerFilter1!.gain), forKey: "gain1")
 array.updateValue(String(audio.equalizerFilter2!.gain), forKey: "gain2")
 array.updateValue(String(audio.equalizerFilter3!.gain), forKey: "gain3")
 array.updateValue(String(audio.equalizerFilter4!.gain), forKey: "gain4")
 array.updateValue(String(audio.equalizerFilter5!.gain), forKey: "gain5")
 array.updateValue(String(audio.equalizerFilter6!.gain), forKey: "gain6")
 array.updateValue(String(audio.equalizerFilter7!.gain), forKey: "gain7")
 array.updateValue(String(audio.equalizerFilter8!.gain), forKey: "gain8")
 array.updateValue(String(audio.equalizerFilter9!.gain), forKey: "gain9")
 array.updateValue(String(audio.equalizerFilter10!.gain), forKey: "gain10")
 array.updateValue(String(audio.equalizerFilter11!.gain), forKey: "gain11")
 array.updateValue(String(audio.equalizerFilter12!.gain), forKey: "gain12")
 array.updateValue(String(audio.equalizerFilter13!.gain), forKey: "gain13")
 array.updateValue(String(audio.equalizerFilter14!.gain), forKey: "gain14")
 array.updateValue(String(audio.equalizerFilter15!.gain), forKey: "gain15")
 array.updateValue(String(audio.equalizerFilter16!.gain), forKey: "gain16")
 array.updateValue(String(audio.equalizerFilter17!.gain), forKey: "gain17")
 array.updateValue(String(audio.equalizerFilter18!.gain), forKey: "gain18")
 array.updateValue(String(audio.equalizerFilter19!.gain), forKey: "gain19")
 array.updateValue(String(audio.equalizerFilter20!.gain), forKey: "gain20")
 array.updateValue(String(audio.equalizerFilter21!.gain), forKey: "gain21")
 array.updateValue(String(audio.equalizerFilter22!.gain), forKey: "gain22")
 array.updateValue(String(audio.equalizerFilter23!.gain), forKey: "gain23")
 array.updateValue(String(audio.equalizerFilter24!.gain), forKey: "gain24")
 array.updateValue(String(audio.equalizerFilter25!.gain), forKey: "gain25")
 array.updateValue(String(audio.equalizerFilter26!.gain), forKey: "gain26")
 array.updateValue(String(audio.equalizerFilter27!.gain), forKey: "gain27")
 array.updateValue(String(audio.equalizerFilter28!.gain), forKey: "gain28")
 array.updateValue(String(audio.equalizerFilter29!.gain), forKey: "gain29")
 array.updateValue(String(audio.equalizerFilter30!.gain), forKey: "gain30")
 array.updateValue(String(audio.equalizerFilter31!.gain), forKey: "gain31")
 
 return array
 }

 */
    
    
    
    
    
}
