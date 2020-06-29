//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftCueSheet
import Cocoa
import AVFoundation



final class CueViewModel : ObservableObject {
    @Published var cueTitle = CueInfoModel()
    @Published var listOfCue = [CueModel]()
    @Published var progress:Float = 0
    
    var pathOfMusic = URL(fileURLWithPath: String())
    
    private func setCueSheet(sheet:CueSheet) {
        cueTitle.albumName = sheet.meta["TITLE"] ?? "None"
        cueTitle.barcode = sheet.rem["CATALOG"] ?? "None"
        cueTitle.genre = sheet.rem["GENRE"] ?? "None"
        cueTitle.avgBitrate = sheet.info?.format.sampleRate ?? 0.0
        
        for (idx, item) in sheet.file.tracks.enumerated() {
            let dur = item.duration ?? 0
            let interval = item.interval ?? 0
            
            self.listOfCue.append(CueModel(index: idx + 1, fileName: item.title, artist: item.performer, duration: dur, interval: interval))
        }
    }
    
    public func onParsingFile(url:URL?, music:URL?) {
        let parser = CueSheetParser()
        self.listOfCue.removeAll()
        
        if let url = url, let music = music {
            pathOfMusic = music
            if let cueSheet = parser.loadFile(pathOfMusic: music, pathOfCue: url) {
                setCueSheet(sheet: cueSheet)
            }
        }else if let url = url {
            if let cueSheet = parser.load(path: url) {
                // check can i accessable file?
                let musicUrl = url.deletingLastPathComponent().appendingPathComponent(cueSheet.file.fileName)
                
                pathOfMusic = musicUrl
                
                if FileManager.default.isReadableFile(atPath: musicUrl.path) {
                    if let cueSheetFile = parser.loadFile(pathOfMusic: musicUrl, pathOfCue: url) {
                        setCueSheet(sheet: cueSheetFile)
                    }
                }else {
                    setCueSheet(sheet: cueSheet)
                }
            }
        }
        
        return
    }
    
    func onOpenFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        
        panel.begin { (result) -> Void in
            if result == .OK {
                if panel.urls.count == 2 {
                    if let item = panel.urls.firstIndex(where: { $0.pathExtension.lowercased() == "cue" }) {
                        self.onParsingFile(url: panel.urls[item], music: panel.urls[item == 0 ? 1 : 0])
                    }
                }else if panel.urls.count == 1 {
                    if let item = panel.urls.first(where: { $0.pathExtension.lowercased() == "cue" }) {
                        self.onParsingFile(url: item, music: nil)
                    }
                }
            }
        }
    }
    
    func onGetDirectory(complete: @escaping (URL) -> Void) {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.begin { (result) -> Void in
            if result == .OK {
                var isDir = ObjCBool(true)
                
                if let url = panel.url {
                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) {
                        complete(url)
                    }
                }
            }
        }
    }
    
    func onSplitFile() {
        onGetDirectory { url in
            var list = [(URL, CMTimeRange)]()
            
            var time = 0.0
            for item in self.listOfCue {
                
                list.append((url.appendingPathComponent("\(item.index). \(item.fileName).flac"), CMTimeRange(start: CMTime(seconds: time, preferredTimescale: 1), duration: CMTime(seconds: item.duration, preferredTimescale: 1))))
                time += item.duration + item.interval
            }
            let av = AVAudioFileConverter(inputFileURL: self.pathOfMusic, outputFileURL: list)
            
            av!.convert{ per in
                self.progress = per
                print(per)
            }
        }
    }
}


