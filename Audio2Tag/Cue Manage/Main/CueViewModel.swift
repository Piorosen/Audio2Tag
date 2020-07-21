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
import AVFoundation

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
    @Published var cueFileInfo = CueFileInfoModel(meta: [metaModel](), rem: [remModel](), track: [trackModel](), fileName: "", fileExt: "")
    
    @Published var isSplitPresented = false
    @Published var isDocumentShow = false
    @Published var isFolderShow = false
    @Published var isProgressShow = false
    
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
                if url[index].pathExtension.lowercased() == "cue" || url[index].pathExtension.lowercased() == "txt" {
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
    var cue:CueSheet? = nil
    
    func loadItem(url: [URL]) {
        guard let cue = getCueSheet(url) else {
            return
        }
        self.cue = cue
        
        var meta = [metaModel]()
        var rem = [remModel]()
        
        for (key, value) in cue.rem {
            let data = remModel(value: (key, value))
            if data.value.value != String() {
                rem.append(data)
            }
        }
        for (key, value) in cue.meta {
            let data = metaModel(value: (key, value))
            if data.value.value != String() {
                meta.append(data)
            }   
        }
        
        cueFileInfo = CueFileInfoModel(meta: meta, rem: rem, track: cue.file.tracks.map( { t in trackModel(track: t)}), fileName: cue.file.fileName, fileExt: cue.file.fileType)
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
        isProgressShow = true
        DispatchQueue.global().async {
            if let fileUrl = self.fileURL {
                var data = [(URL, CMTimeRange)]()
                for item in self.cueFileInfo.track {
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
                let p = DispatchSemaphore(value: 0)
                AVAudioFileConverter(inputFileURL: fileUrl, outputFileURL: data)?.convert(callback: { f in print(f) }) {
                    p.signal()
                }
                p.wait()
                
                self.tagging(urls: data.map({ (u, r) in u }), sheet: self.cue!)
                self.test(urls: data.map({ (u, r) in u }))
            }
            
        }
        
    }
    
    func tagging(urls:[URL], sheet:CueSheet) {
        let def = ID3Tag(version: .version3, frames: [
            .Album: ID3FrameWithStringContent(content: sheet.meta["TITLE"] ?? ""),
            .AlbumArtist: ID3FrameWithStringContent(content: sheet.meta["PERFORMER"] ?? ""),
            .Genre: ID3FrameWithStringContent(content: sheet.rem["GENRE"] ?? ""),
            .RecordingDateTime: ID3FrameWithStringContent(content: sheet.rem["DATE"] ?? ""),
            .Composer: ID3FrameWithStringContent(content: sheet.rem["COMPOSER"] ?? ""),
        ])
        
        
        for i in urls.indices {
//            var p = DispatchSemaphore(value: 0)
//            let output = urls[i].deletingPathExtension().appendingPathExtension("m4a")
//            var assetExport = AVAssetExportSession(asset: AVAsset(url: urls[i]), presetName: AVAssetExportPresetAppleM4A)
//            assetExport?.outputFileType = AVFileType.m4a
//            assetExport?.outputURL = output
//            assetExport?.exportAsynchronously{
//                p.signal()
//            }
//            p.wait()
            
            var copy = ID3Tag(version: def.properties.version, frames: def.frames)
            copy.frames[.Title] = ID3FrameWithStringContent(content: sheet.file.tracks[i].title)
            copy.frames[.Artist] = ID3FrameWithStringContent(content: sheet.file.tracks[i].performer)
            copy.frames[.Composer] = ID3FrameWithStringContent(content: sheet.file.tracks[i].rem["COMPOSER"] ?? "")
            print(urls[i].deletingPathExtension().appendingPathExtension("wav").path)
            do {
                try ID3TagEditor().write(tag: copy, to: urls[i].deletingPathExtension().appendingPathExtension("wav").path)
            }catch (let result) {
                print(result)
            }
        }
    }
    
    func test(urls:[URL]) {
        for url in urls {
            let output = url.deletingPathExtension().appendingPathExtension("m4a")
            let result = try? ID3TagEditor().read(from: output.path)
            print((result?.frames[.Title] as?  ID3FrameWithStringContent)?.content ?? "")
            print((result?.frames[.Artist] as? ID3FrameWithStringContent)?.content ?? "")
            print((result?.frames[.Album] as? ID3FrameWithStringContent)?.content ?? "")
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
