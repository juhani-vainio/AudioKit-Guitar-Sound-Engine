//
//  Amp.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 10/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation
import AudioKit

class Amp {
    
    static let model = Amp()
    
    func defaultAmpModel(input: AKNode) -> AKNode {
      
        let lowPassFilter = AKLowPassFilter(input, cutoffFrequency: 3000, resonance: 0)
        let highPassFilter = AKHighPassFilter(lowPassFilter, cutoffFrequency: 100, resonance: 0)
        let tanhDistortion = AKTanhDistortion(highPassFilter, pregain: 1, postgain: 1, positiveShapeParameter: 1, negativeShapeParameter: 1)
       
        let mixer = AKMixer(tanhDistortion)
        return mixer
    }
    
    func myFirstAmpModel(input: AKNode) -> AKNode {
        
        let lowPassFilter = AKLowPassFilter(input, cutoffFrequency: 3000, resonance: 0)
        let highPassFilter = AKHighPassFilter(lowPassFilter, cutoffFrequency: 100, resonance: 0)
        let tanhDistortion = AKTanhDistortion(highPassFilter, pregain: 1, postgain: 1, positiveShapeParameter: 0.75, negativeShapeParameter: 0.75)
        let clipper = AKClipper(highPassFilter, limit: 0.75)
        
        let mixer = AKMixer([tanhDistortion, clipper])
        return mixer
    }
    
    func mySecondAmpModel(input: AKNode) -> AKNode {
        
        let lowPassFilter = AKLowPassFilter(input, cutoffFrequency: 3000, resonance: 0)
        let highPassFilter = AKHighPassFilter(lowPassFilter, cutoffFrequency: 100, resonance: 0)
        let tanhDistortion = AKTanhDistortion(highPassFilter, pregain: 1, postgain: 1, positiveShapeParameter: 0.9, negativeShapeParameter: 0.9)
        let chorus = AKChorus(tanhDistortion, frequency: 1, depth: 0.1, feedback: 0.4, dryWetMix: 0.5)
        let mixer = AKMixer(chorus)
        return mixer
    }
   
   
    
}
