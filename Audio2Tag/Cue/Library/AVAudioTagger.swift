//
//  AVAudioTagger.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/13.
//

import Foundation
import SwiftCueSheet
import ID3TagEditor

struct CueSheetAudioTagger {
    var audio: URL
    var meta: CSMeta
    var rem: CSRem
    var track: CSTrack
}

final class AVAudioTagger {
    init(audio: [URL], cueSheet: CueSheet) {
        let item = audio.indices.map {
            CueSheetAudioTagger(audio: audio[$0],
                                meta: cueSheet.meta,
                                rem: cueSheet.rem,
                                track: cueSheet.file.tracks[$0])
        }
        
//        item.forEach {
//            ID32v4TagBuilder()
////                .album(frame: ID3FrameWithStringContent(content: $0.meta[.]))
//                .title(frame: ID3FrameWithStringContent(content: $0.track.meta[.title] ?? ""))
//                .albumArtist(frame: <#T##ID3FrameWithStringContent#>)
//                .build()
//            let item = try? ID3TagEditor().read(from: $0.audio.path)
//        }
    }
}
