//
//  CueModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftCueSheet


extension CSRemKey {
    var toString:String {
        switch self {
        case .others(let p):
            return p
        default:
            return self.caseName
        }
        
    }
}

extension CSMetaKey {
    var toString:String {
        switch self {
        case .others(let p):
            return p
        default:
            return self.caseName
        }
        
    }
}

struct TrackModel : Identifiable {
    let id = UUID()
    var track: CSTrack
    let time: CSLengthOfAudio
}

struct RemModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

struct MetaModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

struct CueSheetModel : Identifiable, Equatable {
    static func == (lhs: CueSheetModel, rhs: CueSheetModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    init(_ copy: CueSheetModel) {
        self.init(cueSheet: copy.cueSheet, cueUrl: copy.cueUrl, musicUrl: copy.musicUrl)
    }
    init(cueSheet:CueSheet? = nil, cueUrl:URL? = nil, musicUrl:URL? = nil) {
        self.cueSheet = cueSheet
        self.cueUrl = cueUrl
        self.musicUrl = musicUrl
        
        if var sheet = self.cueSheet {
            if let musicUrl = musicUrl {
                let _ = try? sheet.getInfoOfAudio(music: musicUrl)
            }
            
            rem = sheet.rem.map { k, v in RemModel(value: (k.toString.uppercased(),v))}
            meta = sheet.meta.map { k, v in MetaModel(value: (k.toString.uppercased(),v))}
            let time = sheet.calcTime()
            tracks = sheet.file.tracks.indices.map { idx in TrackModel(track: sheet.file.tracks[idx], time: time[idx]) }
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
    
    var rem: [RemModel]
    var meta: [MetaModel]
    var tracks: [TrackModel]
}
