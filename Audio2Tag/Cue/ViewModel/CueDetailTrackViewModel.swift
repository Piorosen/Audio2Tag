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
    @Published var key = String()
    @Published var value = String()
    
    let startTime: String
    let endTime:String
    let waitTime: String
    let durTime: String
    
    init(items: Binding<TrackModel>) {
        self._item = items
        let wrap = _item.wrappedValue
        rem = self._item.wrappedValue.track.rem.filter({ _, v in v != String() }).map({ k, v in RemModel(value: (k, v))})
        
        if let cmStartTime = wrap.track.startTime,
            let cmDuration = wrap.track.duration,
            let cmInterval = wrap.track.interval
        {
            let s = CMTimeGetSeconds(cmStartTime)
            
            startTime = s.makeTime()
            endTime = (s + cmDuration).makeTime()
            waitTime = cmInterval.makeTime()
            durTime = cmDuration.makeTime()
        }
        else {
            startTime = 0.makeTime()
            endTime = 0.makeTime()
            waitTime = 0.makeTime()
            durTime = 0.makeTime()
        }
    }
    
    func editDescription(type: CueDetailTrackDescription?) {
        if let type = type, value != "" {
            switch type {
            case .title:
                item.track.title = value
                print("\(value)")
            case .trackNum:
                item.track.trackNum = Int(value) ?? -1
                
            case .isrc:
                item.track.isrc = value
                
            case .performer:
                item.track.performer = value
                
            case .trackType:
                item.track.trackType = value
                
            case .songWriter:
                item.track.songWriter = value
            }
        }
    }
    
}
