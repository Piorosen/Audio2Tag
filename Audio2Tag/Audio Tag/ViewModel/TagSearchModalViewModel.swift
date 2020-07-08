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
    
    @Published var searchTitle = String()
    @Published var searchDiscNum = String()
    @Published var searchBarcode = String()
    @Published var searchComposer = [String]()
    @Published var searchArtist = [String]()
    @Published var searchPublisher = [String]()
    
    func searchTrack(select:VDAlbum) {
        SwiftVgmDb().getTrackList(id: select.id) { item in
            DispatchQueue.main.sync {
                self.trackList = item.trackInfo[.english]?.flatMap { $0 } ?? item.trackInfo[.romjai]!.flatMap { $0 }
            }
            
        }
    }
    
    func searchAlbum() {
        let annotation = VDSearchAnnotation(title: searchTitle, discNum: searchDiscNum, barcode: searchBarcode, composer: searchComposer, artist: searchArtist, publisher: searchPublisher)
        
        SwiftVgmDb().getAlbumList(ack: annotation) { item in
            DispatchQueue.main.sync {
                self.albumList = item
            }
            
        }
    }
    
    
}
