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

class CueViewModel : ObservableObject {
    
//    @Published var cueSheetModel = CueSheetModel(cueSheet: nil, cueUrl: nil, musicUrl: nil)
//    @Published var splitStatus = [SplitMusicModel]()
    
    // MARK: - 버튼 클릭 이벤트
    func navigationLeadingButton() {
        
    }
    
    func navigationTrailingButton() {
        
    }
    
    
    // MARK: - alert창과 Sheet창 언제 보이게 할 지 나타 냄.
    
    // MARK: -
    
    private func getCueSheet(_ url: [URL]) -> CueSheetModel? {
        let parser = CueSheetParser()
        
        if url.count == 1 {
            guard let item = parser.loadFile(cue: url[0]) else {
                return nil
            }
            let sheet = parser.calcTime(sheet: item, lengthOfMusic: 0)
            
            return CueSheetModel(cueSheet: sheet, cueUrl: url[0], musicUrl: nil)
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
            
            let musicUrl = url[abs(cueIndex - 1)]
            let cueUrl = url[cueIndex]
            guard let sheet = parser.loadFile(pathOfMusic: musicUrl, pathOfCue: cueUrl) else {
                return nil
            }
            
            return CueSheetModel(cueSheet: sheet, cueUrl: cueUrl, musicUrl: musicUrl)
        }
        else {
            return nil
        }
    }
    
    func loadItem(url: [URL]) {

        
    }
    
    
//    func splitStart(url: URL) -> Void {
//        // 1번 더 체크 함.
//        guard let musicUrl = cueSheetModel.musicUrl else {
//            return
//        }
//        guard let cueSheet = cueSheetModel.cueSheet else {
//            return
//        }
//        
////        splitStatus.removeAll()
//        
//        var data = [(URL, CMTimeRange)]()
//        for item in cueSheet.file.tracks {
//            let u = url.appendingPathComponent("\(item.trackNum). \(item.title).wav")
//            
//            // 기존에 이미 있는 파일 지움.
//            if FileManager.default.fileExists(atPath: u.path) {
//                try? FileManager.default.removeItem(at: u)
//            }
//            
//            let r = CMTimeRange(start: CMTime(seconds: item.startTime!.seconds / 100, preferredTimescale: 1), duration: CMTime(seconds: item.duration!, preferredTimescale: 1))
//            
//            data.append((u, r))
//            splitStatus.append(.init(name: item.title, status: 0))
//        }
//        
//        let count = 5
//        AVAudioSpliter(inputFileURL: musicUrl, outputFileURL: data)?.convert { index, own, total in
//            DispatchQueue.main.sync {
//                let p = Int(own * 100)
//                if (p / count) >  (self.splitStatus[index].status / count) {
//                    self.splitStatus[index].status = p
//                }
//            }
//        }
//    }
}
