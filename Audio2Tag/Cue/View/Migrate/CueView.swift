//
//  CueView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import CoreMedia
import SwiftCueSheet

struct CueView: View {
    @State var statusPresent = false
    @State var cellModel = [CueStatusCellModel]()
    
    func makeData(u: URL, c: CueSheet, removeFile: Bool = true) -> [(URL, CMTimeRange)] {
        let time = zip(c.calcTime(), c.file.tracks)
        
        let ext = String(c.file.fileName.split(separator: ".").last!)
        
        return time.map { (time, track) -> (URL, CMTimeRange) in
            let filename = u.appendingPathComponent("\(track.trackNum). \(track.meta[.title] ?? String()).\(ext)")
            
            if removeFile && FileManager.default.fileExists(atPath: filename.path) {
                try? FileManager.default.removeItem(at: filename)
            }
            
            let time = CMTimeRange(start: CMTime(seconds: time.startTime, preferredTimescale: 1000), duration: CMTime(seconds: time.duration, preferredTimescale: 1000))
            
            return (filename, time)
        }
    }
    
    var body: some View {
        ZStack {
            CueSelectView()
                .onStatus {
                    statusPresent.toggle()
                }
                .onExecute { audioUrl, cueSheet, saveDirectory in
                    cellModel.removeAll()
                    let list = makeData(u: saveDirectory, c: cueSheet, removeFile: false)
                    list.forEach { name, _ in
                        cellModel.append(CueStatusCellModel(name: name.lastPathComponent, value: 0))
                    }
                    
//                    for idx in sheet.tracks.indices {
//
//                        let u = url.appendingPathComponent("\(cueSheet.file.tracks[idx].trackNum). \(cueSheet.file.tracks[idx].meta[.title] ?? "").wav")
//
//                        // 기존에 이미 있는 파일 지움.
//                        if FileManager.default.fileExists(atPath: u.path) {
//                            try? FileManager.default.removeItem(at: u)
//                        }
//
//                        let r = CMTimeRange(start: CMTime(seconds: sheet.tracks[idx].time.startTime, preferredTimescale: 1000), duration: CMTime(seconds: sheet.tracks[idx].time.duration, preferredTimescale: 1000))
//
//                        data.append((u, r))
//                        splitState.append(.init(name: cueSheet.file.tracks[idx].meta[.title] ?? "", status: 0))
//                    }
                    
                }
                .onPreview { u, c in
                    
                }
            CueStatusView(isPresented: $statusPresent, bind: $cellModel)
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
