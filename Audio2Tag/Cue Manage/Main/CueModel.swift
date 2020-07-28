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
    let id = UUID()
    let cueSheet: CueSheet?
    let cueUrl: URL?
    let musicUrl: URL?
    
    var rem: [RemModel] {
        get {
            guard let cueSheet = cueSheet else {
                return [RemModel]()
            }
            return cueSheet.rem.map { k, v in RemModel(value: (k,v))}
        }
    }
    var meta: [MetaModel] {
        get {
            guard let cueSheet = cueSheet else {
                return [MetaModel]()
            }
            return cueSheet.meta.map { k, v in MetaModel(value: (k,v))}
        }
    }
    var tracks: [TrackModel] {
        get {
            guard let cueSheet = cueSheet else {
                return [TrackModel]()
            }
            return cueSheet.file.tracks.map { t in TrackModel(track: t) }
        }
    }
}
