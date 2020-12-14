//
//  CueSheetAudio.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/12/14.
//

import Foundation
import SwiftCueSheet
struct CueSheetAudio : Identifiable {
    var id = UUID()
    var validate: Bool {
        return audio != nil
    }
    var audio: CSAudio?
}
