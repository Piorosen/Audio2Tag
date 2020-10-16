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

import AVFoundation

import ID3TagEditor

class CueViewModel : ObservableObject {
    @Published var isShowing = false
    @Published var status = CueSheetModel()
    @Published var splitState = [SplitMusicModel(name: "전체 진행률", status: 0)]
    @Published var openAlert = false
    var sem = DispatchSemaphore(value: 0)
    
    
    func reuqestOpenState() {
        isShowing = true
    }
    
    private var request = false
    func splitRun(b: Bool) {
        sem.signal()
        request = b
    }
    
    func splitStart(url:URL, sheet:CueSheetModel) {
        request = false
        
        guard let musicUrl = sheet.musicUrl else {
            return
        }
        let p = try? ID3TagEditor().read(from: musicUrl.path)
        
        if let _ = p {
            _ = musicOfSplit(url: url, sheet: sheet)
        }else {
            DispatchQueue.global().async {
                self.sem = DispatchSemaphore(value: 0)
                DispatchQueue.main.async {
                    self.openAlert = true
                }
                
                self.sem.wait()
                if self.request {
                    DispatchQueue.main.sync {
                        _ = self.musicOfSplit(url: url, sheet: sheet)
                    }
                }
            }
        }
        
    }
    
    func musicOfSplit(url: URL, sheet:CueSheetModel) -> [URL]? {
        // 1번 더 체크 함.
        guard let musicUrl = sheet.musicUrl else {
            return nil
        }
        guard let cueSheet = sheet.cueSheet else {
            return nil
        }
        
        isShowing = true
        
        splitState.removeAll()
        splitState.append(.init(name: "전체 진행률", status: 0))
        
        var data = [(URL, CMTimeRange)]()
        for item in cueSheet.file.tracks {
            let u = url.appendingPathComponent("\(item.trackNum). \(item.title).wav")
            
            // 기존에 이미 있는 파일 지움.
            if FileManager.default.fileExists(atPath: u.path) {
                try? FileManager.default.removeItem(at: u)
            }
            
            let r = CMTimeRange(start: item.startTime!, duration: CMTime(seconds: item.duration!, preferredTimescale: 1000))
            
            data.append((u, r))
            splitState.append(.init(name: item.title, status: 0))
        }
        
        let count = 1
        AVAudioSpliter(inputFileURL: musicUrl, outputFileURL: data)?.convert { index, own, total in
            DispatchQueue.main.async {
                let p = Int(own * 100)
                let i = index + 1
                if (p / count) >  (self.splitState[i].status / count) {
                    self.splitState[i].status = p
                }
                
                let o = Int(total * 100)
                if o / count > self.splitState[0].status / count {
                    self.splitState[0].status = o
                }
            }
        }
        
        return data.map { $0.0 }
    }
    
    
    
}
