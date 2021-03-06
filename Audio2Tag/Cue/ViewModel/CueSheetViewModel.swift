//
//  CueFileInfoViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/16.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftCueSheet
import CoreMedia
import SwiftUI

class CueSheetViewModel : ObservableObject {
    // MARK: - View와 Binding할 변수 및 객체.
    // 메인 화면의 List에 출력할 데이터.
    @Published var cueSheetModel = CueSheetModel()
    
    @Published var openAlert = false
    @Published var openSheet = false
    
    var showFolderSelection = false
    var showFilesSelection = false
    var showLeadingAlert = false
    
    // MARK: - UI Interaction
    func onStartSplit() {
        openAlert = true
    }
    func onBadgePlus() {
        showFolderSelection = false
        showFilesSelection = true
        openSheet = true
    }
    
    // UI 와 인터렉션 담당.
    // 그래서 내부 함수인 getCueSheet를 따로 호출하여 처리를 하도록 하였음.
    func selectFiles(_ urls: [URL]) -> CueSheetModel? {
        guard let sheet = getCueSheet(urls) else {
            // 만약 nil 일 경우 처리를 하지 않도록 진행함.
            openAlert = true
            return nil
        }
        
        cueSheetModel = sheet
        return sheet
    }
    
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
}
