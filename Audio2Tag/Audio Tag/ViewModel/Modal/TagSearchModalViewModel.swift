//
//  TagSearchModalViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/06.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftVgmdb


class TagSearchModalViewModel : ObservableObject {
    @Published var trackList = [String]()
    @Published var albumList = [VDAlbum]()
    
    @Published var searchQuary = String()
    
    func searchTrack(select:VDAlbum) {
        SwiftVgmDb().getTrackList(id: select.id) { item in
            DispatchQueue.main.sync {
                self.trackList = item.trackInfo[.english]?.flatMap { $0 }
                                ?? item.trackInfo[.romjai]?.flatMap { $0 }
                                ?? item.trackInfo[.japanese]!.flatMap { $0 }
            }
            
        }
    }
    
    func searchAlbum() {
        
    }
    
    
}
