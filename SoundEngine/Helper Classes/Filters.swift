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
    
    // AKToneFilter
    struct toneFilter: Codable {
        
        static var halfPowerPoint = Double(1.0)
        static var halfPowerPointRange = 20...20000
        static var isStarted = Bool(false)
        
    }
 
    struct toneComplementFilter: Codable {
        static var halfPowerPoint = Double()
        static var halfPowerPointRange = 20...20000
        static var isStarted = Bool(false)
    }
    
    struct highShelfFilter: Codable {
        static var cutOffFrequency = Double()
        static var gain = Double()
        static var isStarted = Bool(false)
    }
    
    struct lowShelfFilter: Codable {
        static var cutOffFrequency = Double()
        static var gain = Double()
        static var isStarted = Bool(false)
    }
    
    struct bandPassButterworthFilter: Codable {
        static var centerFrequency = Double()
        static var bandwidth = Double()
        static var isStarted = Bool(false)
    }

    struct bandRejectButterworthFilter: Codable {
        static var centerFrequency = Double()
        static var bandwidth = Double()
        static var isStarted = Bool(false)
    }
    
    struct lowPassButterworthFilter: Codable {
        static var cutoffFrequency = Double()
        static var isStarted = Bool(false)
    }
    
    struct highPassButterworthFilter: Codable {
        static var cutoffFrequency = Double()
        static var isStarted = Bool(false)
    }
    
    struct modalResonanceFilter: Codable {
        static var frequencyRange = 12...20000
        static var qualityFactorRange = 0...100
        static var isStarted = Bool(false)
    }
    struct resonantFilter: Codable {
        static var frequencyRange = 100...20000
        static var bandwidthRange = 0...10000
        static var isStarted = Bool(false)
    }
    
    struct peakingParametricEqualizerFilter: Codable {
        static var centerFrequency = Double()
        static var q = Double()
        static var gain = Double()
        static var isStarted = Bool(false)
    }
  
    struct lowShelfParametricEqualizerFilter: Codable {
        static var cornerFrequency = Double()
        static var q = Double()
        static var gain = Double()
        static var isStarted = Bool(false)
    }
    struct highShelfParametricEqualizerFilter: Codable {
        static var centerFrequency = Double()
        static var q = Double()
        static var gain = Double()
        static var isStarted = Bool(false)
    }
    
    struct formantFilter: Codable {
        static var centerFrequency = Double()
        static var attackDuration = Double()
        static var decayDuration = Double()
        static var isStarted = Bool(false)
    }
    
    struct rolandTB303Filter: Codable {
        static var cutoffFrequency = Double()
        static var resonance = Double()
        static var distortion = Double()
        static var resonanceAsymmetry = Double()
        static var isStarted = Bool(false)
    }
  
    struct korgLowPassFilter: Codable {
        static var cutoffFrequency = Double()
        static var resonance = Double()
        static var saturation = Double()
        static var isStarted = Bool(false)
    }
    
    struct threePoleLowpassFilter: Codable {
        static var cutoffFrequency = Double()
        static var resonance = Double()
        static var distortion = Double()
        static var isStarted = Bool(false)
    }

    struct moogLadder: Codable {
        
        // has presets
        // presetFogMoogLadder()
        // presetDullNoiseMoogLadder()
        // Print out current values in case you want to save it as a preset
        // printCurrentValuesAsPreset()
        
        static var cutoffFrequencyRange = 12...20000
        static var resonanceRange = 0...9.998
        static var isStarted = Bool(false)
    }
    
    struct dcBlock: Codable {
        static var isStarted = Bool(false)
    }
    
    struct stringResonator: Codable {
        static var fundamentalFrequencyRange = 5000...10000
        static var feedbackRange = 0.6...0.9
        static var isStarted = Bool(false)
    }
   
    struct combFilterReverb: Codable {
        static var reverbDuration = Double()
        static var loopDuration = Double()
        static var isStarted = Bool(false)
    }
   


    struct masterMixer: Codable {
        static var volume = Double(1.0)
    }
    
    // AKBooster
    struct masterBooster: Codable {
        
        static var gain = Double(1.0)
        static var isStarted = Bool(false)
    }
    
  
    
    // AKEqualizerFilter
    struct equalizerFilter: Codable {
        
        // A 2nd order tunable equalization filter that provides a peak/notch filter
        /// for building parametric/graphic equalizers. With gain above 1, there will be
        /// a peak at the center frequency with a width dependent on bandwidth. If gain
        /// is less than 1, a notch is formed around the center frequency.
        
        static var gainRange = 0...2  // 0.5 = -6dB , 0.7 = -3dB, 1 = 0, 1.4 = +3dB, 2 = +6dB
        
        static var isStarted = Bool(false)
        
      

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
