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
    
    
    func getCueSheet(_ url: [URL]) -> CueSheet? {
        if url.count == 1 {
            let parser = CueSheetParser()
            guard let item = parser.loadFile(cue: url[0]) else {
                return nil
            }

            return parser.calcTime(sheet: item, lengthOfMusic: 0)
        }
        else if url.count == 2 {
            var cueIndex = -1
            for index in url.indices {
                if url[index].pathExtension.lowercased() == "cue" {
                    cueIndex = index
                    break
                }
            }
            
            if cueIndex == -1 {
                return nil
            }
            
            return CueSheetParser().loadFile(pathOfMusic: url[abs(cueIndex - 1)], pathOfCue: url[cueIndex])
        }
        else {
            return nil
        }
    }
    
    func loadItem(url: [URL]) {
        guard let cue = getCueSheet(url) else {
            return
        }
        remData.removeAll()
        metaData.removeAll()
        
        for (key, value) in cue.rem {
            let data = remModel(value: (key, value))
            if data.value.value != String() {
                remData.append(data)
            }
        }
        for (key, value) in cue.meta {
            let data = metaModel(value: (key, value))
            if data.value.value != String() {
                metaData.append(data)
            }   
        }
        
        fileName = cue.file.fileName
        fileExt = cue.file.fileType
        
        track = cue.file.tracks.map( { t in trackModel(track: t)})
    }
    
    func testMakeItem() -> Void {
        let cues = Bundle.main.paths(forResourcesOfType: "cue", inDirectory: nil)
        let wavs = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: nil)
        
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        for item in cues {
            let file = try? String(contentsOfFile: item)
            let last = URL(fileURLWithPath: item).lastPathComponent
            try? file?.write(to: url.appendingPathComponent(last), atomically: false, encoding: .utf8)
        }
        
        for file in wavs {
            let last = URL(fileURLWithPath: file).lastPathComponent
            
            try? FileManager.default.copyItem(at: URL(fileURLWithPath: file), to: url.appendingPathComponent(last))
        }
        
        //        print(item1.count)
        
    }
}

