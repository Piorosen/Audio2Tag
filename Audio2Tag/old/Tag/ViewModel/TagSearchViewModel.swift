//
//  TagSearchViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/25.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftVgmdb

struct TagSearch : Identifiable {
    let id = UUID()
    var result: VDAlbum
}

class TagSearchViewModel : ObservableObject {
    @Published var items = [TagSearch]()
    @Published var searchText = ""
    @Published var showIndicator = false
    
    func musicBrainz(annotation: String) {
        
    }
    
    func vgmDB(annotation: String) {
        showIndicator = true
        SwiftVgmDb().getAlbumList(ack: VDSearchAnnotation(title: annotation)) { result in
            DispatchQueue.main.sync {
                self.items = result.map({ t in return TagSearch(result: t) })
                self.showIndicator = false
            }
            
        }
    }
    
}
