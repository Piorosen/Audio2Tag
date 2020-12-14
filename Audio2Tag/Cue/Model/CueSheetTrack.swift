//
//  CueSheetTrack.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/12/11.
//

import Foundation
import SwiftCueSheet

struct CueSheetTrack : Identifiable {
    var id = UUID()
    
    public var meta: [CueSheetMeta]
    public var rem: [CueSheetRem]
    public var trackNum:Int
    public var trackType:String
    public var index:[CSIndex]
    public var startTime: Double?
    public var endTime: Double?
}
