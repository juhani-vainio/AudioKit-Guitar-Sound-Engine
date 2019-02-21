//
//  Audio.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 04/02/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

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
    
    static var availableEffectsData = [effectData]()
    
    static var selectedEffectsData = [effectData]()
    
    static var availableFiltersData = [effectData]()
    
    static var selectedFiltersData = [effectData]()
    
    static let shared = audio()
    
    static var bufferLength = Int()
    
    static let persistentUnitsData =  [// EQUALIZER 7 BAND
        effectData(id: "Equalizer", opened: false, title: "EQUALIZER", type: "Equalizer"), // Bass , Mid, High
    ]
    
    static let allPossibleEffectsData = [
        // DISTORTIONS
      //  effectData(id: "clipper",opened: false, title: "Clipper", type: "1"),
       // effectData(id: "bitCrusher", opened: false, title: "Bit CRUSHER", type: "2"),
       // effectData(id: "decimator" ,opened: false, title: "Decimator", type: "3"),
      //  effectData(id: "tanhDistortion", opened: false, title: "Tanh Distortion", type: "4"),
      //  effectData(id: "ringModulator", opened: false, title: "Ring Modulator", type: "4"),
    //    effectData(id: "distortion", opened: false, title: "Distortion Unit", type: "8"),
        

        
        // DYNAMICS
    //    effectData(id: "dynamicRangeCompressor" ,opened: false, title: "Dynamic Range Compressor", type: "4"),
     //   effectData(id: "compressor", opened: false, title: "Compressor", type: "6"), // TODO: SOme weird bug when disconnecting :     SoundEngine[6362:1672408] AUBase.cpp:1445:DoRender:  ca_require: IsInitialized() Uninitialized
       // effectData(id: "dynamicsProcessor" ,opened: false, title: "Dynamics Processor", type: "8"),
        // missing dynamics: TODO
        // AKExpander
        // AKPeakLimiter
        
        effectData(id: "autoWah" , opened: false, title: "WAH WAH!", type: "3"),
        effectData(id: "phaser" ,opened: false, title: "PHASER", type: "8"),
        
        // DYNA RAGE PROCESSOR
        effectData(id: "dynaRageCompressor", opened: false, title: "RAGE", type: "5"),
        
        // GUITAR PROCESSOR
        effectData(id: "rhinoGuitarProcessor", opened: false, title: "DISTORTION", type: "3"),
       
        // MODULATION
        effectData(id: "chorus" ,opened: false, title: "CHORUS", type: "4"),
        effectData(id: "flanger" ,opened: false, title: "FLANGER", type: "4"),
        

        // ENVELOPE
        effectData(id: "tremolo" ,opened: false, title: "TREMOLO", type: "2"),
      //  effectData(id: "booster" ,opened: false, title: "BOOSTER", type: "1"),
        
        
        // DELAY
        effectData(id: "delay", opened: false, title: "DELAY", type: "3"),
        
        // REVERB
        //effectData(id: "costelloReverb" ,opened: false, title: "REVERB ", type: "2"),
        // effectData(id: "reverb" ,opened: false, title: "REVERB", type: "1"),
          effectData(id: "reverb2" ,opened: false, title: "Reverb 2", type: "7"),
        //  effectData(id: "chowningReverb" ,opened: false, title: "Reverb Chowning", type: "0"),
        //  effectData(id: "flatFrequencyResponseReverb" ,opened: false, title: "Flat Freq Response Reverb", type: "1"),
        
        
        // BONUS
        //  effectData(id: "moogLadder", opened: false, title: "Moog Ladder", type: "2"),
        // effectData(id: "resonantFilter", opened: false, title: "Resonant Filter", type: "2"),
        // effectData(id: "stringResonator", opened: false, title: "String Resonator", type: "2"),
        //   effectData(id: "modalResonanceFilter", opened: false, title: "Modal Resonance", type: "2"),
        //   effectData(id: "highLowPassFilters", opened: false, title: "High & Low Pass Filters", type: "PassFilters"), // add switch for FLAT as in butterworth for the pass filters
    ]
    
    
    static let allPossibleFiltersData = [effectData]()
        
    

        
        
        
    
    

    func startAudio() {
        
        createInputListForSound()
        connectMic()
        connectAudioInputs()
      
    }
    
    func connectAudioInputs() {
        
       // print(AudioKit.printConnections())
        
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
        outputMixer?.connect(to: audio.outputBooster!)
       
        audio.outputBooster?.connect(to: outputAmplitudeTracker!)
        
        // LAST TO OUTPUT
        AudioKit.output = outputAmplitudeTracker
        if AudioKit.output == nil {
            AudioKit.output =  audio.inputBooster
            // AudioKit.output = inputMixer
        }
        
       // print(AudioKit.printConnections())
        
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
        
        
       // print(AudioKit.printConnections())
        
        
    }
    
 
    func resetAudioEffects() {
 
        
        audio.selectedAudioInputs.removeAll()
        
        do {
            try AudioKit.shutdown()
            print("----------------- AudioKit  SHUTDOWN -----------------")
        } catch {
            print("----------------- Could not SHUTDOWN AudioKit -----------------")
        }

    }
    
    func addToselectedEffects(id : String) {
        switch id {
        //effects
        case "booster" : audio.selectedAudioInputs.append(audio.booster!)
        case "bitCrusher" : audio.selectedAudioInputs.append(audio.bitCrusher!)
        case "clipper" : audio.selectedAudioInputs.append(audio.clipper!)
        case "dynaRageCompressor":  audio.selectedAudioInputs.append(audio.dynaRageCompressor!)
        case "autoWah":  audio.selectedAudioInputs.append(audio.autoWah!)
        case "delay":  audio.selectedAudioInputs.append(audio.delay!)
        case "variableDelay": audio.selectedAudioInputs.append(audio.variableDelay!)
        case "decimator": audio.selectedAudioInputs.append(audio.decimator!)
        case "tanhDistortion": audio.selectedAudioInputs.append(audio.tanhDistortion!)
        case "ringModulator": audio.selectedAudioInputs.append(audio.ringModulator!)
        case "distortion": audio.selectedAudioInputs.append(audio.distortion!)
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
        audio.selectedAudioInputs.append(audio.toneComplementFilter!)
        case "moogLadder": audio.selectedAudioInputs.append(audio.moogLadder!)
        case "rhinoGuitarProcessor": audio.selectedAudioInputs.append(audio.rhinoGuitarProcessor!)
            audio.selectedAudioInputs.append(audio.rhinoBooster!)
        case "highLowPassFilters":  audio.selectedAudioInputs.append(audio.lowPassFilter!)
        audio.selectedAudioInputs.append(audio.lowPassButterworthFilter!)
        audio.selectedAudioInputs.append(audio.highPassFilter!)
        audio.selectedAudioInputs.append(audio.highPassButterworthFilter!)
        case "resonantFilter":      audio.selectedAudioInputs.append(audio.resonantFilter!)
        case "stringResonator":     audio.selectedAudioInputs.append(audio.stringResonator!)
        case "modalResonanceFilter": audio.selectedAudioInputs.append(audio.modalResonanceFilter!)
        case "dcBlock":             audio.selectedAudioInputs.append(audio.dcBlock!)
        default : print("NOTHING to do over HERE")
        }
    }
    
    
    func turnOn(id: String){
       
        switch id {
            
        case "booster" :
            
            audio.booster!.start()
            
        case "bitCrusher" :
            
           audio.bitCrusher!.start()
            
            
        case "tanhDistortion" :
            
           audio.tanhDistortion!.start()
            
        case "clipper" :
            
            audio.clipper!.start()
            
            
            
            
        case "dynaRageCompressor" :
            
            audio.dynaRageCompressor!.start()
            
            
        case "autoWah" :
            
           audio.autoWah!.start()
            
            
        case "delay" :
            
         audio.delay!.start()
            
            
        case "variableDelay" :
            
            audio.variableDelay!.start()
            
            
            
        case "decimator" :
            
           audio.decimator!.start()
            
            
            
        case "ringModulator" :
            
           audio.ringModulator!.start()
            
        case "distortion" :
            audio.distortion!.start()
            
        case "flanger" :
            
           audio.flanger!.start()
            
            
        case "phaser" :
            
            audio.phaser!.start()
            
            
        case "chorus" :
            
            audio.chorus!.start()
            
            
        case "compressor" :
            
            audio.compressor!.start()
            
            
        case "dynamicsProcessor" :
            
            audio.dynamicsProcessor!.start()
            
        case "dynamicRangeCompressor" :
            
            audio.dynamicRangeCompressor!.start()
            
            
        case "reverb" :
            
            audio.reverb!.start()
            
            
        case "reverb2" :
            
           audio.reverb2!.start()
            
            
        case "chowningReverb" :
            
           audio.chowningReverb!.start()
        case "costelloReverb" :
            
            audio.costelloReverb!.start()
            
            
        case "flatFrequencyResponseReverb" :
            
            audio.flatFrequencyResponseReverb!.start()
            
        case "tremolo" :
            
            audio.tremolo!.start()
            
            
            
            // FILTERS
            
        case "Equalizer" :
            audio.sevenBandFilterBrilliance!.start()
            audio.sevenBandFilterPrecence!.start()
            audio.sevenBandFilterUpperMid!.start()
            audio.sevenBandFilterMid!.start()
            audio.sevenBandFilterLowMid!.start()
            audio.sevenBandFilterBass!.start()
            audio.sevenBandFilterSubBass!.start()
         
            
        case "moogLadder" :
            
            audio.moogLadder!.start()
            
        case "rhinoGuitarProcessor" :
            
           audio.rhinoGuitarProcessor!.start()
            audio.rhinoBooster?.dB = audio.rhinoBoosterDBValue
            
            
        case "resonantFilter" :
            
            audio.resonantFilter!.start()
            
            
        case "stringResonator" :
            
            audio.stringResonator!.start()
            
            
        case "modalResonanceFilter" :
            
            audio.modalResonanceFilter!.start()
            
            
        case "toneFilters" :
            
            audio.toneFilter!.start()
            
            
            
        case "dcBlock" :
            
            audio.dcBlock!.start()
            
        default : print("this errors")
            
        }
        

        
    }
    
    
    
    // BALANCERS
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
    
    var frequencyTracker : AKFrequencyTracker?
    
    var inputMixer: AKMixer?
    var mixerForFirstList: AKMixer?
    var mixerForSecondList: AKMixer?
    var mixerForThirdList: AKMixer?
    var outputMixer: AKMixer?
    
    
    var filterMixer: AKMixer?
    
    var mic: AKMicrophone?
    static var outputBooster : AKBooster?
    static var inputBooster : AKBooster?

    
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
    static var distortion: AKDistortion?
    
    // BOOSTER
    static var booster : AKBooster?
    
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
    static var rhinoBooster: AKBooster?
    static var rhinoBoosterDBValue = Double()
    
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
    
    static var highPassFilter : AKHighPassFilter?
    static var lowPassFilter: AKLowPassFilter?
    static var lowPassButterworthFilter: AKLowPassButterworthFilter?
    static var highPassButterworthFilter: AKHighPassButterworthFilter?
    static var lowPassIsStarted = Bool()
    static var highPassIsStarted = Bool()
    static var lowPassSegment = Int()
    static var highPassSegment = Int()
    static var toneFilter: AKToneFilter?
    static var toneComplementFilter : AKToneComplementFilter?
    static var highShelfFilter : AKHighShelfFilter?
    static var lowShelfFilter: AKLowShelfFilter?
    static var bandPassButterworthFilter : AKBandPassButterworthFilter?
    static var bandRejectButterworthFilter : AKBandRejectButterworthFilter?
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
    static var dcBlock: AKDCBlock?
    static var stringResonator : AKStringResonator?
    static var masterBooster: AKBooster?
    
   
    // ARRAYS FOR CONSTRUCTING THE SOUND
    
    static var selectedAudioInputs = [AKInput]()
    
    func createEffects() {
 
        // MONITORS
        outputAmplitudeTracker = AKAmplitudeTracker()
        inputAmplitudeTracker = AKAmplitudeTracker()
        micTracker = AKMicrophoneTracker()
        
        frequencyTracker = AKFrequencyTracker()
        frequencyTracker?.start()
        
        // MIC
        mic = AKMicrophone()
        
        // boosters
        audio.booster = AKBooster()
        audio.outputBooster = AKBooster()
        audio.inputBooster = AKBooster()
     
        
        
        audio.masterBooster = AKBooster()
        //audio.masterBooster?.start()
        
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
        audio.distortion = AKDistortion()
        
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
        audio.rhinoBooster = AKBooster()
        
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
        
        audio.highPassFilter = AKHighPassFilter()
        audio.lowPassFilter = AKLowPassFilter()
        
       
        

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
        
        
        // start essential units
        
        outputAmplitudeTracker?.start()
        micTracker?.start()
        
        //Booster
       // audio.booster?.start()
        audio.outputBooster?.start()
        audio.inputBooster?.start()
        
        //inputMixer?.start()
        outputMixer?.start()
        
        
        
        
        // stop all effects
        
        audio.booster?.stop()
        
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
        audio.clipper?.limit = 0.1
        audio.clipper?.stop()
        audio.tanhDistortion?.stop()
        audio.decimator?.stop()
        audio.ringModulator?.stop()
        audio.distortion?.stop()
        
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
        audio.rhinoBoosterDBValue = (audio.rhinoBooster?.dB)!
        audio.rhinoBooster?.dB = 0
        
        // tremolo
        audio.tremolo?.stop()
        
        // FILTERS
        audio.autoWah?.stop()
        
        audio.toneFilter?.stop()
        audio.toneComplementFilter?.stop()
        
        audio.dcBlock?.stop()
        audio.resonantFilter?.stop()
        audio.moogLadder?.stop()
        audio.resonantFilter?.stop()
        audio.stringResonator?.stop()
        audio.modalResonanceFilter?.stop()
        
        // PASS FILTERS
        audio.highPassButterworthFilter?.cutoffFrequency = audio.highPassFilter!.cutoffFrequency
        audio.lowPassButterworthFilter?.cutoffFrequency = audio.lowPassFilter!.cutoffFrequency
        audio.highPassFilter?.stop()
        audio.lowPassFilter?.stop()
        audio.highPassButterworthFilter?.stop()
        audio.lowPassButterworthFilter?.stop()
        audio.highPassSegment = 0
        audio.highPassIsStarted = false
        audio.lowPassSegment = 0
        audio.lowPassIsStarted = false
        
    }
    
    func stopAll() {
        
      //  inputMixer?.stop()
      //  outputMixer?.stop()
        
      //  mic?.stop()
      //  outputBooster?.stop()
      //  inputBooster?.stop()
        
        //BOOSTER
        audio.booster?.stop()
        
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
        audio.distortion?.stop()
        
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
        audio.rhinoBoosterDBValue = (audio.rhinoBooster?.dB)!
        audio.rhinoBooster?.dB = 0
        
        // tremolo
        audio.tremolo?.stop()
        
        // FILTERS
        audio.autoWah?.stop()
        
        audio.toneFilter?.stop()
        audio.toneComplementFilter?.stop()
        
        audio.dcBlock?.stop()
        audio.resonantFilter?.stop()
        audio.moogLadder?.stop()
        audio.resonantFilter?.stop()
        audio.stringResonator?.stop()
        audio.modalResonanceFilter?.stop()
        
        // PASS FILTERS
        
        audio.highPassFilter?.stop()
        audio.lowPassFilter?.stop()
        audio.highPassButterworthFilter?.stop()
        audio.lowPassButterworthFilter?.stop()
        
        audio.threeBandFilterHigh?.stop()
        audio.threeBandFilterMid?.stop()
        audio.threeBandFilterLow?.stop()
        
        audio.sevenBandFilterBrilliance?.stop()
        audio.sevenBandFilterPrecence?.stop()
        audio.sevenBandFilterUpperMid?.stop()
        audio.sevenBandFilterMid?.stop()
        audio.sevenBandFilterLowMid?.stop()
        audio.sevenBandFilterBass?.stop()
        audio.sevenBandFilterSubBass?.stop()
    }
    
    func createInputListForSound() {
        // EFFECTS
        for effect in 0..<audio.allPossibleEffectsData.count {
            let id = audio.allPossibleEffectsData[effect].id
            
            addToselectedEffects(id:id)
            
        }
       // addToselectedEffects(id:"Equalizer")
        
        // PERSISTENT UNITS
        for effect in 0..<audio.persistentUnitsData.count {
            let id = audio.persistentUnitsData[effect].id
            addToselectedEffects(id:id)
        }
 
        /*
        // FILTERS
        for effect in 0..<audio.allPossibleFiltersData.count {
            let id = audio.allPossibleFiltersData[effect].id
            addToselectedEffects(id:id)
        }
         */
    }
    
    
    /*
    func createInputListForSound() {
        // EFFECTS
        for effect in 0..<audio.selectedEffectsData.count {
            let id = audio.selectedEffectsData[effect].id
            
            addToselectedEffects(id:id)
            
        }
        // FILTERS
        for effect in 0..<audio.selectedFiltersData.count {
            let id = audio.selectedFiltersData[effect].id
            addToselectedEffects(id:id)
        }
        
    }
    */
    
    
    func connectMic() {
        mic?.connect(to: frequencyTracker!)
        frequencyTracker?.connect(to: audio.inputBooster!)
        audio.inputBooster?.connect(to: inputAmplitudeTracker!)
    }
    
    func updateTrackerUI() -> (note: String, direction: Float) {
        var note = ""
        var direction: Float = 0.0
        if self.frequencyTracker!.amplitude > 0.1 {
            let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
            let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
           // let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
            var frequency = Float(self.frequencyTracker!.frequency)
            while (frequency > Float(noteFrequencies[noteFrequencies.count-1])) {
                frequency = frequency / 2.0
            }
            while (frequency < Float(noteFrequencies[0])) {
                frequency = frequency * 2.0
            }
            
            var minDistance: Float = 10000.0
            var index = 0
            
            for i in 0..<noteFrequencies.count {
                let absoluteDistance = fabsf(Float(noteFrequencies[i]) - frequency)
                let distance = Float(noteFrequencies[i]) - frequency
                if (absoluteDistance < minDistance){
                    index = i
                    minDistance = absoluteDistance
                    direction = distance
                }
            }
            let octave = Int(log2f(Float(self.frequencyTracker!.frequency) / frequency))
            note = noteNamesWithSharps[index] + String(octave)
            //print("\(noteNamesWithSharps[index])\(octave)")
            
            
        }
        return (note, direction)
    }
    
    func ratioToDecibel(ratio: Double) -> Double {
        let dB = 20 * log10(ratio)
        return dB
    }
    
    func decibelToRatio(dB:Double) -> Double {
        let ratio = 10 ^ Int((dB/20))
        return Double(ratio)
    }
    
    func convertWithBooster(gain: Double) -> Float {
        let booster = AKBooster()
        booster.gain = gain
        return Float(booster.dB)
    }
    
    func turnUpVolume() {
        
        let timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            print("Waiting for audiokit to start... .... .....")
            if AudioKit.engine.isRunning {
                sleep(1)
                self.mic?.volume = self.micVolume
                //self.initialStart = false
                print("Audiokit did start ! !! !!!")
                timer.invalidate()
            }
            
        }
        timer.fire()
        
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
        
        AKSettings.defaultToSpeaker = false      // Whether to output to the speaker (rather than receiver) when audio input is enabled
        
        AKSettings.useBluetooth = true          // Whether to use bluetooth when audio input is enabled
        
        AKSettings.bluetoothOptions = .mixWithOthers
        
        AKSettings.allowAirPlay = true
        
        AKSettings.notificationsEnabled = false
        
        AKSettings.recordingBufferLength = .veryLong
        
        print("headPhonesPlugged")
        print(AKSettings.headPhonesPlugged)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
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
            
        default:
            break
        }
    }
    
    func convertToPercent(value: Double, max: Double, min: Double) -> String {
        var text = String()
            var percent = value * 100 / (max + abs(min))
            percent = round(percent)
            text = String(percent).dropLast(2) + "%"
     
        return text
    }
    
    func changeEQValues(slider: String, value: Double) -> String {
        var newValue = String()
        let min = Double(0)
        let max = Double(3)
        switch slider {
            
        case "threeBandHighSlider":
            audio.threeBandFilterHigh?.gain = value
            
        case "threeBandMidSlider":
            audio.threeBandFilterMid?.gain = value
         
        case "threeBandLowSlider":
            audio.threeBandFilterLow?.gain = value
            
        case "sevenBandBrillianceSlider":
            audio.sevenBandFilterBrilliance?.gain = value
           
        case "sevenBandPrecenceSlider":
            audio.sevenBandFilterPrecence?.gain = value
           
        case "sevenBandUpperMidSlider":
            audio.sevenBandFilterUpperMid?.gain = value
            
        case "sevenBandMidSlider":
            audio.sevenBandFilterMid?.gain = value
           
        case "sevenBandLowMidSlider":
            audio.sevenBandFilterLowMid?.gain = value
           
        case "sevenBandBassSlider":
            audio.sevenBandFilterBass?.gain = value
           
        case "sevenBandSubBassSlider":
            audio.sevenBandFilterSubBass?.gain = value
            
            
        default: break
            
        }
        
        newValue = convertToPercent(value: value, max: max, min: min)
        
        return newValue
    }
    
    func getEQ(id: String, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String) {
        let min = Double(0)
        let max = Double(3)
        var valueForSlider = Float(0.69)
        var value = ""
        switch id {
        case "threeBandFilter":
            
            switch slider {
            case 1:
                valueForSlider = Float(audio.threeBandFilterHigh!.gain)
                
            case 2:
                valueForSlider = Float(audio.threeBandFilterMid!.gain)
              
            case 3:
                valueForSlider = Float(audio.threeBandFilterLow!.gain)
               
            default: break
            }
        case "sevenBandFilter":
            
            switch slider {
            case 1:
                valueForSlider = Float(audio.sevenBandFilterBrilliance!.gain)
                
            case 2:
                valueForSlider = Float(audio.sevenBandFilterPrecence!.gain)
               
            case 3:
                valueForSlider = Float(audio.sevenBandFilterUpperMid!.gain)
                
            case 4:
                valueForSlider = Float(audio.sevenBandFilterMid!.gain)
               
            case 5:
                valueForSlider = Float(audio.sevenBandFilterLowMid!.gain)
               
            case 6:
                valueForSlider = Float(audio.sevenBandFilterBass!.gain)
               
            case 7:
                valueForSlider = Float(audio.sevenBandFilterSubBass!.gain)
               
            default: break
            }
            
        default: break
        }
        
        value = convertToPercent(value: Double(valueForSlider), max: min, min: max)
        
        return (Float(min), Float(max), valueForSlider, value)
    }
    
   
    
    
    
    
    
    func changeValues(id: String, slider: Int, value: Double) -> String {
        var newValue = String()
        var min = Double()
        var max = Double()
        switch id {
            
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.toneComplementFilter?.halfPowerPoint = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
                
            default: break
                
            }
            
        case "rhinoGuitarProcessor" :
           
            switch slider {
   
            case 0:
                if  audio.rhinoGuitarProcessor!.isStarted == true {
                    audio.rhinoGuitarProcessor?.stop()
                   // audio.rhinoBoosterDBValue = (audio.rhinoBooster?.dB)!
                    audio.rhinoBooster?.dB = 0
                   
                    newValue = "OFF"
                } else {
                    audio.rhinoGuitarProcessor?.start()
                    audio.rhinoBooster?.dB = audio.rhinoBoosterDBValue
                    newValue = "ON"
                }
 
            case 1:
                min = Double(Effects.rhinoGuitarProcessor.distortionRange.lowerBound)
                max = Double(Effects.rhinoGuitarProcessor.distortionRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                audio.rhinoGuitarProcessor?.distortion = value
            
            case 2:
                min = Double(Effects.rhinoGuitarProcessor.preGainRange.lowerBound)
                max = Double(Effects.rhinoGuitarProcessor.preGainRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                audio.rhinoGuitarProcessor?.preGain = value
              
            case 3:
                audio.rhinoBooster?.dB = value
                audio.rhinoBoosterDBValue = value
                newValue = String(value)
                newValue = String(newValue.prefix(3)) + " dB"
           
            /*case 2:
                audio.rhinoGuitarProcessor?.highGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3))
            case 3:
                audio.rhinoGuitarProcessor?.midGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3))
            case 4:
                audio.rhinoGuitarProcessor?.lowGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3))
            case 6:
                audio.rhinoGuitarProcessor?.postGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3))
                */
                
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.moogLadder?.resonance = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
            default: break
                
            }
            
            
        case "modalResonanceFilter":
            switch slider {
            case 0:
                if  audio.modalResonanceFilter!.isStarted == true {
                    audio.modalResonanceFilter?.stop()
                    
                    newValue = "OFF"
                } else {
                    audio.modalResonanceFilter?.start()
                    
                    newValue = "ON"
                }
            case 1:
                audio.modalResonanceFilter?.frequency = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.modalResonanceFilter?.qualityFactor = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
            default: break
                
            }
        case "stringResonator":
            switch slider {
            case 0:
                if  audio.stringResonator!.isStarted == true {
                    audio.stringResonator?.stop()
                    
                    newValue = "OFF"
                } else {
                    audio.stringResonator?.start()
                    
                    newValue = "ON"
                }
            case 1:
                audio.stringResonator?.fundamentalFrequency = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.stringResonator?.feedback = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
            default: break
                
            }
        case "resonantFilter":
            switch slider {
            case 0:
                if  audio.resonantFilter!.isStarted == true {
                    audio.resonantFilter?.stop()
                    
                    newValue = "OFF"
                } else {
                    audio.resonantFilter?.start()
                    
                    newValue = "ON"
                }
            case 1:
                audio.resonantFilter?.frequency = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.resonantFilter?.bandwidth = value
                let text = String(value)
                newValue = String(text.prefix(5))
                
            default: break
                
            }
            
        case "dcBlock":
            switch slider {
            case 0:
                if  audio.dcBlock!.isStarted == true {
                    audio.dcBlock?.stop()
                    
                    newValue = "OFF"
                } else {
                    audio.dcBlock?.start()
                    
                    newValue = "ON"
                }
                
            default: break
                
            }
            
        case "booster" :
            switch slider {
            case 0:
                if  audio.booster!.isStarted == true {
                    audio.booster?.stop()
                    newValue = "OFF"
                } else {
                    audio.booster?.start()
                    newValue = "ON"
                }
                
            case 1:
                audio.booster?.dB = value
                let text = String(value)
                newValue = String(text.prefix(3))
                
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
                
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
                min = Double(Effects.dynaRageCompressor.ratioRange.lowerBound)
                max = Double(Effects.dynaRageCompressor.ratioRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 2:
                audio.dynaRageCompressor?.threshold = value
                newValue = String(value )
                newValue = String(newValue.prefix(3) + " dB")
            case 3:
                audio.dynaRageCompressor?.attackDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 4:
                audio.dynaRageCompressor?.releaseDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 5:
                audio.dynaRageCompressor?.rage = value
                min = Double(Effects.dynaRageCompressor.rageRatio.lowerBound)
                max = Double(Effects.dynaRageCompressor.rageRatio.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
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
                min = Double(Effects.autoWah.wahRange.lowerBound)
                max = Double(Effects.autoWah.wahRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 2:
                audio.autoWah?.amplitude = value
                min = Double(Effects.autoWah.amplitudeRange.lowerBound)
                max = Double(Effects.autoWah.amplitudeRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 3:
                audio.autoWah?.mix = value
                min = Double(Effects.autoWah.mixRange.lowerBound)
                max = Double(Effects.autoWah.mixRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                
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
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 2:
                min = Double(Effects.delay.feedbackRange.lowerBound)
                max = Double(Effects.delay.feedbackRange.upperBound)
                audio.delay?.feedback = value
                newValue = convertToPercent(value: value, max: max, min: min)
            
            case 3:
                min = Double(Effects.delay.dryWetMixRange.lowerBound)
                max = Double(Effects.delay.dryWetMixRange.upperBound)
                audio.delay?.dryWetMix = value
                newValue = convertToPercent(value: value, max: max, min: min)
             /*
            case 3:
                audio.delay?.lowPassCutoff = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
                */
                
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
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 2:
                audio.variableDelay?.feedback = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
                
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
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
            case 2:
                audio.decimator?.rounding = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 3:
                audio.decimator?.mix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
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
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.ringModulator?.frequency2 = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 3:
                audio.ringModulator?.balance = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 4:
                audio.ringModulator?.mix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            default: break
                
            }
            
        case "distortion" :
            switch slider {
            case 0:
                if  audio.distortion!.isStarted == true {
                    audio.distortion?.stop()
                    newValue = "OFF"
                } else {
                    audio.distortion?.start()
                    newValue = "ON"
                }
            case 1:
                audio.distortion?.delay = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 2:
                audio.distortion?.decay = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 3:
                audio.distortion?.decimation = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 4:
                audio.distortion?.rounding = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 5:
                audio.distortion?.decimationMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 6:
                audio.distortion?.linearTerm = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 7:
                audio.distortion?.squaredTerm = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 8:
                audio.distortion?.cubicTerm = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 9:
                audio.distortion?.polynomialMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
            case 10:
                audio.distortion?.ringModFreq1 = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 12:
                audio.distortion?.ringModFreq2 = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            
            case 12:
                audio.distortion?.ringModBalance = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 13:
                audio.distortion?.ringModMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 14:
                audio.distortion?.softClipGain = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 15:
                audio.distortion?.finalMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.flanger?.depth = value
                min = Double(Effects.flanger.depthRange.lowerBound)
                max = Double(Effects.flanger.depthRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 3:
                audio.flanger?.feedback = value
                min = Double(Effects.flanger.feedbackRange.lowerBound)
                max = Double(Effects.flanger.feedbackRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 4:
                audio.flanger?.dryWetMix = value
                min = Double(Effects.flanger.dryWetMixRange.lowerBound)
                max = Double(Effects.flanger.dryWetMixRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.phaser?.notchMaximumFrequency = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 3:
                audio.phaser?.notchWidth = value
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 4:
                audio.phaser?.notchFrequency = value
                let text = String(value)
                newValue = String(text.prefix(3) + " Hz")
            case 5:
                audio.phaser?.vibratoMode = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
            case 6:
                audio.phaser?.depth = value
                min = Double(Effects.phaser.depthRange.lowerBound)
                max = Double(Effects.phaser.depthRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 7:
                audio.phaser?.feedback = value
                min = Double(Effects.phaser.feedbackRange.lowerBound)
                max = Double(Effects.phaser.feedbackRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                min = Double(Effects.chorus.depthRange.lowerBound)
                max = Double(Effects.chorus.depthRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                audio.chorus?.depth = value
                
            case 3:
                audio.chorus?.feedback = value
                min = Double(Effects.chorus.feedbackRange.lowerBound)
                max = Double(Effects.chorus.feedbackRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
            case 4:
                audio.chorus?.dryWetMix = value
                min = Double(Effects.chorus.dryWetMixRange.lowerBound)
                max = Double(Effects.chorus.dryWetMixRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                
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
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 2:
                audio.compressor?.headRoom = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 3:
                audio.compressor?.attackDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 4:
                audio.compressor?.releaseDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 5:
                audio.compressor?.masterGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 6:
                audio.compressor?.dryWetMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
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
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 2:
                audio.dynamicsProcessor?.headRoom = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 3:
                audio.dynamicsProcessor?.expansionRatio = value
                newValue = String(value)
                newValue = String(newValue.prefix(3))
            case 4:
                audio.dynamicsProcessor?.expansionThreshold = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 5:
                audio.dynamicsProcessor?.attackDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 6:
                audio.dynamicsProcessor?.releaseDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 7:
                audio.dynamicsProcessor?.masterGain = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
                
            case 8:
                audio.dynamicsProcessor?.dryWetMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
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
                newValue = String(value)
                newValue = String(newValue.prefix(3))
            case 2:
                audio.dynamicRangeCompressor?.threshold = value
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 3:
                audio.dynamicRangeCompressor?.attackDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 4:
                audio.dynamicRangeCompressor?.releaseDuration = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
                
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
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
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
                newValue = String(value)
                newValue = String(newValue.prefix(3) + " dB")
            case 2:
                audio.reverb2?.minDelayTime = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 3:
                audio.reverb2?.maxDelayTime = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 4:
                audio.reverb2?.decayTimeAt0Hz = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 5:
                audio.reverb2?.decayTimeAtNyquist = value
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
            case 6:
                audio.reverb2?.randomizeReflections = value
                let text = String(value)
                newValue = String(text.prefix(3))
            case 7:
                audio.reverb2?.dryWetMix = value
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
            default: break
                
            }
            
        case "chowningReverb" :
            switch slider {
            case 0:
                if  audio.chowningReverb!.isStarted == true {
                    audio.chowningReverb?.stop()
                    newValue = "OFF"
                } else {
                    audio.chowningReverb?.start()
                    newValue = "ON"
                }
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.costelloReverb?.feedback = value
                
                newValue = String(value * 10)
                newValue = String(newValue.prefix(3))
                
                
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
                newValue = String(value )
                newValue = String(newValue.prefix(5) + " s")
                
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
                let intValue = Int(round(value))
                let text = String(intValue)
                newValue = String(text.prefix(5) + " Hz")
            case 2:
                audio.tremolo?.depth = value
                min = Double(Effects.tremolo.depthRange.lowerBound)
                max = Double(Effects.tremolo.depthRange.upperBound)
                newValue = convertToPercent(value: value, max: max, min: min)
                
            default: break
            }
            
        default: break
        }
        return newValue
    }
    
    func getPassFilterValues(slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String, name : String, isOn: Bool, segment: Int) {
        var min = Float(0.0)
        var max = Float(1.0)
        var valueForSlider = Float(1.0)
        var name = ""
        var value = ""
        var isOn = Bool()
        var segment = Int()
        
        switch slider {
        case 1:
            min = 10
            max = 20000
            valueForSlider = Float(audio.highPassFilter!.cutoffFrequency)
            name = "Cut Off Frequency"
            let intValue = Int(round(valueForSlider))
            let text = String(intValue)
            value = String(text.prefix(5) + " Hz")
            isOn = audio.highPassIsStarted
            segment = audio.highPassSegment
            
        case 2:
            min = 10
            max = 20000
            valueForSlider = Float(audio.lowPassFilter!.cutoffFrequency)
            name = "Cut Off Frequency"
            let intValue = Int(round(valueForSlider))
            let text = String(intValue)
            value = String(text.prefix(5) + " Hz")
            isOn = audio.lowPassIsStarted
            segment = audio.lowPassSegment
            
        default: break
        }
        
        return (min, max, valueForSlider, value, name, isOn, segment)
    }
    
    func changePassFilterValues(slider: Int, value: Double) -> String {
        var newValue = String()
        switch slider {
            
        case 1:
            audio.highPassFilter?.cutoffFrequency = value
            audio.highPassButterworthFilter?.cutoffFrequency = value
            let intValue = Int(round(value))
            let text = String(intValue)
            newValue = String(text.prefix(5) + " Hz")
        case 2:
            audio.lowPassFilter?.cutoffFrequency = value
            audio.lowPassButterworthFilter?.cutoffFrequency = value
            let intValue = Int(round(value))
            let text = String(intValue)
            newValue = String(text.prefix(5) + " Hz")
            
        default: break
            
        }
        
        return newValue
    }
    
    func togglePassKneeOnOff(slider: Int, segment: Int, isOn: Bool) {
        switch slider {
        case 1:
            if segment == 0 {
                audio.highPassSegment = 0
                if isOn == true {
                    audio.highPassFilter!.start()
                    audio.highPassButterworthFilter!.stop()
                    audio.highPassIsStarted = true
                } else {
                    audio.highPassFilter!.stop()
                    audio.highPassButterworthFilter!.stop()
                    audio.highPassIsStarted = false
                }
                
            } else {
                audio.highPassSegment = 1
                if isOn == true {
                    audio.highPassFilter!.stop()
                    audio.highPassButterworthFilter!.start()
                    audio.highPassIsStarted = true
                }
                else {
                    audio.highPassFilter!.stop()
                    audio.highPassButterworthFilter!.stop()
                    audio.highPassIsStarted = false
                }
                
            }
            
        case 2:
            if segment == 0 {
                audio.lowPassSegment = 0
                if isOn == true {
                    audio.lowPassFilter!.start()
                    audio.lowPassButterworthFilter!.stop()
                    audio.lowPassIsStarted = true
                } else {
                    audio.lowPassFilter!.stop()
                    audio.lowPassButterworthFilter!.stop()
                    audio.lowPassIsStarted = false
                }
                
            } else {
                audio.lowPassSegment = 1
                if isOn == true {
                    audio.lowPassFilter!.stop()
                    audio.lowPassButterworthFilter!.start()
                    audio.lowPassIsStarted = true
                }
                else {
                    audio.lowPassFilter!.stop()
                    audio.lowPassButterworthFilter!.stop()
                    audio.lowPassIsStarted = false
                }
                
            }
            
        default: break
            
        }
    }
    
    func getValues(id: String, slider: Int) -> (min: Float, max: Float, valueForSlider: Float, value: String, name : String, isOn: Bool) {
        var min = Float(0.0)
        var max = Float(1.0)
        var valueForSlider = Float(0.69)
        var name = ""
        var value = ""
        var isOn = Bool()
        switch id {
            
        case "toneFilters":
            switch slider {
            case 1:
                min = Float(Filters.toneFilter.halfPowerPointRange.lowerBound)
                max = Float(Filters.toneFilter.halfPowerPointRange.upperBound)
                valueForSlider = Float(audio.toneFilter!.halfPowerPoint)
                name = "Tone"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.toneFilter!.isStarted
            case 2:
                min = Float(Filters.toneComplementFilter.halfPowerPointRange.lowerBound)
                max = Float(Filters.toneComplementFilter.halfPowerPointRange.upperBound)
                valueForSlider = Float(audio.toneComplementFilter!.halfPowerPoint)
                name = "Tone Complement"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.toneComplementFilter!.isStarted
                
            default: break
            }
            
            
        case "rhinoGuitarProcessor":
            switch slider {
            case 1:
                min = Float(Effects.rhinoGuitarProcessor.distortionRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.distortionRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.distortion)
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                name = "Distortion"
                isOn = audio.rhinoGuitarProcessor!.isStarted
            
                
            case 2:
                min = Float(Effects.rhinoGuitarProcessor.preGainRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.preGainRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.preGain)
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                name = "Gain"
                isOn = audio.rhinoGuitarProcessor!.isStarted
                
            case 3:
                min = Float(Effects.booster.dBRange.lowerBound)
                max = Float(Effects.booster.dBRange.upperBound)
                valueForSlider = Float(audio.rhinoBoosterDBValue)
                name = "Volume"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3)) + " dB"
                isOn = audio.rhinoGuitarProcessor!.isStarted
                
                /*
            case 6:
                min = Float(Effects.rhinoGuitarProcessor.postGainRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.postGainRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.postGain)
                name = "Postgain"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.rhinoGuitarProcessor!.isStarted
            case 2:
                min = Float(Effects.rhinoGuitarProcessor.eqGainRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.eqGainRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.highGain)
                name = "High"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.rhinoGuitarProcessor!.isStarted
                
            case 3:
                min = Float(Effects.rhinoGuitarProcessor.eqGainRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.eqGainRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.midGain)
                name = "Mid"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.rhinoGuitarProcessor!.isStarted
                
            case 4:
                min = Float(Effects.rhinoGuitarProcessor.eqGainRange.lowerBound)
                max = Float(Effects.rhinoGuitarProcessor.eqGainRange.upperBound)
                valueForSlider = Float(audio.rhinoGuitarProcessor!.lowGain)
                name = "Low"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.rhinoGuitarProcessor!.isStarted
                */
            default: break
            }
            
            
        case "moogLadder":
            switch slider {
            case 1:
                min =  Float(Filters.moogLadder.cutoffFrequencyRange.lowerBound)
                max = Float(Filters.moogLadder.cutoffFrequencyRange.upperBound)
                valueForSlider = Float(audio.moogLadder!.cutoffFrequency)
                name = "Cut off"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.moogLadder!.isStarted
            case 2:
                min =  Float(Filters.moogLadder.resonanceRange.lowerBound)
                max = Float(Filters.moogLadder.resonanceRange.upperBound)
                valueForSlider = Float(audio.moogLadder!.resonance)
                name = "Resonance"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.moogLadder!.isStarted
                
            default: break
            }
            
        case "resonantFilter":
            switch slider {
            case 1:
                min =  Float(Filters.resonantFilter.frequencyRange.lowerBound)
                max = Float(Filters.resonantFilter.frequencyRange.upperBound)
                valueForSlider = Float(audio.resonantFilter!.frequency)
                name = "Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.resonantFilter!.isStarted
            case 2:
                min =  Float(Filters.resonantFilter.bandwidthRange.lowerBound)
                max = Float(Filters.resonantFilter.bandwidthRange.upperBound)
                valueForSlider = Float(audio.resonantFilter!.bandwidth)
                name = "Bandwidth"
                value = String(audio.resonantFilter!.bandwidth)
                value = String(value.prefix(5))
                isOn = audio.resonantFilter!.isStarted
                
            default: break
            }
            
        case "stringResonator":
            switch slider {
            case 1:
                min =  Float(Filters.stringResonator.fundamentalFrequencyRange.lowerBound)
                max = Float(Filters.stringResonator.fundamentalFrequencyRange.upperBound)
                valueForSlider = Float(audio.stringResonator!.fundamentalFrequency)
                name = "Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.stringResonator!.isStarted
            case 2:
                min =  Float(Filters.stringResonator.feedbackRange.lowerBound)
                max = Float(Filters.stringResonator.feedbackRange.upperBound)
                valueForSlider = Float(audio.stringResonator!.feedback)
                name = "Feedback"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.stringResonator!.isStarted
                
            default: break
            }
            
        case "modalResonanceFilter":
            switch slider {
            case 1:
                min =  Float(Filters.modalResonanceFilter.frequencyRange.lowerBound)
                max = Float(Filters.modalResonanceFilter.frequencyRange.upperBound)
                valueForSlider = Float(audio.modalResonanceFilter!.frequency)
                name = "Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.modalResonanceFilter!.isStarted
            case 2:
                min =  Float(Filters.modalResonanceFilter.qualityFactorRange.lowerBound)
                max = Float(Filters.modalResonanceFilter.qualityFactorRange.upperBound)
                valueForSlider = Float(audio.modalResonanceFilter!.qualityFactor)
                name = "Quality Factor"
                value = String(audio.modalResonanceFilter!.qualityFactor)
                value = String(value.prefix(3))
                isOn = audio.modalResonanceFilter!.isStarted
                
            default: break
            }
            
        case "dcBlock" :
            switch slider {
            case 1:
                min = 0 // no values
                max = 1 // no values
                valueForSlider = Float(30)
                name = "dcBlock"
                value = String(1.00)
                value = String(value.prefix(3))
                isOn = audio.dcBlock!.isStarted
                
            default: break
            }
            
        case "booster" :
            // BOOSTER
            switch slider {
            case 1:
                min = Float(Effects.booster.dBRange.lowerBound)
                max = Float(Effects.booster.dBRange.upperBound)
                valueForSlider = Float(audio.booster!.dB)
                name = "dB"
                value = String(audio.booster!.dB)
                value = String(value.prefix(3))
                isOn = audio.booster!.isStarted
            
            default: break
            }
            
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
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
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
            
            switch slider {
            case 0:
                name = "Rage is On"
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
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.dynaRageCompressor!.isStarted
            case 2:
                min = Float(Effects.dynaRageCompressor.thresholdRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.thresholdRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.threshold)
                name = "Threshold"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynaRageCompressor!.isStarted
            case 3:
                min = Float(Effects.dynaRageCompressor.attackDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.attackDuration)
                name = "Attack"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynaRageCompressor!.isStarted
            case 4:
                min = Float(Effects.dynaRageCompressor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynaRageCompressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.releaseDuration)
                name = "Release"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynaRageCompressor!.isStarted
            case 5:
                min = Float(Effects.dynaRageCompressor.rageRatio.lowerBound)
                max = Float(Effects.dynaRageCompressor.rageRatio.upperBound)
                valueForSlider = Float(audio.dynaRageCompressor!.rage)
                name = "Rage"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.autoWah!.isStarted
            case 2:
                min = Float(Effects.autoWah.amplitudeRange.lowerBound)
                max = Float(Effects.autoWah.amplitudeRange.upperBound)
                valueForSlider = Float(audio.autoWah!.amplitude)
                name = "Amplitude"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.autoWah!.isStarted
            case 3:
                min = Float(Effects.autoWah.mixRange.lowerBound)
                max = Float(Effects.autoWah.mixRange.upperBound)
                valueForSlider = Float(audio.autoWah!.mix)
                name = "Dry Wet Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.delay!.isStarted
            case 2:
                min = Float(Effects.delay.feedbackRange.lowerBound)
                max = Float(Effects.delay.feedbackRange.upperBound)
                valueForSlider = Float(audio.delay!.feedback)
                name = "Feedback"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.delay!.isStarted
                
            case 3:
                min = Float(Effects.delay.dryWetMixRange.lowerBound)
                max = Float(Effects.delay.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.delay!.dryWetMix)
                name = "Dry Wet Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.delay!.isStarted
                /*
            case 3:
                min = Float(Effects.delay.lowPassCutOffRange.lowerBound)
                max = Float(Effects.delay.lowPassCutOffRange.upperBound)
                valueForSlider = Float(audio.delay!.lowPassCutoff)
                name = "Low Pass Cut Off"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.delay!.isStarted
            */
                
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
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.variableDelay!.isStarted
            case 2:
                min = Float(Effects.variableDelay.feedbackRange.lowerBound)
                max = Float(Effects.variableDelay.feedbackRange.upperBound)
                valueForSlider = Float(audio.variableDelay!.feedback)
                name = "Feedback"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.decimator!.isStarted
            case 2:
                min = Float(Effects.decimator.roundingRange.lowerBound)
                max = Float(Effects.decimator.roundingRange.upperBound)
                valueForSlider = Float(audio.decimator!.rounding)
                name = "Rounding"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.decimator!.isStarted
            case 3:
                min = Float(Effects.decimator.mixRange.lowerBound)
                max = Float(Effects.decimator.mixRange.upperBound)
                valueForSlider = Float(audio.decimator!.mix)
                name = "Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.ringModulator!.isStarted
            case 2:
                min = Float(Effects.ringModulator.frequencyRange.lowerBound)
                max = Float(Effects.ringModulator.frequencyRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.frequency2)
                name = "Freq 2"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.ringModulator!.isStarted
            case 3:
                min = Float(Effects.ringModulator.balanceRange.lowerBound)
                max = Float(Effects.ringModulator.balanceRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.balance)
                name = "Balance"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            case 4:
                min = Float(Effects.ringModulator.mixRange.lowerBound)
                max = Float(Effects.ringModulator.mixRange.upperBound)
                valueForSlider = Float(audio.ringModulator!.mix)
                name = "Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.ringModulator!.isStarted
            default: break
            }
            
        case "distortion" :
            // DISTORTION
            switch slider {
            case 1:
                min = Float(Effects.distortion.delayRange.lowerBound)
                max = Float(Effects.distortion.delayRange.upperBound)
                valueForSlider = Float(audio.distortion!.delay)
                name = "Delay"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 2:
                min = Float(Effects.distortion.decayRange.lowerBound)
                max = Float(Effects.distortion.decayRange.upperBound)
                valueForSlider = Float(audio.distortion!.decay)
                name = "Decay"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 3:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.delayMix)
                name = "Delay Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 4:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.decimation)
                name = "Decimation"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 5:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.rounding)
                name = "Rounding"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 6:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.decimationMix)
                name = "Decimation Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 7:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.linearTerm)
                name = "Linear"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 8:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.squaredTerm)
                name = "Squared"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 9:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.cubicTerm)
                name = "Cubic"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 10:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.polynomialMix)
                name = "Polynomial Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 11:
                min = Float(Effects.distortion.ringModFreqRange.lowerBound)
                max = Float(Effects.distortion.ringModFreqRange.upperBound)
                valueForSlider = Float(audio.distortion!.ringModFreq1)
                name = "Ring Mod 1"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.distortion!.isStarted
            case 12:
                min = Float(Effects.distortion.ringModFreqRange.lowerBound)
                max = Float(Effects.distortion.ringModFreqRange.upperBound)
                valueForSlider = Float(audio.distortion!.ringModFreq2)
                name = "Ring Mod 2"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.distortion!.isStarted
            case 13:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.ringModBalance)
                name = "Ring Balance"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 14:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.ringModMix)
                name = "Ring Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 15:
                min = Float(Effects.distortion.softClipGainRange.lowerBound)
                max = Float(Effects.distortion.softClipGainRange.upperBound)
                valueForSlider = Float(audio.distortion!.softClipGain)
                name = "Clipping"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            case 16:
                min = Float(Effects.distortion.normalRange.lowerBound)
                max = Float(Effects.distortion.normalRange.upperBound)
                valueForSlider = Float(audio.distortion!.finalMix)
                name = "Ring Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.distortion!.isStarted
            default: break
            }
            
        case "flanger" :
            
            switch slider {
            case 1:
                min = Float(Effects.flanger.frequencyRange.lowerBound)
                max = Float(Effects.flanger.frequencyRange.upperBound)
                valueForSlider = Float(audio.flanger!.frequency)
                name = "Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.flanger!.isStarted
            case 2:
                min = Float(Effects.flanger.depthRange.lowerBound)
                max = Float(Effects.flanger.depthRange.upperBound)
                valueForSlider = Float(audio.flanger!.depth)
                name = "Depth"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.flanger!.isStarted
            case 3:
                min = Float(Effects.flanger.feedbackRange.lowerBound)
                max = Float(Effects.flanger.feedbackRange.upperBound)
                valueForSlider = Float(audio.flanger!.feedback)
                name = "Feedback"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.flanger!.isStarted
            case 4:
                min = Float(Effects.flanger.dryWetMixRange.lowerBound)
                max = Float(Effects.flanger.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.flanger!.dryWetMix)
                name = "Dry Wet Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.phaser!.isStarted
            case 2:
                min = Float(Effects.phaser.notchMaximumFrequencyRange.lowerBound)
                max = Float(Effects.phaser.notchMaximumFrequencyRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchMaximumFrequency)
                name = "Notch Max Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.phaser!.isStarted
            case 3:
                min = Float(Effects.phaser.notchWidthRange.lowerBound)
                max = Float(Effects.phaser.notchWidthRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchWidth)
                name = "Notch Width"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.phaser!.isStarted
            case 4:
                min = Float(Effects.phaser.notchFrequencyRange.lowerBound)
                max = Float(Effects.phaser.notchFrequencyRange.upperBound)
                valueForSlider = Float(audio.phaser!.notchFrequency)
                name = "Notch Frequency"
                let text = String(valueForSlider)
                value = String(text.prefix(3) + " Hz")
                isOn = audio.phaser!.isStarted
            case 5:
                min = Float(Effects.phaser.vibratoModeRange.lowerBound)
                max = Float(Effects.phaser.vibratoModeRange.upperBound)
                valueForSlider = Float(audio.phaser!.vibratoMode)
                name = "Vibrato Mode"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.phaser!.isStarted
            case 6:
                min = Float(Effects.phaser.depthRange.lowerBound)
                max = Float(Effects.phaser.depthRange.upperBound)
                valueForSlider = Float(audio.phaser!.depth)
                name = "Depth"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.phaser!.isStarted
            case 7:
                min = Float(Effects.phaser.feedbackRange.lowerBound)
                max = Float(Effects.phaser.feedbackRange.upperBound)
                valueForSlider = Float(audio.phaser!.feedback)
                name = "Feedback"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.phaser!.isStarted
            case 8:
                min = Float(Effects.phaser.lfoBPMRange.lowerBound)
                max = Float(Effects.phaser.lfoBPMRange.upperBound)
                valueForSlider = Float(audio.phaser!.lfoBPM)
                name = "BPM"
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
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.chorus!.isStarted
            case 2:
                min = Float(Effects.chorus.depthRange.lowerBound)
                max = Float(Effects.chorus.depthRange.upperBound)
                valueForSlider = Float(audio.chorus!.depth)
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                name = "Depth"
                isOn = audio.chorus!.isStarted
            case 3:
                min = Float(Effects.chorus.feedbackRange.lowerBound)
                max = Float(Effects.chorus.feedbackRange.upperBound)
                valueForSlider = Float(audio.chorus!.feedback)
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                name = "Feedback"
                isOn = audio.chorus!.isStarted
            case 4:
                min = Float(Effects.chorus.dryWetMixRange.lowerBound)
                max = Float(Effects.chorus.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.chorus!.dryWetMix)
                name = "Dry Wet Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.compressor!.isStarted
            case 2:
                min = Float(Effects.compressor.headRoomRange.lowerBound)
                max = Float(Effects.compressor.headRoomRange.upperBound)
                valueForSlider = Float(audio.compressor!.headRoom)
                name = "Headroom"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.compressor!.isStarted
            case 3:
                min = Float(Effects.compressor.attackDurationRange.lowerBound)
                max = Float(Effects.compressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.compressor!.attackDuration)
                name = "Attack Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.compressor!.isStarted
            case 4:
                min = Float(Effects.compressor.releaseDurationRange.lowerBound)
                max = Float(Effects.compressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.compressor!.releaseDuration)
                name = "Release Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.compressor!.isStarted
            case 5:
                min = Float(Effects.compressor.masterGainRange.lowerBound)
                max = Float(Effects.compressor.masterGainRange.upperBound)
                valueForSlider = Float(audio.compressor!.masterGain)
                name = "Master Gain"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.compressor!.isStarted
                
            case 6:
                min = Float(Effects.compressor.dryWetMixRange.lowerBound)
                max = Float(Effects.compressor.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.compressor!.dryWetMix)
                name = "Dry Wet Mix"
                value = String(valueForSlider * 10)
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
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynamicsProcessor!.isStarted
            case 2:
                min = Float(Effects.dynamicsProcessor.headRoomRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.headRoomRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.headRoom)
                name = "Headroom"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynamicsProcessor!.isStarted
            case 3:
                min = Float(Effects.dynamicsProcessor.expansionRatioRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.expansionRatioRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.expansionRatio)
                name = "Expansion Ratio"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.dynamicsProcessor!.isStarted
            case 4:
                min = Float(Effects.dynamicsProcessor.expansionThresholdRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.expansionThresholdRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.expansionThreshold)
                name = "Expansion Threshold"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynamicsProcessor!.isStarted
            case 5:
                min = Float(Effects.dynamicsProcessor.attackDurationRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.attackDuration)
                name = "Attack Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynamicsProcessor!.isStarted
            case 6:
                min = Float(Effects.dynamicsProcessor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.releaseDuration)
                name = "Release Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynamicsProcessor!.isStarted
            case 7:
                min = Float(Effects.dynamicsProcessor.masterGainRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.masterGainRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.masterGain)
                name = "Master Gain"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynamicsProcessor!.isStarted
                
            case 8:
                min = Float(Effects.dynamicsProcessor.dryWetMixRange.lowerBound)
                max = Float(Effects.dynamicsProcessor.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.dynamicsProcessor!.dryWetMix)
                name = "Dry Wet Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
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
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.dynamicRangeCompressor!.isStarted
            case 2:
                min = Float(Effects.dynamicRangeCompressor.thresholdRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.thresholdRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.threshold)
                name = "Threshold"
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.dynamicRangeCompressor!.isStarted
                
            case 3:
                min = Float(Effects.dynamicRangeCompressor.attackDurationRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.attackDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.attackDuration)
                name = "Attack Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynamicRangeCompressor!.isStarted
            case 4:
                min = Float(Effects.dynamicRangeCompressor.releaseDurationRange.lowerBound)
                max = Float(Effects.dynamicRangeCompressor.releaseDurationRange.upperBound)
                valueForSlider = Float(audio.dynamicRangeCompressor!.releaseDuration)
                name = "Release Duration"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.dynamicRangeCompressor!.isStarted
                
                
            default: break
            }
            
        case "reverb" :
            
            switch slider {
            case 1:
                min = Float(Effects.reverb.dryWetMixRange.lowerBound)
                max = Float(Effects.reverb.dryWetMixRange.upperBound)
                valueForSlider = Float(audio.reverb!.dryWetMix)
                name = "Dry Wet Mix"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                let intValue = Int(valueForSlider)
                value = String(intValue)
                value = String(value.prefix(3) + " dB")
                isOn = audio.reverb2!.isStarted
            case 2:
                min = Float(Effects.reverb2.minDelayTimeRange.lowerBound)
                max = Float(Effects.reverb2.minDelayTimeRange.upperBound)
                valueForSlider = Float(audio.reverb2!.minDelayTime)
                name = "Min Delay Time"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.reverb2!.isStarted
            case 3:
                min = Float(Effects.reverb2.maxDelayTimeRange.lowerBound)
                max = Float(Effects.reverb2.maxDelayTimeRange.upperBound)
                valueForSlider = Float(audio.reverb2!.maxDelayTime)
                name = "Max Delay Time"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.reverb2!.isStarted
            case 4:
                min = Float(Effects.reverb2.decayTimeAt0HzRange.lowerBound)
                max = Float(Effects.reverb2.decayTimeAt0HzRange.upperBound)
                valueForSlider = Float(audio.reverb2!.decayTimeAt0Hz)
                name = "0Hz Decay Time"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
                isOn = audio.reverb2!.isStarted
            case 5:
                min = Float(Effects.reverb2.decayTimeAtNyquistRange.lowerBound)
                max = Float(Effects.reverb2.decayTimeAtNyquistRange.upperBound)
                valueForSlider = Float(audio.reverb2!.decayTimeAtNyquist)
                name = "Nyquist Decay Time"
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
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
                name = "Dry Wet Mix"
                let intValue = Int(valueForSlider * 10)
                value = String(intValue)
                value = String(value.prefix(3))
                isOn = audio.reverb2!.isStarted
                
            default: break
            }
            
        case "chowningReverb" :
            switch slider {
            case 1:
                min = Float(0)
                max = Float(1)
                valueForSlider = Float(1)
                name = ""
                
                value = ""
                isOn = audio.chowningReverb!.isStarted
            default: break
            }
            
        case "costelloReverb" :
            
            switch slider {
            case 1:
                min = Float(Effects.costelloReverb.cutOffRange.lowerBound)
                max = Float(Effects.costelloReverb.cutOffRange.upperBound)
                valueForSlider = Float(audio.costelloReverb!.cutoffFrequency)
                name = "Cut Off Frequency"
                let intValue = Int(round(valueForSlider))
                let text = String(intValue)
                value = String(text.prefix(5) + " Hz")
                isOn = audio.costelloReverb!.isStarted
            case 2:
                min = Float(Effects.costelloReverb.feedbackRange.lowerBound)
                max = Float(Effects.costelloReverb.feedbackRange.upperBound)
                valueForSlider = Float(audio.costelloReverb!.feedback)
                name = "Feedback"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
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
                value = String(valueForSlider)
                value = String(value.prefix(5) + " s")
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
                let intValue = Int(round(audio.tremolo!.frequency))
                value = String(intValue)
                value = String(value.prefix(5) + " Hz")
                isOn = audio.tremolo!.isStarted
            case 2:
                min = Float(Effects.tremolo.depthRange.lowerBound)
                max = Float(Effects.tremolo.depthRange.upperBound)
                valueForSlider = Float(audio.tremolo!.depth)
                name = "Depth"
                value = convertToPercent(value: Double(valueForSlider), max: Double(max), min: Double(min))
                isOn = audio.tremolo!.isStarted
                
            default: break
            }
            
        default: break
        }
        return (min, max, valueForSlider, value, name, isOn)
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

