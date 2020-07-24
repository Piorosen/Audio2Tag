//
//  CueModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftCueSheet

struct trackModel : Identifiable {
    let id = UUID()
    let track: Track
}

struct remModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

struct metaModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}
