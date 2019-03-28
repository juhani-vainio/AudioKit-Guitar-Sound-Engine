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

    let bitCrusherInfo = "A Bitcrusher is a lo-fi (low fidelity) digital audio effect, which produces a distortion by the reduction of the resolution or bandwidth of digital audio data. The resulting quantization noise may produce a “warmer” sound impression, or a harsh one, depending on the amount of reduction."
    // https://en.wikipedia.org/wiki/Bitcrusher
    
    // controls needed : 2
    // bitDepth
    // sampleRate
    
    static var bitDepthRange = 1.0 ... 20.0
    static var sampleRateRange = 40 ... 4_000.0

}
    
    // TANH DISTORTION AKTanhDistortion
    // Tag = 2
    struct tanhDistortion:Codable {
        
        let tanhInfo = "This distortion technique involves using a mathematical function to directly modify the values of the audio signal. The tanh() function can give a rounded SOFT CLIPPING kind of distortion, and the distortion amount is proportional to the input gain. "
        // http://folk.ntnu.no/oyvinbra/gdsp/Lesson4tanh.html
        
        // controls needed : 4
        // pregain
        // postgain
        // positiveShapeParameter
        // negativeShapeParameter
        
        static var pregainRange = 0...10
        static var postgainRange = 0...10
        static var positiveShapeParameterRange = -10...10
        static var negativeShapeParameterRange = -10...10
        
        
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
    static var amplitudeRange = 0...1
  
    }

    
// DELAY    AKDelay
// Tag = 5
struct delay:Codable {
    
    let delayInfo = "delay or echo - To simulate the effect of reverberation in a large hall or cavern, one or several delayed signals are added to the original signal. To be perceived as echo, the delay has to be of order 35 milliseconds or above. Short of actually playing a sound in the desired environment, the effect of echo can be implemented using either digital or analog methods. Analog echo effects are implemented using tape delays or bucket-brigade devices. When large numbers of delayed signals are mixed a reverberation effect is produced; The resulting sound has the effect of being presented in a large room."
    // https://en.wikipedia.org/wiki/Audio_signal_processing
    
    

    // controls needed : 4 + 3-way switch for presets
    // time
    // feedback
    // lowPassCutOff
    // dryWetMix
    
    
    // Has presets
    //presetShortDelay()
    //presetDenseLongDelay()
    //presetElectricCircuitsDelay()

        
    static var timeRange = 0.001...2
    static var feedbackRange = 0...1
    static var dryWetMixRange = 0.1...0.99
    static var lowPassCutOffRange = 10000...20000
  

    }
    
    // VARIABLE DELAY    AKVariableDelay
    // Tag = 5
    struct variableDelay:Codable {
        
        // controls needed : 2
        // time
        // feedback
        // maximumDelayTime
  
        static var timeRange = 0...10   // This value must not exceed the maximum delay time.
        static var feedbackRange = 0...1
       //   static var maximumDelayTimeRange = 0.0001...3

    }
    
    // BOOSTER
    struct booster:Codable {
        
        // controls needed : 1
        // gain
       
        static var dBRange = -16...16
        static var gainRange = 0.01...100
        
    }
    
  
    
    
// DECIMATOR  AKDecimator
// Tag = 6
struct decimator:Codable {
    
    let decimatorInfo = "Loosely speaking, “decimation” is the process of reducing the sampling rate. In practice, this usually implies lowpass-filtering a signal, then throwing away some of its samples. Downsampling is a more specific term which refers to just the process of throwing away samples, without the lowpass filtering operation. Throughout this FAQ, though, we’ll just use the term “decimation” loosely, sometimes to mean “downsampling”."
    // https://dspguru.com/dsp/faqs/multirate/decimation/
    
  
         // controls needed : 3
        // decimation
        // rounding
        // mix
        
        static var decimationRange = 0.0 ... 1.0
        static var roundingRange = 0.0 ... 1.0
        static var mixRange = 0.0 ... 1.0


        
    }
    
    // CLIPPER    AKClipper
    // Tag 7
    struct clipper:Codable {
        
        let clipperInfo = "Clips a signal to a predefined limit, in a soft manner, using one of three methods"
        // AUDIOKIT docs
        
        // controls needed : 1
        // limit
    
        static var limitRange = 0.01 ... 1.0
        
    }
    

    // RING MODULATOR  AKRingModulator
    // Tag= 8
    struct ringModulator:Codable {
        
        let modulatorInfo = "modulation - to change the frequency or amplitude of a carrier signal in relation to a predefined signal. Ring modulation, also known as amplitude modulation, is an effect made famous by Doctor Who's Daleks and commonly used throughout sci-fi."
        // https://en.wikipedia.org/wiki/Audio_signal_processing
        
            // controls needed : 4
        // frequency1
        // frequency2
        // balance
        // mix
        
        static var frequencyRange = 0.5...8000
        static var balanceRange = 0...1
        static var mixRange = 0...1
        
        }
        
        // FLANGER  AKFlanger
        // Tag= 9
        struct flanger:Codable {
            //  is a modulation effect
            let flangerInfo = "flanger - to create an unusual sound, a delayed signal is added to the original signal with a continuously variable delay (usually smaller than 10 ms). This effect is now done electronically using DSP, but originally the effect was created by playing the same recording on two synchronized tape players, and then mixing the signals together. As long as the machines were synchronized, the mix would sound more-or-less normal, but if the operator placed his finger on the flange of one of the players (hence flanger), that machine would slow down and its signal would fall out-of-phase with its partner, producing a phasing effect. Once the operator took his finger off, the player would speed up until its tachometer was back in phase with the master, and as this happened, the phasing effect would appear to slide up the frequency spectrum. This phasing up-and-down the register can be performed rhythmically."
            // https://en.wikipedia.org/wiki/Audio_signal_processing
            
            
            // controls needed : 4
            // frequency
            // depth
            // feedback
            // dryWetMix
            
            static var frequencyRange = 0.1...10
            static var depthRange = 0...1
            static var feedbackRange = -0.95...0.95
            static var dryWetMixRange = 0...1
            
        }
        
        // PHASER  AKPhaser
        // Tag= 10
        struct phaser:Codable {
            //  is a modulation effect
            let phaserInfo = "phaser - another way of creating an unusual sound; the signal is split, a portion is filtered with an all-pass filter to produce a phase-shift, and then the unfiltered and filtered signals are mixed. The phaser effect was originally a simpler implementation of the flanger effect since delays were difficult to implement with analog equipment. Phasers are often used to give a synthesized or electronic effect to natural sounds, such as human speech. The voice of C-3PO from Star Wars was created by taking the actor's voice and treating it with a phaser."
            // https://en.wikipedia.org/wiki/Audio_signal_processing
            
            // controls needed : 7
            // notchMinimumFrequency
            // notchMaximumFrequency
            // notchWidth
            // notchFrequency
            // vibratoMode        // Direct or Vibrato (default)
            // depth
            // feedback
            // inverted
            // lfoBPM           // Low-frequency oscillation (LFO)   Beats Per Minute (BPM)
         
            
            static var notchMinimumFrequencyRange = 20...5000
            static var notchMaximumFrequencyRange = 20...10000
            
            static var notchWidthRange = 10...5000
            static var notchFrequencyRange = 1.1...4
            static var vibratoModeRange = 0...1
            // inverted    1 or 0                   Bool?   UISwitch    default = 0
            static var depthRange = 0...1
            static var feedbackRange = 0...1
            static var lfoBPMRange = 24...360
            
        }
        
        
        // CHORUS  AKChorus
        // Tag= 11
        struct chorus:Codable {
            //  is a modulation effect
            let chorusInfo = "chorus - a delayed signal is added to the original signal with a constant delay. The delay has to be short in order not to be perceived as echo, but above 5 ms to be audible. If the delay is too short, it will destructively interfere with the un-delayed signal and create a flanging effect. Often, the delayed signals will be slightly pitch shifted to more realistically convey the effect of multiple voices."
            // https://en.wikipedia.org/wiki/Audio_signal_processing
         
            // controls needed : 4
            // frequency
            // depth
            // feedback
            // dryWetMix
            
            static var frequencyRange = 0.1...10
            static var depthRange = 0...1
            static var feedbackRange = 0...0.25
            static var dryWetMixRange = 0...1
            
        }
        
        // COMPRESSOR  AKCompressor
        // Tag= 11
        struct compressor:Codable {
            //  is a dynamics
            
            // controls needed : 6
            // threshold
            // headRoom
            // attackDuration
            // releaseDuration
            // masterGain
            // dryWetMix
            
            static var thresholdRange = -40...20 // dB default -20
            static var headRoomRange = 0.1...40 // dB default 5
            static var attackDurationRange = 0.0001...0.2 // Default: 0.001
            static var releaseDurationRange = 0.01...3 // Default: 0.05
            static var masterGainRange = -8...8 //  -40...40    dB Default: 0
            static var dryWetMixRange = 0...1
        }
    
    // DYNAMIC RANGE COMPRESSOR AKDynamicRangeCompressor
    // Dynamic range compressor from Faust
    
    struct dynamicRangeCompressor:Codable {
        //  is a dynamics
        
        // controls needed : 4
        // ratio
        // threshold
        // attackDuration: Double = 0.001,
        // releaseDuration: Double = 0.05,
        
        static var ratioRange = 0.01...100   // Ratio to compress with, a value > 1 will compress
        static var thresholdRange = -100...0  // dB
        static var attackDurationRange = 0...1
        static var releaseDurationRange = 0...1 // Default: 0.1
        
    }
     
        // DYNAMICS PROCESSOR AKDynamicsProcessor
        // AudioKit version of Apple’s DynamicsProcessor Audio Unit
        struct dynamicsProcessor:Codable {
            //  is a dynamics
            
            // controls needed : 8
            // threshold: Double = -20,
            // headRoom: Double = 5,
            // expansionRatio: Double = 2,
            // expansionThreshold: Double = 2,
            // attackDuration: Double = 0.001,
            // releaseDuration: Double = 0.05,
            // masterGain: Double = 0,
            // compressionAmount: Double = 0,
            // inputAmplitude: Double = 0,
            // outputAmplitude: Double = 0)

        
            static var thresholdRange = -100...20 // dB default -20
            static var headRoomRange = 0.1...40 // dB default 5
            static var expansionRatioRange = 1...50  // default 2
            static var expansionThresholdRange = -120...0 // default 0
            static var attackDurationRange = 0.001...0.3 // Default: 0.001
            static var releaseDurationRange = 0.01...3 // Default: 0.05
            static var masterGainRange = -8...8 // -40...40 dB Default: 0
            // GET ONLY  static var compressionAmountRange = -40...40 //  dB Default: 0
            // GET ONLY  static var inputAmplitudeRange = -40...40 //  dB Default: 0
            // GET ONLY  static var outputAmplitudeRange = -40...40 //  dB Default: 0
            static var dryWetMixRange = 0...1
        }
    
    
    
  
        
        // COMPRESSOR    AKDynaRageCompressor
   
        struct dynaRageCompressor:Codable {
            // is a guitar processor
            let compressionInfo = "compression - the reduction of the dynamic range of a sound to avoid unintentional fluctuation in the dynamics."
            
            // controls needed : 4 + 1 + switch
            // ratio
            // threshold
            // attackDuration
            // releaseDuration
            
            // + rage
            // + rage switch
            
            static var ratioRange = 0...20
            static var thresholdRange = -100...0
            static var attackDurationRange = 0...1   // 0,1 ms
            static var releaseDurationRange = 0...1
            static var rageRatio = 0.1...20
            
        }
    
    // reverb    AKReverb
   
    struct reverb:Codable {
        
      static var dryWetMixRange = 0...1
        
    }
    
    // reverb2    AKReverb2

    struct reverb2:Codable {
        
        // controls : 7
       
        static var gainRange = -20...20 //  dB Default: 0
        static var minDelayTimeRange = 0.0001...1.0 // (Default: 0.008)
        static var maxDelayTimeRange = 0.0001...1.0 // (Default: 0.050)
        static var decayTimeAt0HzRange = 0.01...20.0 // (Default: 1.0)
        static var decayTimeAtNyquistRange = 0.001...20.0 // (Default: 0.5)
        static var randomizeReflectionsRange = 1...1000 //(Default: 1)
        static var dryWetMixRange = 0...1
        
    }
    
    // chowningReverb    AKChowningReverb
    
    struct chowningReverb:Codable {
        
        
    }
    
    // costelloReverb    AKCostelloReverb
    
    struct costelloReverb:Codable {
        
        // controls : 2
        // has presets
        // presetShortTailCostelloReverb()
        // presetLowRingingLongTailCostelloReverb()
        // Print out current values in case you want to save it as a preset
        // printCurrentValuesAsPreset()
        
        static var cutOffRange = 12...20000  // default 4000
        static var feedbackRange = 0...1
     
        // 0.6 gives a good small ‘live’ room sound, 0.8 a small hall, and 0.9 a large hall. A setting of exactly 1 means infinite length, while higher values will make the opcode unstable.
        
    }
    //flatFrequencyResponseReverb AKFlatFrequencyResponseReverb
    
    struct flatFrequencyResponseReverb:Codable {
        
        // controls :
        
        static var reverbDurationRange = 0...10
       // static var loopDurationRange = 0.0001...1.0 // (Default: 0.008)
     
        
    }
    
   
    
    // AKTremolo
    struct tremolo:Codable {
        
        // controls :
        
        // frequencyRange
        // depth
        // waveform: AKTable = AKTable(.nameOfForm)   11 options
       
        static var frequencyRange = 0...100
        static var depthRange = 0...1
    }
    
    
    
    
    
    
    
    
    
    
    // TODO OOOOO
  
    
    struct peakLimiter:Codable {
        
        
    }
    
    struct expander:Codable {
        
        
    }
    
    
    
    
    // simulator
    //rhinoGuitarProcessor AKRhinoGuitarProcessor
    
    struct rhinoGuitarProcessor:Codable {
              // is a guitar processor
        // controls :
        
        // postGain
        // lowGain
        // midGain
        // highGain
        // distortion
        static var eqGainRange = 0...3
        static var distortionRange = 0...20
        static var preGainRange = 0.1...10
        static var postGainRange = 0...1
        static var volumeRange = 0...16
    }
    
    
    
    //     AKDistortion
    
    struct distortion:Codable {
        
        static var delayRange = 0.1...500 // (Milliseconds) ranges from 0.1 to 500 (Default: 0.1)
        static var decayRange = 0.1...50 // (Rate) ranges from 0.1 to 50 (Default: 1.0)
        static var normalRange = 0...1  // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
        static var ringModFreqRange = 0.5...8000   // (Hertz) ranges from 0.5 to 8000 (Default: 100)
        static var softClipGainRange = -80...20   // (dB) ranges from -80 to 20 (Default: -6)

         // delay: Double = 0.1 // (Milliseconds) ranges from 0.1 to 500 (Default: 0.1)
         // decay: Double = 0.1 // (Rate) ranges from 0.1 to 50 (Default: 1.0)
         // delayMix: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         // decimation: Double = 0.0 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         // rounding: Double = 0.0 // (Normalized Value) ranges from 0 to 1 (Default: 0.0)
         // decimationMix: Double = 0.0 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         // linearTerm: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         // squaredTerm: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         //  cubicTerm: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         //  polynomialMix: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         //  ringModFreq1: Double = 100 // (Hertz) ranges from 0.5 to 8000 (Default: 100)
         // ringModFreq2: Double = 100 // (Hertz) ranges from 0.5 to 8000 (Default: 100)
         //  ringModBalance: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)
         //  ringModMix: Double = 0.0 // (Normalized Value) ranges from 0 to 1 (Default: 0.0)
         //  softClipGain: Double = -6 // (dB) ranges from -80 to 20 (Default: -6)
         //  finalMix: Double = 0.1 // (Normalized Value) ranges from 0 to 1 (Default: 0.5)

    }
    
}


