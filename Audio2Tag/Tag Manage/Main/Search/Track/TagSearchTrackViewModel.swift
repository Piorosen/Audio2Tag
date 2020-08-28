//
//  TagSearchTrackViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftVgmdb

class TagSearchTrackViewModel : ObservableObject {
    var album = [VDTrackInfo : String]()
    var items = [String]()
    @Published var showIndicator = false
    
    func musicBrainz(id:String) {
        
    }
    func vgmDb(id:String) {
        showIndicator = true
        _ = SwiftVgmDb().getTrackList(id: Int(id)!) { track in
            DispatchQueue.main.sync {
                self.album = track.albumInfo
                self.items = track.trackInfo[.romjai]?.flatMap { $0 } ??
                            track.trackInfo[.english]?.flatMap { $0 } ??
                            track.trackInfo[.japanese]?.flatMap { $0 } ??
                            [String]()
                self.showIndicator = false
            }
        }
    }
}
