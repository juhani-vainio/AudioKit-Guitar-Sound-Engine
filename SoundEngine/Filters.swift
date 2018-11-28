//
//  Filters.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 27/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import AudioKit

class Filters: Codable {
 
    struct masterMixer: Codable {
        static var volume = Double(1.0) {
            didSet {
                UserDefaults.standard.set(volume, forKey: "masterMixerVolume")
            }
            
        }
        
    }
    
    // AKBooster
    struct masterBooster: Codable {
        
        static var gain = Double(1.0) {
            didSet {
                UserDefaults.standard.set(gain, forKey: "masterBoosterGain")
            }
            
        }
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "masterBoosterIsStarted")
            }
        }
        
    }
    
    // AKToneFilter
    struct toneFilter: Codable {
        
        static var halfPowerPoint = Double(1.0) {
            didSet {
                UserDefaults.standard.set(halfPowerPoint, forKey: "toneFilterHalfPowerPoint")
            }
        }
        
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "toneFilterIsStarted")
            }
        }
    }
    
    // AKEqualizerFilter
    struct equalizerFilter: Codable {
        
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "equalizerFilterIsStarted")
            }
        }
        
        static var filterBand1Gain = Double(1.5) // [centerFrequency: 32, bandwidth: 44.7, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand1Gain, forKey: "filterBand1Gain")
            }
        }
        static var  filterBand2Gain = Double(1.4) // [centerFrequency: 64, bandwidth: 70.8, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand2Gain, forKey: "filterBand2Gain")
            }
        }
        static var  filterBand3Gain = Double(0.8) // [centerFrequency: 125, bandwidth: 141, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand3Gain, forKey: "filterBand3Gain")
            }
        }
        static var  filterBand4Gain = Double(0.8) // [centerFrequency: 250, bandwidth: 282, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand4Gain, forKey: "filterBand4Gain")
            }
        }
        static var  filterBand5Gain = Double(1.2) // [centerFrequency: 500, bandwidth: 562, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand5Gain, forKey: "filterBand5Gain")
            }
        }
        static var  filterBand6Gain = Double(1.3) // [centerFrequency: 1_000, bandwidth: 1_112, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand6Gain, forKey: "filterBand6Gain")
            }
        }
        static var  filterBand7Gain = Double(1.3) // [centerFrequency: 2_000, bandwidth: 2_222, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand7Gain, forKey: "filterBand7Gain")
            }
        }
        static var  filterBand8Gain = Double(1.3) // [centerFrequency: 4_000, bandwidth: 4500, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand8Gain, forKey: "filterBand8Gain")
            }
        }
        static var  filterBand9Gain = Double(1.3) // [centerFrequency: 4_000, bandwidth: 4500, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand9Gain, forKey: "filterBand9Gain")
            }
        }
        static var  filterBand10Gain = Double(1.3) // [centerFrequency: 4_000, bandwidth: 4500, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand10Gain, forKey: "filterBand10Gain")
            }
        }
        static var  filterBand11Gain = Double(1.3) // [centerFrequency: 4_000, bandwidth: 4500, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand11Gain, forKey: "filterBand11Gain")
            }
        }
        static var  filterBand12Gain = Double(1.3) // [centerFrequency: 4_000, bandwidth: 4500, gain: 1.0]
        {
            didSet {
                UserDefaults.standard.set(filterBand12Gain, forKey: "filterBand12Gain")
            }
        }
        
        
        
        
        
        
        
        
        static var filterBand1centerFrequency = Double(4000)
        {
            didSet {
                UserDefaults.standard.set(filterBand1centerFrequency, forKey: "filterBand1centerFrequency")
            }
        }
        
        static var filterBand1bandwidth = Double(4500)
        {
            didSet {
                UserDefaults.standard.set(filterBand1bandwidth, forKey: "filterBand1bandwidth")
            }
        }
    }
    
    
    
    // AKLowPassFilter
    // A low-pass filter takes an audio signal as an input, and cuts out the high-frequency components of the audio signal, allowing for the lower frequency components to "pass through" the filter.
    struct lowPassFilter : Codable {
        
        static var cutoffFrequency = Double(6900) // Cutoff Frequency (Hz) ranges from 10 to 22050 (Default: 6900)
        {
            didSet {
                UserDefaults.standard.set(cutoffFrequency, forKey: "lowPassFilterCutoffFrequency")
            }
        }
        static var resonance = Double(0) // Resonance (dB) ranges from -20 to 40 (Default: 0)
        {
            didSet {
                UserDefaults.standard.set(resonance, forKey: "lowPassFilterResonance")
            }
        }
        static var dryWetMix = Double(1) {
            didSet {
                UserDefaults.standard.set(dryWetMix, forKey: "lowPassFilterDryWetMix")
            }
        }
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "lowPassFilterIsStarted")
            }
        }
    }
    
    // AKHighPassFilter
    // A high-pass filter takes an audio signal as an input, and cuts out the low-frequency components of the audio signal, allowing for the higher frequency components to "pass through" the filter
    struct highPassFilter : Codable {
        
        static var cutoffFrequency = Double(6900) // Cutoff Frequency (Hz) ranges from 10 to 22050 (Default: 6900)
        {
            didSet {
                UserDefaults.standard.set(cutoffFrequency, forKey: "highPassFilterCutoffFrequency")
            }
        }
        static var resonance = Double(0) // Resonance (dB) ranges from -20 to 40 (Default: 0)
        {
            didSet {
                UserDefaults.standard.set(resonance, forKey: "highPassFilterResonance")
            }
        }
        static var dryWetMix = Double(1) {
            didSet {
                UserDefaults.standard.set(dryWetMix, forKey: "highPassFilterDryWetMix")
            }
        }
        static var isStarted = Bool(false) {
            didSet {
                UserDefaults.standard.set(isStarted, forKey: "highPassFilterIsStarted")
            }
        }
        
        
    }
    
   
}
