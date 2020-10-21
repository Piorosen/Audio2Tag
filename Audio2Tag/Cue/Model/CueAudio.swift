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
    let audio:CSAudio?
    
    init(model: CueSheetModel) {
        guard let url = model.musicUrl else {
            self.audio = nil
            isAudio = false
            return
        }
        guard var sheet = model.cueSheet else {
            self.audio = nil
            isAudio = false
            return
        }
        
        
        if let audio = sheet.getInfoOfAudio(music: url) {
            self.audio = audio
            isAudio = true
        }else {
            self.audio = nil
            isAudio = false
        }
        
    }
}
