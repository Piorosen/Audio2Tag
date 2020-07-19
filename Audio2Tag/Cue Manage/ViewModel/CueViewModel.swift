//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftCueSheet

struct trackModel : Identifiable {
    let id = UUID()
    let track: Track
}
struct remModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}
struct metaModel : Identifiable {
    let id = UUID()
    let value: (key:String, value:String)
}

class CueViewModel : ObservableObject {
    
    @Published var isDocumentShow = false
    @Published var metaData = [metaModel]()
    @Published var remData = [remModel]()
    
    @Published var fileName = String()
    @Published var fileExt = String()
    @Published var track = [trackModel]()
    
    func addItem() {
        isDocumentShow = true
    }
    
    func loadItem(url: URL) {
        guard let cue = CueSheetParser().load(path: url) else {
            return
        }
        
        for (key, value) in cue.rem {
            remData.append(remModel(value: (key, value)))
        }
        for (key, value) in cue.meta {
            metaData.append(metaModel(value: (key, value)))
        }
        
        fileName = cue.file.fileName
        fileExt = cue.file.fileType
        
        track = cue.file.tracks.map( { t in trackModel(track: t)})
    }
    
    func testMakeItem() -> Void {
        let t1 = Bundle.main.path(forResource: "1.txt", ofType: nil)!
        let t2 = Bundle.main.path(forResource: "2.txt", ofType: nil)!
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let a1 = try? String(contentsOfFile: t1)
        let a2 = try? String(contentsOfFile: t2)
        
        try? a1?.write(to: url.appendingPathComponent("1.cue"), atomically: true, encoding: .utf8)
        try? a2?.write(to: url.appendingPathComponent("2.cue"), atomically: true, encoding: .utf8)
        
        
        //        print(item1.count)
        
    }
}
