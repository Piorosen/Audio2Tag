//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/07/12.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import SwiftUI
import SwiftCueSheet
import CoreMedia
import ID3TagEditor

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
    @Published var isSplitPresented = false
    @Published var isDocumentShow = false
    @Published var isFolderShow = false
    
    @Published var metaData = [metaModel]()
    @Published var remData = [remModel]()
    
    @Published var fileName = String()
    @Published var fileExt = String()
    @Published var track = [trackModel]()
    
    
    
    func addItem() {
        isDocumentShow = true
    }
    
    
    func getCueSheet(_ url: [URL]) -> CueSheet? {
        fileURL = nil
        
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
            
            fileURL = url[abs(cueIndex - 1)]
            return CueSheetParser().loadFile(pathOfMusic: fileURL!, pathOfCue: url[cueIndex])
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
    
    func splitFile() -> Void {
        isSplitPresented = true
    }
    
    var fileURL:URL?
    func alertOK() -> Void {
        print("split Start")
        self.isFolderShow = true
    }
    
    func splitStart(url: URL) -> Void {
        print(url)
        if let fileUrl = fileURL {
            
            
            var data = [(URL, CMTimeRange)]()
            for item in self.track {
                print(item.track.startTime!.seconds / 100)
                let u = url.appendingPathComponent("\(item.track.title).wav")
                if FileManager.default.fileExists(atPath: u.path) {
                    try? FileManager.default.removeItem(at: u)
                }
                let r = CMTimeRange(start: CMTime(seconds: item.track.startTime!.seconds / 100, preferredTimescale: 1), duration: CMTime(seconds: item.track.duration!, preferredTimescale: 1))
                print(u)
                print(r)
                data.append((u, r))
            }
            AVAudioFileConverter(inputFileURL: fileUrl, outputFileURL: data)?.convert { percent in
                print(percent)
            }
        }
    }
    
    //    func testMakeItem() -> Void {
    //        let cues = Bundle.main.paths(forResourcesOfType: "cue", inDirectory: nil)
    //        let wavs = Bundle.main.paths(forResourcesOfType: "wav", inDirectory: nil)
    //
    //        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //
    //        for item in cues {
    //            let file = try? String(contentsOfFile: item)
    //            let last = URL(fileURLWithPath: item).lastPathComponent
    //            try? file?.write(to: url.appendingPathComponent(last), atomically: false, encoding: .utf8)
    //        }
    //
    //        for file in wavs {
    //            let last = URL(fileURLWithPath: file).lastPathComponent
    //
    //            try? FileManager.default.copyItem(at: URL(fileURLWithPath: file), to: url.appendingPathComponent(last))
    //        }
    //
    //        //        print(item1.count)
    //
    //    }
}
