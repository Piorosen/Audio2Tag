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

enum sheetType {
    case none
    case cueSearchDocument
    case splitStatusView
    case splitFolderDocument
}

enum alertType {
    case none
    case alertSplitView
}

class CueViewModel : ObservableObject {
    @Published var cueFileInfo = CueFileInfoModel(meta: [metaModel](), rem: [remModel](), track: [trackModel](), fileName: "", fileExt: "")
    
    // MARK: - alert창과 Sheet창 언제 보이게 할 지 나타 냄.
    @Published var openAlert = false
    @Published var openSheet = false
    
    var sheet = sheetType.none
    var alert = alertType.none
    
    func openCueSearchDocument() {
        sheet = .cueSearchDocument
        openSheet = true
    }
    func openSplitStatusView() {
        sheet = .splitStatusView
        openSheet = true
    }
    func openSplitFolderDocument() {
        sheet = .splitFolderDocument
        openSheet = true
    }
    
    func openAlertSplitView() {
        alert = .alertSplitView
        openAlert = true
    }
    
    func makeAlert() -> Alert {
        switch self.alert {
        case .alertSplitView: return Alert(title: Text("hi"))
        case .none: return Alert(title: Text("BANG"))
        }
        
    }
    func makeSheet() -> AnyView {
        switch sheet {
        case .cueSearchDocument:
            return AnyView(DocumentPicker(isFolderPicker: false).onSelectFiles{ urls in
                let _ = self.loadItem(url: urls)
            })
        case .splitFolderDocument:
            return AnyView(DocumentPicker(isFolderPicker: true))
        default:
            return AnyView(EmptyView().background(Color.red))
        }
    }
    // MARK: -
    
    var fileURL:URL?
    
    private func getCueSheet(_ url: [URL]) -> CueSheet? {
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
    func loadItem(url: [URL]) {
        guard let cue = getCueSheet(url) else {
            return
        }
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
        let track = cue.file.tracks.map({ t in trackModel(track: t) })
        
        cueFileInfo = CueFileInfoModel(meta: meta, rem: rem, track: track, fileName: cue.file.fileName, fileExt: cue.file.fileType)
    }
    
    
    
    
    func splitStart(url: URL) -> Void {
        print(url)
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
                
                //                self.tagging(urls: data.map({ (u, r) in u }), sheet: self.cue!)
            }
            
        }
        
    }
    
    //    func tagging(urls:[URL], sheet:CueSheet) {
    //        let def = ID3Tag(version: .version3, frames: [
    //            .Album: ID3FrameWithStringContent(content: sheet.meta["TITLE"] ?? ""),
    //            .AlbumArtist: ID3FrameWithStringContent(content: sheet.meta["PERFORMER"] ?? ""),
    //            .Genre: ID3FrameWithStringContent(content: sheet.rem["GENRE"] ?? ""),
    //            .RecordingDateTime: ID3FrameWithStringContent(content: sheet.rem["DATE"] ?? ""),
    //            .Composer: ID3FrameWithStringContent(content: sheet.rem["COMPOSER"] ?? ""),
    //        ])
    //
    //
    //        for i in urls.indices {
    ////            var p = DispatchSemaphore(value: 0)
    ////            let output = urls[i].deletingPathExtension().appendingPathExtension("m4a")
    ////            var assetExport = AVAssetExportSession(asset: AVAsset(url: urls[i]), presetName: AVAssetExportPresetAppleM4A)
    ////            assetExport?.outputFileType = AVFileType.m4a
    ////            assetExport?.outputURL = output
    ////            assetExport?.exportAsynchronously{
    ////                p.signal()
    ////            }
    ////            p.wait()
    //
    //            let copy = ID3Tag(version: def.properties.version, frames: def.frames)
    //            copy.frames[.Title] = ID3FrameWithStringContent(content: sheet.file.tracks[i].title)
    //            copy.frames[.Artist] = ID3FrameWithStringContent(content: sheet.file.tracks[i].performer)
    //            copy.frames[.Composer] = ID3FrameWithStringContent(content: sheet.file.tracks[i].rem["COMPOSER"] ?? "")
    //            print(urls[i].deletingPathExtension().appendingPathExtension("wav").path)
    //            do {
    //                try ID3TagEditor().write(tag: copy, to: urls[i].deletingPathExtension().appendingPathExtension("wav").path)
    //            }catch (let result) {
    //                print(result)
    //            }
    //        }
    //    }
    
}
