//
//  Effects.swift
//  
//
//  Created by Juhani Vainio on 26/09/2018.
//

import Foundation
import UIKit

class Effects:Codable {
    
// BIT CRUSHER AKBitCrusher
// Tag = 1
struct bitCrusher:Codable {

    
    // controls needed : 2
    // bitDepth
    // sampleRate
 
    
    static var isStarted = true {
        didSet {
            UserDefaults.standard.set(isStarted, forKey: "bitCrusherIsStarted")
        }
    }
    
    static var bitDepthRange = 1.0 ... 24.0
    static var sampleRateRange = 0.0 ... 20_000.0
    static var defaultBitDepth:Double = 8.0
    static var defaultSampleRate:Double = 10_000.0

    static var bitDepth = Double(8.0) {
        didSet {
            UserDefaults.standard.set(bitDepth, forKey: "bitCrusherBitDepth")
        }
    }

    static var sampleRate:Double = 10_000.0 {
        didSet {
            UserDefaults.standard.set(sampleRate, forKey: "bitCrusherSampleRate")
        }
    }

}
    
    // TANH DISTORTION AKTanhDistortion
    // Tag = 2
    struct tanhDistortion:Codable {
        
        // controls needed : 4
        // pregain
        // postgain
        // positiveShapeParameter
        // negativeShapeParameter
        
        static var pregainRange = -10...20
        static var postgainRange = -10...20
        static var positiveShapeParameterRange = 0...1
        static var negativeShapeParameterRange = 0...1
        
        
        static var pregain: Double = 1.0 {
            didSet {
                UserDefaults.standard.set(pregain, forKey: "tanhDistortionPregain")
            }
        }
        static var postgain: Double = 1.0 {
            didSet {
                UserDefaults.standard.set(postgain, forKey: "tanhDistortionPostgain")
            }
        }
        static var positiveShapeParameter: Double = 0.0 {
            didSet {
                UserDefaults.standard.set(positiveShapeParameter, forKey: "tanhDistortionPositiveShapeParameter")
            }
        }
        static var negativeShapeParameter: Double = 0.0 {
            didSet {
                UserDefaults.standard.set(negativeShapeParameter, forKey: "tanhDistortionNegativeShapeParameter")
            }
        }
        static var isStarted = Bool(true) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "tanhDistortionIsStarted")
            }
        }
        
    }
    
 
    
// COMPRESSOR    AKDynaRageCompressor
// Tag = 3
 struct dynaRageCompressor:Codable {
 
    // controls needed : 4 + 1 + switch
    // ratio
    // threshold
    // attackDuration
    // releaseDuration
    
    // + rage
    // + rageIsOn
    
    static var ratioRange = 1...30
    static var thresholdRange = 0...40
    static var attackDurationRange = 0.0001...0.2   // 0,1 ms
    static var releaseDurationRange = 0.01...3
    
    static var ratio = Double(1) {
        didSet {
            UserDefaults.standard.set(ratio, forKey: "dynaRageCompressorRatio")
        }
    }
    static var threshold = Double(0){
        didSet {
            UserDefaults.standard.set(threshold, forKey: "dynaRageCompressorThreshold")
        }
    }
    static var attackDuration = Double(0.001){
        didSet {
            UserDefaults.standard.set(attackDuration, forKey: "dynaRageCompressorAttackDuration")
        }
    }
    static var releaseDuration = Double(0.05){
        didSet {
            UserDefaults.standard.set(releaseDuration, forKey: "dynaRageCompressorReleaseDuration")
        }
    }
    static var rage = Double(0.7){
        didSet {
            UserDefaults.standard.set(rage, forKey: "dynaRageCompressorRage")
        }
    }
    static var rageIsOn = Bool(false) {
        didSet {
            UserDefaults.standard.set(rageIsOn, forKey: "dynaRageCompressorRageIsOn")
        }
    }
    static var isStarted = Bool(true) {
        didSet {
            UserDefaults.standard.set(isStarted, forKey: "dynaRageCompressorIsStarted")
        }
    }
 
    }
 
// AUTO WAH AKAutoWah
// Tag = 4
struct autoWah:Codable {
    
     // controls needed : 3
        // wah
        // amplitude
        // mix
    
    
    static var wahRange = 0...1
    static var mixRange = 0...1
    static var amplitudeRange = 0...2
    
    static var defaultWah = Double(0.5)
    static var defaultMix = Double(0.5)
    static var defaultAmplitude = Double(0.5)

    static var wah = Double(0.3){
        didSet {
            UserDefaults.standard.set(wah, forKey: "autoWahWah")
        }
    }
    static var mix = Double(0.3){
        didSet {
            UserDefaults.standard.set(mix, forKey: "autoWahMix")
        }
    }
    static var amplitude = Double(1.0){
        didSet {
            UserDefaults.standard.set(amplitude, forKey: "autoWahAmplitude")
        }
    }
    static var isStarted = Bool(true) {
        didSet {
            UserDefaults.standard.set(isStarted, forKey: "autoWahIsStarted")
        }
    }
   
    }

    
// DELAY    AKDelay
// Tag = 5
struct delay:Codable {

    // controls needed : 4 + 3-way switch for presets
    // time
    // feedback
    // lowPassCutOff
    // dryWetMix
    
    
    // Has presets
    //presetShortDelay()
    //presetDenseLongDelay()
    //presetElectricCircuitsDelay()

        
    static var timeRange = 0.0001...3
    static var feedbackRange = 0...1
     static var dryWetMixRange = 0...1
    static var lowPassCutOffRange = 1000...4000
        static var time = TimeInterval(1){
            didSet {
                UserDefaults.standard.set(time, forKey: "delayTime")
            }
        }
        static var feedback = Double(0.5){
            didSet {
                UserDefaults.standard.set(feedback, forKey: "delayFeedback")
            }
        }
        static var lowPassCutOff = Double(3000){
            didSet {
                UserDefaults.standard.set(lowPassCutOff, forKey: "delayLowPassCutOff")
            }
        }
        static var dryWetMix = Double(0.6){
            didSet {
                UserDefaults.standard.set(dryWetMix, forKey: "delayDryWetMix")
            }
        }
        static var isStarted = Bool(true) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "delayIsStarted")
            }
        }

    }
    
    
// DECIMATOR  AKDecimator
// Tag = 6
struct decimator:Codable {
  
         // controls needed : 3
        // decimation
        // rounding
        // mix
        
        static var decimationRange = 0.0 ... 1.0
        static var roundingRange = 0.0 ... 1.0
        static var mixRange = 0.0 ... 1.0
        
        static var decimation: Double = 0.5 {
            didSet {
                UserDefaults.standard.set(decimation, forKey: "decimatorDecimation")
            }
        }

        static var rounding: Double = 0.5 {
            didSet {
                UserDefaults.standard.set(rounding, forKey: "decimatorRounding")
            }
        }

        static var mix: Double = 0.5 {
            didSet {
                UserDefaults.standard.set(mix, forKey: "decimatorMix")
            }
        }

        static var isStarted = Bool(true) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "decimatorIsStarted")
            }
        }
    

        
    }
    
    // CLIPPER    AKClipper
    // Tag 7
    struct clipper:Codable {
        
        // controls needed : 1
        // limit
        
        static var isStarted = Bool(true){
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "clipperIsStarted")
            }
        }
        
        static var limitRange = 0.0001 ... 1.0
        static var defaultLimit = 1.0
        
        static var limit = Double(0.4) {
            didSet {
                UserDefaults.standard.set(limit, forKey: "clipperLimit")
            }
        }
        
    }
    

    // RING MODULATOR  AKRingModulator
    // Tag= 8
    struct ringModulator:Codable {
        
            // controls needed : 4
        // frequency1
        // frequency2
        // balance
        // mix
        
        static var frequencyRange = 80...1200
        static var balanceRange = 0...1
        static var mixRange = 0...1
        static var frequency1: Double = 100 {
            didSet {
            UserDefaults.standard.set(frequency1, forKey: "ringModulatorFrequency1")
            }
        }
        static var frequency2: Double = 100 {
            didSet {
            UserDefaults.standard.set(frequency2, forKey: "ringModulatorFrequency2")
            }
        }
        static var balance: Double = 0.5 {
            didSet {
                UserDefaults.standard.set(balance, forKey: "ringModulatorBalance")
            }
        }
        static var  mix: Double = 1 {
            didSet {
                UserDefaults.standard.set(mix, forKey: "ringModulatorMix")
            }
        }
        static var isStarted = Bool(true) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "ringModulatorIsStarted")
            }
        }
        
        
    }
    
    static var selectedEffects = [String]()
    
    static var listOfEffects =
                            [
                            "AKDelay",
                            "AKBitCrusher",
                            "AKClipper",
                            "AKDynaRageCompressor",
                            "AKAutoWah",
                            "AKTanhDistortion",
                            "AKDecimator",
                            "AKRingModulator"
                            ]
    
    static let effectList = [
        "AKDelay",
        "AKBitCrusher",
        "AKClipper",
        "AKDynaRageCompressor",
        "AKAutoWah",
        "AKTanhDistortion",
        "AKDecimator",
        "AKRingModulator"
    ]
    

    
    struct distortion:Codable {
        // DISTORTION  AKDistortion
        // Tags in xib file =
        
        static var delay: Double = 0.1
        static var decay: Double = 1.0
        static var delayMix: Double = 0.5
        static var decimation: Double = 0.5
        static var rounding: Double = 0.0
        static var decimationMix: Double = 0.5
        static var linearTerm: Double = 0.5
        static var squaredTerm: Double = 0.5
        static var cubicTerm: Double = 0.5
        static var polynomialMix: Double = 0.5
        static var ringModFreq1: Double = 100
        static var ringModFreq2: Double = 100
        static var ringModBalance: Double = 0.5
        static var ringModMix: Double = 0.0
        static var softClipGain: Double = -6
        static var finalMix: Double = 0.5
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "distortionIsStarted")
            }
        }
    }

}


