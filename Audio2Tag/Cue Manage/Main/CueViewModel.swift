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
    @Published var test = [splitMusicModel]()
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
        case .alertSplitView:
            return Alert(title: Text("파일 분리"),
                         message: Text("Cue File 기준으로 파일을 분리 하겠습니까?"),
                         primaryButton: .cancel(Text("취소")),
                         secondaryButton: .default(Text("확인"), action: openSplitFolderDocument))
        case .none:
            return Alert(title: Text("Error!"))
        }
    }
    func makeSheet(event: Binding<[splitMusicModel]>) -> AnyView {
        switch sheet {
        case .cueSearchDocument:
            return AnyView(DocumentPicker(isFolderPicker: false).onSelectFiles{ urls in
                let _ = self.loadItem(url: urls)
            })
        case .splitFolderDocument:
            return AnyView(DocumentPicker(isFolderPicker: true).onSelectFile { url in
                self.splitStart(url: url)
            })
        case .splitStatusView:
            return AnyView(SplitMusicView(bind: event))
            
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
        openSplitStatusView()
        
        self.test = [splitMusicModel]()
        DispatchQueue.global().async {
            if let fileUrl = self.fileURL {
                
                var data = [(URL, CMTimeRange)]()
                for (index, item) in self.cueFileInfo.track.enumerated() {
                    let u = url.appendingPathComponent("\(item.track.trackNum). \(item.track.title).wav")
                    if FileManager.default.fileExists(atPath: u.path) {
                        try? FileManager.default.removeItem(at: u)
                    }
                    let r = CMTimeRange(start: CMTime(seconds: item.track.startTime!.seconds / 100, preferredTimescale: 1), duration: CMTime(seconds: item.track.duration!, preferredTimescale: 1))
                    DispatchQueue.main.sync {
                        self.test.append(splitMusicModel(name: item.track.title, status: 0))
                    }
                    
                    data.append((u, r))
                }
                
                
                AVAudioFileConverter(inputFileURL: fileUrl, outputFileURL: data)?.convert { index, own, total in
                    DispatchQueue.main.sync {
                        self.test[index].status = own
                        print("\(index) : \(own) : \(total)")
                    }

                }
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
