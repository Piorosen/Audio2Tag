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


class CueDetailTrackViewModel : ObservableObject {
    let item: TrackModel
    let rem: [RemModel]
    
    let startTime: String
    let endTime:String
    let waitTime: String
    let durTime: String
    
    static func makeTime(_ time: Double) -> String {
        let min = Int(time / 60)
        let second = Int(time) % 60
        let ms = Int(time * 1000) % 1000
        return String(format: "%dm, %ds, %dms", min, second, ms)
    }
    
    init(item: TrackModel) {
        self.item = item
        
        var tmp = [RemModel]()
        for (key, value) in item.track.rem {
            
            let data = RemModel(value: (key, value))
            if data.value.value != String() {
                tmp.append(data)
            }
        }
        rem = tmp
        
        if let cmStartTime = item.track.startTime,
            let cmDuration = item.track.duration,
            let cmInterval = item.track.interval
        {
            let s = CMTimeGetSeconds(cmStartTime) / 100
            
            startTime = CueDetailTrackViewModel.makeTime(s)
            endTime = CueDetailTrackViewModel.makeTime(s + cmDuration)
            waitTime = CueDetailTrackViewModel.makeTime(cmInterval)
            durTime = CueDetailTrackViewModel.makeTime(cmDuration)
        }
        else {
            startTime = CueDetailTrackViewModel.makeTime(0)
            endTime = CueDetailTrackViewModel.makeTime(0)
            waitTime = CueDetailTrackViewModel.makeTime(0)
            durTime = CueDetailTrackViewModel.makeTime(0)
        }
    }
    
}
