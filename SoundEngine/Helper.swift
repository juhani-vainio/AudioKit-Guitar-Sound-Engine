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
    
    func saveEffectChain(name: String) {
    
        var dictionary = [[String:String]]()
        
        for effect in audio.selectedEffectsData {
            let array = createEffectDataArray(effect: effect, location: "selectedEffectsData")
            if array.isNotEmpty {
                dictionary.append(array)
            }
        }
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
            
            
            
            
            
        // TODO lisää filtterit
            
            
            
            
            
        default : print("addToDictionaryToSave default hmmm?")
            
        }
        return array
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
    
    func replaceEffectDataArrays(name: String, location: String) {
        
        print("Place \(name) to \(location)")
        // get interface relevant data and place to relevant lists
        if audio.allPossibleEffectsData.contains(where: {$0.id == name}) {
            print("allPossibleEffectsData.contains \(name)")
            if let thisEffectData = audio.allPossibleEffectsData.first(where: {$0.id == name}) {
                print("this effects \(thisEffectData)")
                switch location {
                    case "selectedEffectsData" : audio.selectedEffectsData.append(thisEffectData)
                    //case "selectedUnitsAfterData" : audio.selectedUnitsAfterData.append(thisEffectData)
                    //TODO add filters
                    default :  audio.selectedEffectsData.append(thisEffectData)
                }
            }
            else {
                // item could not be found
            }
        }
        
    }
    
    func rearrangeLists() {
        
        // add unused effects to the list of available effects
        for effect in audio.allPossibleEffectsData {
            if audio.selectedEffectsData.contains(where: {$0.id == effect.id})   {
                
            }
            /*else if audio.selectedUnitsAfterData.contains(where: {$0.id == effect.id})   {
                
            }
 */
            else {
                audio.availableEffectsData.append(effect)
            }
        }
    }
    
    
    
    func setValuesForReceivedChain(valuesForChain: [Any]) {
        print("setValuesForReceivedChain")
        print(valuesForChain)
        audio.selectedEffectsData.removeAll()
       // audio.selectedUnitsAfterData.removeAll()
        audio.availableEffectsData.removeAll()
        for effect in valuesForChain {
            let name:String = (effect as AnyObject).value(forKey: "name") as! String
            let location:String = (effect as AnyObject).value(forKey: "location") as! String
            // tyhjennä listat ennen lisäystä....
           
            replaceEffectDataArrays(name:name, location:location)
            
            switch name {
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
                guard let isStarted = (effect as AnyObject).value(forKey: "isStarted")! as? String else {
                    return
                }
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
                
                
            default : print("NOTHIN HERE")
                
            }
            
        }
        
         // TODO tarviiko ei käytössä olevat laittaa erikseen pois päältä
        
        
      rearrangeLists()
        
    }
    

    
    func getSavedChain(name: String) {
        
        if name == "activeSound" {
            print("Get values for \(name)")
            let chainArray = UserDefaults.standard.array(forKey: name) ?? [[String:String]]()
            if chainArray.isNotEmpty{
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
            let array = createEffectDataArray(effect: effect, location: "selectedEffectsData")
            if array.isNotEmpty{
                dictionary.append(array)
            }
            
        }
        /*
        for effect in audio.selectedUnitsAfterData {
            let array = createEffectDataArray(effect: effect, location: "selectedUnitsAfterData")
            if array.isNotEmpty{
                dictionary.append(array)
            }
        }
        
         for effect in audio.finalFiltersData {
         let array = createEffectDataArray(effect: effect, location: "finalFiltersData")
         dictionary.append(array)
         }
         */
      
        UserDefaults.standard.set(dictionary, forKey: "activeSound")
        
        
    }
 
    func checkUserDefaults() {
        
        print("checkUserDefaults")
        
        let savedBufferLength = UserDefaults.standard.integer(forKey: "bufferLength")
        if savedBufferLength != 0 {
            settings.bufferLenght = savedBufferLength
        }
        
        // all saved sounds
        let savedSounds = UserDefaults.standard.stringArray(forKey: "savedSounds")  ?? [String]()
        if savedSounds.isNotEmpty {
            print("savedSOunds is NOT empty")
            Collections.savedSounds = savedSounds
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
    
    
}
