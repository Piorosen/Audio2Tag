//
//  CueAudio.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/10/14.
//

import Foundation
import SwiftCueSheet

struct CueAudio {
    let isAudio:Bool
    let audio:InfoOfAudio?
    
    init(model: CueSheetModel) {
        if let audio = model.cueSheet?.info {
            self.audio = audio
            isAudio = true
        }else {
            self.audio = nil
            isAudio = false
        }
    }
}
