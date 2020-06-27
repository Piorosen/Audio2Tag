//
//  CueModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct CueModel : Identifiable {
    var id = UUID()
    
    var index:Int
    var fileName: String
    var artist: String
    
    var duration: Double
    var interval: Double
}
