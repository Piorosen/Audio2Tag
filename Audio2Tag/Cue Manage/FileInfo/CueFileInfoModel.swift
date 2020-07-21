//
//  CueFileInfoModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation

struct CueFileInfoModel : Identifiable {
    let id = UUID()
    
    var meta: [metaModel]
    var rem: [remModel]
    var track: [trackModel]
    
    var fileName: String
    var fileExt: String
}
