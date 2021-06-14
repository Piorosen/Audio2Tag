//
//  CueView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import CoreMedia
import AVFoundation
import SwiftCueSheet
import ID3TagEditor

enum CueAlertEvent : Identifiable {
    var id: Int {
        return hashValue
    }
    
    case splitSuccess
    case splitFail
}

struct CueView: View {
    @State var statusPresent = false
    @State var cellModel = [CueStatusCellModel]()
    @State var alertEvent: CueAlertEvent? = nil
    
    func makeData(u: URL, c: CueSheet, removeFile: Bool = true) -> [(URL, CMTimeRange)] {
        let time = zip(c.calcTime(lengthOfMusic: AVAsset(url: u).duration.seconds), c.file.tracks)
        
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
                    
                    statusPresent = true
                    
                    DispatchQueue.global().async {
                        if let av = AVAudioSpliter(inputFileURL: audioUrl, outputFileURL: list) {
                            av.convert { idx, percent, totalPercent in
                                if Double(percent) > cellModel[idx].value {
                                    DispatchQueue.main.async {
                                        cellModel[idx].value = Double(percent)
                                    }
                                }
                                
                                if totalPercent == 1.0 {
                                    DispatchQueue.main.async {
                                        alertEvent = .splitSuccess
                                    }
                                }
                            }
                        }else {
                            DispatchQueue.main.async {
                                alertEvent = .splitFail
                            }
                        }
                    }
                }
                .onPreview { u, c in
                    
                }
            CueStatusView(isPresented: $statusPresent, bind: $cellModel)
        }.alert(item: $alertEvent) { item in
            switch item {
            case .splitFail:
                return Alert(title: Text("Fail"))
            case .splitSuccess:
                return Alert(title: Text("Success"))
            }
        }
    }
}

struct CueView_Previews: PreviewProvider {
    static var previews: some View {
        CueView()
    }
}
