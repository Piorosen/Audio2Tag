//
//  CueDetailTrackViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftCueSheet
import CoreMedia

extension Double {
    func makeTime() -> String {
        let min = Int(self / 60)
        let second = Int(self) % 60
        let ms = Int(self * 1000) % 1000
        return String(format: "%dm, %ds, %dms", min, second, ms)
    }
}

class CueDetailTrackViewModel : ObservableObject {
    @Binding var item: TrackModel
    @Published var rem: [RemModel]
    @Published var track: CSTrack
    
    @Published var key = String()
    @Published var value = String()
    
    let startTime: String
    let endTime:String
    let waitTime: String
    let durTime: String
    
    init(items: Binding<TrackModel>) {
        self._item = items
        
        let wrap = _item.wrappedValue
        track = wrap.track
        
        rem = self._item.wrappedValue.track.rem.filter({ _, v in v != String() }).map({ k, v in RemModel(value: (k, v))})
        
        startTime = wrap.time.startTime.makeTime()
        durTime = wrap.time.duration.makeTime()
        waitTime = wrap.time.interval.makeTime()
        endTime = (wrap.time.startTime + wrap.time.duration).makeTime()
    }
    
    var remIdx: Int = -1
    var hint: String = String()
    func setRemEdit(idx: Int) {
        remIdx = idx
        self.key = rem[idx].value.key
        self.hint = rem[idx].value.value
//        descType = nil
//        openAlert = true
    }
    
    func editRem() {
        rem[remIdx] = RemModel(value: (key, value))
    }
    
    
    func getDescript(item: CueDetailTrackDescription) -> String {
        switch item {
        case .isrc:
            return track.isrc
        case .performer:
            return track.performer
        case .songWriter:
            return track.songWriter
        case .title:
            return track.title
        case .trackNum:
            return String(track.trackNum)
        case .trackType:
            return track.trackType
        }
    }
    
    func editDescription(type: CueDetailTrackDescription?) {
        if let type = type, value != "" {
            switch type {
            case .title:
                track.title = value
                
            case .trackNum:
                track.trackNum = Int(value) ?? -1
                
            case .isrc:
                track.isrc = value
                
            case .performer:
                track.performer = value
                
            case .trackType:
                track.trackType = value
                
            case .songWriter:
                track.songWriter = value
            }
        }
    }
    
    func disappear() {
        item.track = track
        item.track.rem = rem.filter { $0.value.key != "" && $0.value.value != "" }.reduce([String:String](), {
            result, item in
            var r = result
            r[item.value.key] = item.value.value
            return r
        })
    }
    
}
