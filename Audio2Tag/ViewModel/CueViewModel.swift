//
//  CueViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/06/19.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import CueSheet
import Cocoa
import AVFoundation


class CueViewModel : ObservableObject {
    @Published var listOfCue = [CueModel]()
    @Published var fileName = URL(fileURLWithPath: "")
    
    func onOpenFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.begin { (result) -> Void in
            if result == .OK {
                let parser = CueSheetParser()
                if let list = parser.Load(path: panel.url) {
                    self.listOfCue.removeAll()
                    let name = panel.url!.deletingLastPathComponent().appendingPathComponent(list.file.fileName)
                    
                    self.fileName = name
                    let fileLength = AVURLAsset(url: name).duration
                    
                    for index in list.file.tracks.indices {
                        var dur = 0.0
                        let lastIndex = list.file.tracks[index].index.count - 1
                        
                        if index != list.file.tracks.count - 1 {
                            let me = list.file.tracks[index].index[lastIndex].indexTime.frames
                            let next = list.file.tracks[index + 1].index[0].indexTime.frames
                            
                            dur = Double((next - me)) / 75
                        }else {
                            let me = list.file.tracks[index].index[lastIndex].indexTime.seconds
                            
                            dur = CMTimeGetSeconds(fileLength) - (me)
                        }
                        
                        var interval = 0.0
                        
                        if list.file.tracks[index].index.count != 0 {
                            let shortCut = list.file.tracks[index].index
                            interval = Double(shortCut.last!.indexTime.frames - shortCut.first!.indexTime.frames) / 75
                        }
                        
                        self.listOfCue.append(CueModel(fileName: list.file.tracks[index].title, duration: dur, interval: interval))
                    }
                }
            }
        }
        
    }
    
    func onSplitFile() {
        if FileManager.default.fileExists(atPath: fileName.path) {
            // fileName -> Directory
            let asset = AVAsset(url: fileName)
            
            var list = [(start:CMTime, end:CMTime, name:String)]()
            
            var counting = 0.0
            
            let length = CMTimeGetSeconds(asset.duration)
            
            for track in listOfCue {
                let start = counting + track.interval
                let end = start + track.duration
                list.append((CMTime(seconds: start, preferredTimescale: 1), CMTime(seconds: end, preferredTimescale: 1), track.fileName))
                
                counting += track.interval + track.duration
            }
            for time in list {
                if let export = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) {
                    
                    let exportTimeRange = CMTimeRangeFromTimeToTime(start: time.start, end: time.end)
                    export.outputFileType = .m4a
                    let tmp = fileName
                    export.outputURL = tmp.deletingLastPathComponent().appendingPathComponent("\(time.name).m4a")
                    
                    export.timeRange = exportTimeRange
                    export.exportAsynchronously {
                        if (export.status == .completed)
                        {
                            print("success")
                        }
                        else if (export.status == .failed)
                        {
                            print("fail : \(time.name)")
                        }
                    }
                }
            }
        }
    }
}
