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
    // MARK: - View와 Binding할 변수 및 객체.
    // 메인 화면의 List에 출력할 데이터.
    @Published var cueSheetModel = CueSheetModel(cueSheet: nil, cueUrl: nil, musicUrl: nil)
    @Published var showFolderSelection = false
    @Published var showFilesSelection = false
    @Published var showLeadingAlert = false
    
    @Published var status = [SplitMusicModel]()
    
    // MARK: - 버튼 클릭 이벤트
    
    // Navigation의 왼쪽 버튼 클릭.
    func navigationLeadingDivdeMusicButton() {
        // 분리 작업할 폴더 열람 및 파일 분리 작업.
        showLeadingAlert = true
    }
    
    func navigationLeadingDivideStatusButton() {
        // 분리하고 있는 파일 상태 바 표시 하는 시트 보여 주기.
        // TODO: Sheet를 할 것인지? Alert로 할것인지? Z-Index로 이쁘게 할것인지?
        
    }
    
    // Navigation의 오른쪽 버튼 클릭.
    func navigationTrailingButton() {
        // Cue Sheet와 Music파일 선택 하는 창 표시.
        showFilesSelection = true
    }
    
    // MARK: - alert창과 Sheet창 언제 보이게 할 지 나타 냄.
    
    
    // MARK: - CueSheet 정보 가져오기.
    
    // 내부적인 연산 처리를 담당함.
    private func getCueSheet(_ urls: [URL]) -> CueSheetModel? {
        let parser = CueSheetParser()
        // url이 1개 일 경우 Cue Sheet 파일 분리 기능을 이용함.
        if urls.count == 1 {
            guard let item = parser.loadFile(cue: urls[0]) else {
                return nil
            }
            let sheet = parser.calcTime(sheet: item, lengthOfMusic: 0)
            
            return CueSheetModel(cueSheet: sheet, cueUrl: urls[0], musicUrl: nil)
        }
            // url이 2개 인 경우 Cue Sheet와 음원이 같이 있다고 판단함.
        else if urls.count == 2 {
            // Cue 란 확장자를 가진 파일 탐색.
            
            // TODO: Cue Sheet 파일이 2개가 선택이 된 경우를 처리 해야함.
            var cueIndex = -1
            var countCue = 0
            for index in urls.indices {
                if urls[index].pathExtension.lowercased() == "cue" || urls[index].pathExtension.lowercased() == "txt" {
                    cueIndex = index
                    countCue += 1
                    break
                }
            }
            
            
            // cue 파일이 없거나, Cue파일이 여러개 입력한 경우는 nil로 반환 함.
            if cueIndex == -1 || countCue != 1 {
                return nil
            }
            
            // 다른 파일이 곧 cue Sheet라 파악이 가능함.
            let musicUrl = urls[abs(cueIndex - 1)]
            let cueUrl = urls[cueIndex]
            guard let sheet = parser.loadFile(pathOfMusic: musicUrl, pathOfCue: cueUrl) else {
                return nil
            }
            
            return CueSheetModel(cueSheet: sheet, cueUrl: cueUrl, musicUrl: musicUrl)
        }
            // 그 외에는 오류로 처리를 하지 않음.
        else {
            return nil
        }
    }
    
    // UI 와 인터렉션 담당.
    // 그래서 내부 함수인 getCueSheet를 따로 호출하여 처리를 하도록 하였음.
    func selectFiles(_ urls: [URL]) {
        guard let sheet = getCueSheet(urls) else {
            // 만약 nil 일 경우 처리를 하지 않도록 진행함.
            return
        }
        
        cueSheetModel = sheet
    }
    
    
    func musicOfSplit(url: URL) -> Void {
        // 1번 더 체크 함.
        guard let musicUrl = cueSheetModel.musicUrl else {
            return
        }
        guard let cueSheet = cueSheetModel.cueSheet else {
            return
        }
        
        //        splitStatus.removeAll()
        
        var data = [(URL, CMTimeRange)]()
        for item in cueSheet.file.tracks {
            let u = url.appendingPathComponent("\(item.trackNum). \(item.title).wav")
            
            // 기존에 이미 있는 파일 지움.
            if FileManager.default.fileExists(atPath: u.path) {
                try? FileManager.default.removeItem(at: u)
            }
            
            let r = CMTimeRange(start: item.startTime!, duration: CMTime(seconds: item.duration!, preferredTimescale: 1000))
            
            data.append((u, r))
            //                splitStatus.append(.init(name: item.title, status: 0))
        }
        
        //            let count = 5
        AVAudioSpliter(inputFileURL: musicUrl, outputFileURL: data)?.convert { index, own, total in
            DispatchQueue.main.sync {
                //                    let p = Int(own * 100)
                //                    if (p / count) >  (self.splitStatus[index].status / count) {
                //                        self.splitStatus[index].status = p
                //                    }
            }
        }
    }
}
