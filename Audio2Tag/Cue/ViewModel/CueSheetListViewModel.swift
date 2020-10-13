//
//  CueSheetListInfoViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI
import SwiftCueSheet

struct CueAudio {
    let isAudio:Bool
    let audio:InfoOfAudio?
    
    init(model: CueSheetModel) {
        if let audio = model.cueSheet?.info {
            self.audio = audio
            isAudio = true
        }else {
            self.audio = nil
            isAudio = false
        }
    }
}

class CueSheetListViewModel : ObservableObject {
    @Binding private  var fileInfo: CueSheetModel
    
    @Published var openSheet = false
    @Published var openAlert = false

    var audio:CueAudio {
        get{
            return CueAudio(model: fileInfo)
        }
    }
    
    var meta: [MetaModel] {
        get {
            return fileInfo.meta
        }
    }
    
    var rem: [RemModel] {
        get {
            return fileInfo.rem
        }
    }
    
    var tracks: [TrackModel] {
        get { return fileInfo.tracks }
    }
    
    var title: String {
        get { return fileInfo.cueSheet?.file.fileName ?? "" }
    }
    
    init(fileInfo: Binding<CueSheetModel>) {
        self._fileInfo = fileInfo
        
        
    }
    
}
