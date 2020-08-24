//
//  TagViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/24.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import ID3TagEditor
import MobileCoreServices

class TagViewModel : ObservableObject {
    @Published var tagInfo = TagModel()
    @Published var openSheet = false
    
    func traillingButtonAction() {
        openSheet = true
    }
    
    func loadAudio(url: URL) {
        
    }
    
}
