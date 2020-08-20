//
//  CueModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftCueSheet

struct TrackModel : Identifiable {
    let id = UUID()
    let track: Track
}

struct RemModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

struct MetaModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

struct CueSheetModel : Identifiable {
    init(_ copy: CueSheetModel) {
        self.init(cueSheet: copy.cueSheet, cueUrl: copy.cueUrl, musicUrl: copy.musicUrl)
    }
    init(cueSheet:CueSheet? = nil, cueUrl:URL? = nil, musicUrl:URL? = nil) {
        self.cueSheet = cueSheet
        self.cueUrl = cueUrl
        self.musicUrl = musicUrl
        
        if let sheet = self.cueSheet {
            rem = sheet.rem.map { k, v in RemModel(value: (k,v))}
            meta = sheet.meta.map { k, v in MetaModel(value: (k,v))}
            tracks = sheet.file.tracks.map { t in TrackModel(track: t) }
        }
        else {
            rem = [RemModel]()
            meta = [MetaModel]()
            tracks = [TrackModel]()
        }
    }
    
    let id = UUID()
    let cueSheet: CueSheet?
    let cueUrl: URL?
    let musicUrl: URL?
    
    let rem: [RemModel]
    let meta: [MetaModel]
    let tracks: [TrackModel]
}
