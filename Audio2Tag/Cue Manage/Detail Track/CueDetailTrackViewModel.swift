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
    let item: trackModel
    let rem: [remModel]
    
    let startTime: String
    let endTime:String
    let waitTime: String
    
    static func makeTime(_ time: Double) -> String {
        let min = Int(time / 60)
        let second = Int(time) % 60
        let ms = Int(time * 1000) % 1000
        return String(format: "%dm, %ds, %dms", min, second, ms)
    }
    
    init(item: trackModel) {
        self.item = item
        
        var tmp = [remModel]()
        for (key, value) in item.track.rem {
            
            let data = remModel(value: (key, value))
            if data.value.value != String() {
                tmp.append(data)
            }
        }
        rem = tmp
        
        let s = CMTimeGetSeconds(item.track.startTime!) / 10000
        
        startTime = CueDetailTrackViewModel.makeTime(s)
        endTime = CueDetailTrackViewModel.makeTime(s + item.track.duration!)
        waitTime = CueDetailTrackViewModel.makeTime(item.track.interval ?? 0)
    }
    
}
