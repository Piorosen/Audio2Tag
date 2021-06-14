//
//  CueSheetMeta.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/12/11.
//

import Foundation
import SwiftCueSheet

struct CueSheetMeta : Identifiable {
    var id = UUID()
    var key: CSMetaKey
    var value: String
}
