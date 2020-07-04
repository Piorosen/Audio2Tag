//
//  TagMainViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/22.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import CoreImage
import SwiftUI

class TagMainViewModel : ObservableObject {
    @Published var item = [TagMainModel]()
    
    @Published var artist       = String()
    @Published var album        = String()
    @Published var year         = String()
    @Published var track        = String()
    @Published var genre        = String()
    @Published var comment      = String()
    @Published var directory    = String()
    @Published var albumArtist  = String()
    @Published var composer     = String()
    @Published var discNum      = String()
    
    @Published var images = [CGImage]()
    
    func make() {
        item.append(TagMainModel(index: item.count, title: UUID().uuidString, directory: "dir", fileName: "item\(item.count)"))
    }
}
