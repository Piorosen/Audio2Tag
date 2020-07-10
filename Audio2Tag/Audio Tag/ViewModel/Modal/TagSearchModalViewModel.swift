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
    @Published var isActive:Bool = false
    @Published var payback:VDTrack = VDTrack.instance()
    
    @Published var title = String()
    @Published var discNum = String()
    @Published var barcode = String()
    @Published var composer = String()
    @Published var artist = String()
    @Published var publisher = String()
    
    @Published var isLoading = false
    @Published var isActivity = false
    
    var param = [VDAlbum]()
    
    func next() {
        isLoading = true
        isActivity = false
        search { value in
            self.param = value
            self.isLoading = false
            self.isActivity = true
        }
    }
    
    func search(completeHanlder: @escaping ([VDAlbum]) -> Void) {
        SwiftVgmDb().getAlbumList(ack: self.makeQuary()) { value in
            completeHanlder(value)
        }
    }
    
    private func makeQuary() -> VDSearchAnnotation {
        let title = self.title
        let discNum = self.discNum
        let barcode = self.barcode
        let composer = [self.composer]
        let artist = [self.artist]
        let publisher = [self.publisher]
        
        return VDSearchAnnotation(title: title, discNum: discNum, barcode: barcode, composer: composer, artist: artist, publisher: publisher)
    }
    
}


//class TagSearchModalViewModel : ObservableObject {
//    @Published var trackList = [String]()
//    @Published var albumList = [VDAlbum]()
//
//    @Published var searchQuary = String()
//
//    func searchTrack(select:VDAlbum) {
//        SwiftVgmDb().getTrackList(id: select.id) { item in
//            DispatchQueue.main.sync {
//                self.trackList = item.trackInfo[.english]?.flatMap { $0 }
//                                ?? item.trackInfo[.romjai]?.flatMap { $0 }
//                                ?? item.trackInfo[.japanese]!.flatMap { $0 }
//            }
//
//        }
//    }
//
//    func searchAlbum() {
//
//    }
//
//
//}
