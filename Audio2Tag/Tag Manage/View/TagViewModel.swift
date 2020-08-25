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
    @Published var tagInfo = TagModel(tagVersion: .version2, tagFrame: .init())
    @Published var openSheet = false
    @Published var openAlert = false
    
    func traillingButtonAction() {
        openSheet = true
    }
    
    func loadAudio(url: URL) {
        guard let tag = (try? ID3TagEditor().read(from: url.path)) else {
            openAlert = true
            return
        }
        
        tagInfo = TagModel(tagVersion: .version2, tagFrame: tag.frames.map({ v in TagFrameModel(key: v.key, value: v.value)}))
        
    }
    
}
