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
    @Published var cueTitle = CueInfoModel()
    @Published var listOfCue = [CueModel]()
    
    
    func onParsingFile(url:URL?) {
        let parser = CueSheetParser()
        self.listOfCue.removeAll()
        
        if let list = parser.Load(path: url) {
            let fileName = url!.deletingLastPathComponent().appendingPathComponent(list.file.fileName)
            
            
            let lengthOfMusic = CMTimeGetSeconds(AVURLAsset(url: fileName).duration)
            
            // calc Index Time
            for index in list.file.tracks.indices {
                var dur = 0.0
                let lastIndex = list.file.tracks[index].index.count - 1
                
                if index != list.file.tracks.count - 1 {
                    let me = list.file.tracks[index].index[lastIndex].indexTime.frames
                    let next = list.file.tracks[index + 1].index[0].indexTime.frames
                    dur = Double((next - me)) / 75
                }else {
                    let me = list.file.tracks[index].index[lastIndex].indexTime.seconds
                    dur = lengthOfMusic - me
                }
                
                var interval = 0.0
                
                if list.file.tracks[index].index.count != 0 {
                    let shortCut = list.file.tracks[index].index
                    interval = Double(shortCut.last!.indexTime.frames - shortCut.first!.indexTime.frames) / 75
                }
                
                DispatchQueue.main.async {
                    self.listOfCue.append(CueModel(fileName: list.file.tracks[index].title, artist: list.file.tracks[index].performer, duration: dur, interval: interval))
                }
            }
        }
    }
    
    func onOpenFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.begin { (result) -> Void in
            if result == .OK {
                self.onParsingFile(url: panel.url)
            }
        }
    }
    
    func onSplitFile() {
    
    }
}

