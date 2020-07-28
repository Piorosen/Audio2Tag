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
    @Published var cueSheetModel = CueSheetModel(cueSheet: nil, cueUrl: nil, musicUrl: nil)
    
    // MARK: - 버튼 클릭 이벤트
    func navigationLeadingButton() {
        if cueSheetModel.musicUrl == nil {
            openNone()
        } else {
            openAlertSplitView()
        }
    }
    
    func navigationTrailingButton() {
        openCueSearchDocument()
    }
    
    
    // MARK: - alert창과 Sheet창 언제 보이게 할 지 나타 냄.
    @Published var openAlert = false
    @Published var openSheet = false
    @Published var test = [splitMusicModel]()
    
    var sheet = sheetType.none
    var alert = alertType.none
    
    private func openCueSearchDocument() {
        sheet = .cueSearchDocument
        openSheet = true
    }
    private func openSplitStatusView() {
        sheet = .splitStatusView
        openSheet = true
    }
    private func openSplitFolderDocument() {
        sheet = .splitFolderDocument
        openSheet = true
    }
    
    private func openAlertSplitView() {
        alert = .alertSplitView
        openAlert = true
    }
    private func openNone() {
        alert = .none
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
            return Alert(title: Text("오류"),
                         message: Text("Cue File과 음원 파일을 선택해 주세요."),
                         dismissButton: .cancel(Text("확인")))
        }
    }
    func makeSheet() -> AnyView {
        switch sheet {
        case .cueSearchDocument:
            return AnyView(DocumentPicker(isFolderPicker: false).onSelectFiles{ urls in
                let _ = self.loadItem(url: urls)
            })
        case .splitFolderDocument:
            return AnyView(DocumentPicker(isFolderPicker: true).onSelectFile { url in
                self.openSplitStatusView()
                self.splitStart(url: url)
            })
        case .splitStatusView:
            //            return AnyView(SplitMusicView(bind: event))
            return AnyView(EmptyView().background(Color.red))
            
        default:
            return AnyView(EmptyView().background(Color.red))
        }
    }
    
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
        if let cue = getCueSheet(url) {
            cueSheetModel = cue
        }
        
        if cueSheetModel.musicUrl == nil {
            alert = .none
        }else {
            alert = .alertSplitView
        }
    }
    
    
    func splitStart(url: URL) -> Void {
        // 1번 더 체크 함.
        if cueSheetModel.musicUrl == nil {
            return
        }
        
        guard let musicUrl = cueSheetModel.cueUrl else {
            return
        }
        guard let cueSheet = cueSheetModel.cueSheet else {
            return
        }
        
        DispatchQueue.global().async {
            var data = [(URL, CMTimeRange)]()
            for item in cueSheet.file.tracks {
                let u = url.appendingPathComponent("\(item.trackNum). \(item.title).wav")
                
                // 기존에 이미 있는 파일 지움.
                if FileManager.default.fileExists(atPath: u.path) {
                    try? FileManager.default.removeItem(at: u)
                }
                
                let r = CMTimeRange(start: CMTime(seconds: item.startTime!.seconds / 100, preferredTimescale: 1), duration: CMTime(seconds: item.duration!, preferredTimescale: 1))
                DispatchQueue.main.sync {
                    self.test.append(splitMusicModel(name: item.title, status: 0))
                }
                
                data.append((u, r))
            }
            
            
            AVAudioSpliter(inputFileURL: musicUrl, outputFileURL: data)?.convert { index, own, total in
                DispatchQueue.main.sync {
                    if self.test[index].status != Int(own * 100) {
                        self.test[index].status = Int(own * 100)
                        print("\(index) : \(own) : \(total) : \(Int(own * 100))")
                    }
                }
            }
        }
    }
}
