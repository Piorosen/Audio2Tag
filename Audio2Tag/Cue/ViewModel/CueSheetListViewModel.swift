//
//  CueSheetListInfoViewModel.swift
//  Audio2Tag
//
//  Created by Aoikazto on 2020/08/21.
//  Copyright © 2020 Aoikazto. All rights reserved.
//

import Foundation
import SwiftUI


enum CueSheetList : Identifiable {
    var id: Int {
        self.hashValue
    }
    
    case meta
    case rem
    case track
}


class CueSheetListViewModel : ObservableObject {
    @Binding var fileInfo: CueSheetModel
    
    @Published var addSheetType: CueSheetList? = nil
    @Published var editSheetType: CueSheetList? = nil
    
    @Published var sheetKey = String()
    @Published var sheetValue = String()
    
    var editIndex: Int = -1
    
    // MARK: - View와 Binding이 된 데이터들
    var audio:CueAudio {
        get{
            return CueAudio(model: fileInfo)
        }
    }
    var meta: [MetaModel] {
        get {
            return fileInfo.meta
        }
    }
    var rem: [RemModel] {
        get {
            return fileInfo.rem
        }
    }
    var tracks: [TrackModel] {
        get { return fileInfo.tracks }
    }
    var title: String {
        get { return fileInfo.cueSheet?.file.fileName ?? "" }
    }
    
    
    // MARK: - CustomAlertView 초기화
    func resetSheet() {
        addSheetType = nil
        editSheetType = nil
        sheetKey = ""
        sheetValue = ""
    }
    
    // MARK: - View에서 Add 이벤트 처리
    func addMeta() {
        resetSheet()
        addSheetType = .meta
    }
    
    func addRem() {
        resetSheet()
        addSheetType = .rem
    }
    
    func addTrack() {
        resetSheet()
        addSheetType = .track
    }
    
    func addItem(type: CueSheetList?) {
        if sheetKey == "" || sheetValue == "" {
            // 실패 창 보여주기
        }else if let sheetType = type {
            switch sheetType {
            case .meta:
                fileInfo.meta.append(MetaModel(value: (sheetKey, sheetValue)))
            case .rem:
                fileInfo.rem.append(RemModel(value: (sheetKey, sheetValue)))
            case .track:
                print("not implements")
            }
        }
    }
    
    // MARK: - View에서 Edit 이벤트 처리
    
    func editMeta(_ idx: Int) {
        resetSheet()
        sheetKey = meta[idx].value.key
        editIndex = idx
        editSheetType = .meta
    }
    func editRem(_ idx: Int) {
        resetSheet()
        sheetKey = rem[idx].value.key
        editIndex = idx
        editSheetType = .rem
    }
    
    func editItem(type: CueSheetList?) {
        if sheetKey == "" || sheetValue == "" {
            // 실패 창 보여주기
        }else if let sheetType = type {
            switch sheetType {
            case .meta:
                fileInfo.meta[editIndex] = MetaModel(value: (sheetKey, sheetValue))
            case .rem:
                fileInfo.rem[editIndex] = RemModel(value: (sheetKey, sheetValue))
            case .track:
                print("not implements")
            }
        }
    }
    
    
    
    // MARK: - 초기화 코드
    init(_ fileInfo: Binding<CueSheetModel>) {
        self._fileInfo = fileInfo
        
        
    }
    
}
