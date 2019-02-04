//
//  Presets.swift
//  SoundEngine
//
//  Created by Juhani Vainio on 31/01/2019.
//  Copyright © 2019 JuhaniVainio. All rights reserved.
//

import Foundation
import AudioKit
import AudioKitUI

class preset {
    static let shared = preset()

    static var presetAudioInputs = [AKInput]()
    
    func stopEverything() {
        
        // EFFECTS
        // Delay
        preset.delay = AKDelay()
        preset.variableDelay = AKVariableDelay()
        
        // Dynamics
        preset.dynaRageCompressor =  AKDynaRageCompressor()
        preset.compressor = AKCompressor()
        preset.dynamicsProcessor = AKDynamicsProcessor()
        preset.dynamicRangeCompressor = AKDynamicRangeCompressor()
        
        // Distorion effects
        preset.bitCrusher =  AKBitCrusher()
        preset.clipper =  AKClipper()
        preset.tanhDistortion = AKTanhDistortion()
        preset.decimator = AKDecimator()
        preset.ringModulator = AKRingModulator()
        
        // Modulation effects
        preset.flanger = AKFlanger()
        preset.phaser = AKPhaser()
        preset.chorus = AKChorus()
        
        
        // Reverb
        preset.chowningReverb = AKChowningReverb()
        preset.costelloReverb = AKCostelloReverb()
        preset.flatFrequencyResponseReverb = AKFlatFrequencyResponseReverb()
        preset.reverb = AKReverb()
        preset.reverb2 = AKReverb2()
        
        // Simulators
        preset.rhinoGuitarProcessor = AKRhinoGuitarProcessor()
        
        // tremolo
        preset.tremolo = AKTremolo()
        
        preset.autoWah =  AKAutoWah()
        
        // FILTERS
        
        // 3 - BAND
        let threeRatio = 0.7
        preset.threeBandFilterHigh = AKEqualizerFilter()
        preset.threeBandFilterHigh?.centerFrequency = 2000
        preset.threeBandFilterHigh?.bandwidth = 2000 * threeRatio
        preset.threeBandFilterHigh?.gain = 1
        
        preset.threeBandFilterMid = AKEqualizerFilter()
        preset.threeBandFilterMid?.centerFrequency = 500
        preset.threeBandFilterMid?.bandwidth = 500 * threeRatio
        preset.threeBandFilterMid?.gain = 1
        
        preset.threeBandFilterLow = AKEqualizerFilter()
        preset.threeBandFilterLow?.centerFrequency = 100
        preset.threeBandFilterLow?.bandwidth = 100 * threeRatio
        preset.threeBandFilterLow?.gain = 1
        
        
        // 7 - BAND
        let sevenRatio = (0.5)
        //https://www.teachmeaudio.com/mixing/techniques/audio-spectrum/
        preset.sevenBandFilterBrilliance = AKEqualizerFilter()   // 6 kHz to 20 kHz
        preset.sevenBandFilterBrilliance?.centerFrequency = 6400
        preset.sevenBandFilterBrilliance?.bandwidth = 6400 * sevenRatio
        preset.sevenBandFilterBrilliance?.gain = 1
        
        
        preset.sevenBandFilterPrecence = AKEqualizerFilter()     // 4 kHz to 6 kHz
        preset.sevenBandFilterPrecence?.centerFrequency = 4200
        preset.sevenBandFilterPrecence?.bandwidth = 4200 * sevenRatio
        preset.sevenBandFilterPrecence?.gain = 1
        
        preset.sevenBandFilterUpperMid = AKEqualizerFilter()     // 2 to 4 kHz
        preset.sevenBandFilterUpperMid?.centerFrequency = 2000
        preset.sevenBandFilterUpperMid?.bandwidth = 2000 * sevenRatio
        preset.sevenBandFilterUpperMid?.gain = 1
        
        preset.sevenBandFilterMid = AKEqualizerFilter()          // 500 Hz to 2 kHz
        preset.sevenBandFilterMid?.centerFrequency = 500
        preset.sevenBandFilterMid?.bandwidth = 500 * sevenRatio
        preset.sevenBandFilterMid?.gain = 1
        
        preset.sevenBandFilterLowMid = AKEqualizerFilter()       // 250 to 500 Hz
        preset.sevenBandFilterLowMid?.centerFrequency = 250
        preset.sevenBandFilterLowMid?.bandwidth = 250 * sevenRatio
        preset.sevenBandFilterLowMid?.gain = 1
        
        preset.sevenBandFilterBass = AKEqualizerFilter()    // 60 to 250 Hz
        preset.sevenBandFilterBass?.centerFrequency = 70
        preset.sevenBandFilterBass?.bandwidth = 70 * sevenRatio
        preset.sevenBandFilterBass?.gain = 1
        
        preset.sevenBandFilterSubBass = AKEqualizerFilter() // 20 to 60 Hz
        preset.sevenBandFilterSubBass?.centerFrequency = 30
        preset.sevenBandFilterSubBass?.bandwidth = 30 * sevenRatio
        preset.sevenBandFilterSubBass?.gain = 1
        
        
        
        preset.highPassFilter = AKHighPassFilter()
        preset.lowPassFilter = AKLowPassFilter()
        
        preset.toneComplementFilter = AKToneComplementFilter()
        
        preset.highShelfFilter = AKHighShelfFilter()
        preset.lowShelfFilter = AKLowShelfFilter()
        
        preset.bandPassButterworthFilter = AKBandPassButterworthFilter()
        preset.bandRejectButterworthFilter = AKBandRejectButterworthFilter()
        preset.lowPassButterworthFilter = AKLowPassButterworthFilter()
        preset.highPassButterworthFilter = AKHighPassButterworthFilter()
        
        preset.modalResonanceFilter = AKModalResonanceFilter()
        preset.resonantFilter = AKResonantFilter()
        
        
        preset.peakingParametricEqualizerFilter = AKPeakingParametricEqualizerFilter()
        preset.lowShelfParametricEqualizerFilter = AKLowShelfParametricEqualizerFilter()
        preset.highShelfParametricEqualizerFilter = AKHighShelfParametricEqualizerFilter()
        
        preset.formantFilter = AKFormantFilter()
        preset.rolandTB303Filter = AKRolandTB303Filter()
        preset.korgLowPassFilter = AKKorgLowPassFilter()
        preset.threePoleLowpassFilter = AKThreePoleLowpassFilter()
        
        preset.moogLadder = AKMoogLadder()
        
        
        preset.dcBlock = AKDCBlock()
        preset.stringResonator = AKStringResonator()
    }
    
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
    
    static var highPassFilter : AKHighPassFilter?
    static var lowPassFilter: AKLowPassFilter?
    static var lowPassButterworthFilter: AKLowPassButterworthFilter?
    static var highPassButterworthFilter: AKHighPassButterworthFilter?
    
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
    
}
