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
    
    @Published var sheetType: CueSheetList? = nil
    
    @Published var sheetKey = String()
    @Published var sheetValue = String()
    
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
    
    // MARK: - View의 이벤트 처리 함수
    
    func addMeta() {
        self.sheetKey = String()
        self.sheetValue = String()
        sheetType = .meta
    }
    
    func addRem() {
        self.sheetKey = String()
        self.sheetValue = String()
        sheetType = .rem
    }
    
    func addTrack() {
        self.sheetKey = String()
        self.sheetValue = String()
        sheetType = .track
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
    
    
    // MARK: - 초기화 코드
    init(_ fileInfo: Binding<CueSheetModel>) {
        self._fileInfo = fileInfo
        
        
    }
    
}
