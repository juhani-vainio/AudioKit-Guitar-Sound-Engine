//
//  Collections.swift
//  Sound Engineer
//
//  Created by Juhani Vainio on 05/11/2018.
//  Copyright © 2018 JuhaniVainio. All rights reserved.
//

import Foundation

class Collections: Codable {
        static var savedSounds = [String]()
        static var savedFilterSettings = [String]()
        static let cantTouchThis = ["bufferLength", "savedSounds", "activeSound", "inputBooster", "outputBoster", "NameOfSound", "Sounds"]
        static var specialEffects = ["dynaRageCompressor", "phaser"]
}


