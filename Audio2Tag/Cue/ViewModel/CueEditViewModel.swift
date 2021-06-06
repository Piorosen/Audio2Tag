//
//  CueEditViewModel.swift
//  Audio2Tag
//
//  Created by Mac13 on 2020/12/02.
//

import Foundation
import SwiftUI
import SwiftCueSheet

protocol ChangeEvent {
    func request(_ action: @escaping (CueEditViewModel.Event) -> Void) -> Self
    func meta(_ uuid:UUID)
    func rem(_ uuid:UUID)
    func track(_ uuid:UUID)
}


class CueEditViewModel : ObservableObject {
    var edit: Edit = Edit()
    var remove: Remove = Remove()
    var add: Add = Add()
    
    var requestExecute: (CueSheet, URL, URL) -> Void = { _, _, _ in }
    var requestStatus: () -> Void = { }
    var requestSaveCueSheet: (CueSheet, URL) -> Void = { _, _ in }
    
    @Published var editEvent: CueEditViewModel.Event?
    @Published var addEvent: CueEditViewModel.Event?
    @Published var removeEvent: CueEditViewModel.Event?
    
    
    @Published var sheetEvent: CueEditSheetEvent?
    @Published var rem = [CueSheetRem]()
    @Published var meta = [CueSheetMeta]()
    @Published var track = [CueSheetTrack]()
    @Published var file = CueSheetFile(fileName: "", fileType: "")
    @Published var audio = CueSheetAudio()
    
    @Published var cueUrl: URL? = nil
    @Published var audioUrl: URL? = nil
    
    func getCueSheet() -> CueSheet {
        let meta = self.meta.reduce(CSMeta()) { r, item in
            var copy = r
            copy[item.key] = item.value
            return copy
        }
        
        let rem = self.rem.reduce(CSRem()) { r, item in
            var copy = r
            copy[item.key] = item.value
            return copy
        }
        
        
        let track = self.track.map { CSTrack(trackNum: $0.trackNum, trackType: $0.trackType, index: $0.index,
                                             rem: $0.rem.reduce(CSRem()) { r, item in
                                                var copy = r
                                                copy[item.key] = item.value
                                                return copy
                                            }, meta: $0.meta.reduce(CSMeta()) { r, item in
                                                var copy = r
                                                copy[item.key] = item.value
                                                return copy
                                            })}
                                            
        let csfile = CSFile(tracks: track, fileName: file.fileName, fileType: file.fileType)
        
        return CueSheet(meta: meta, rem: rem, file: csfile)
    }
    
    // MARK: - DocumentPicker Event
    func selectFiles(urls: [URL]) {
        if urls.count == 0 {
            return 
        }
        
        let cue = urls.filter({ $0.pathExtension.lowercased() == "cue" })
        let audio = urls.filter({ $0.pathExtension.lowercased() != "cue" })
        
        if cue.count != 1 || audio.count >= 2 {
            return
        }
        
        cueUrl = cue.first
        audioUrl = audio.first
        
        
        do {
            var p = try CueSheetParser().load(path: cue[0])
            
            rem = p.rem.map { CueSheetRem(key: $0.key, value: $0.value) }
                .sorted(by: { $0.key.caseName < $1.key.caseName  })
            
            meta = p.meta.map { CueSheetMeta(key: $0.key, value: $0.value) }
                .sorted(by: { $0.key.caseName  < $1.key.caseName  })
            
//            track = p.file.tracks.map {
//                CueSheetTrack(title: $0.meta[.title] ?? "",
//                              meta: $0.meta.map { CueSheetMeta(key: $0.key, value: $0.value) }.sorted { $0.key.caseName  < $1.key.caseName  },
//                              rem: $0.rem.map { CueSheetRem(key: $0.key, value: $0.value) }.sorted(by: { $0.key.caseName  < $1.key.caseName  }),
//                              trackNum: $0.trackNum,
//                              trackType: $0.trackType,
//                              index: $0.index )}
            
            file.fileName = p.file.fileName
            file.fileType = p.file.fileType
            
            if audio.count == 1 {
                self.audio = CueSheetAudio(audio: try p.getInfoOfAudio(music: audio[0]))
            }else {
                self.audio = CueSheetAudio(audio: nil)
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func saveCueSheet(url: URL) {
        requestSaveCueSheet(getCueSheet(), url)
    }
    
    func splitCueSheet(url: URL) {
        // 큐 정보와 저장할 곳
        guard let audioUrl = audioUrl else {
            return
        }
        requestExecute(getCueSheet(), url, audioUrl)
    }
    
    // MARK: - Navigation Button Event
    
    func executePlay() {
        if audio.validate {
            self.sheetEvent = .splitFolderSelect
        }else {
            self.sheetEvent = .saveCueFolder
        }
    }
    		
    func fileSelectPicker() {
        self.sheetEvent = .fileSelect
    }
    
    
    // MARK: - CustomViewAlert Event
    
    // Add
    func addItems(event:Event?, key: String, value: String) {
        guard let e = event else {
            return
        }
        
        switch e {
        case .meta(let uuid):
            meta.append(CueSheetMeta(id: uuid, key: .init(key), value: value))
        case .rem(let uuid):
            rem.append(.init(id: uuid, key: .init(key), value: value))
        default:
            break
        }
        
    }
    
    // Edit
    func editItems(event:Event?, key: String, value: String) {
        
    }
    // Remove
    func removeItems(event:Event?, key: String, value: String) {
        
    }
    // MARK: -
    
    
    public init() {
        sheetEvent = nil
        edit = Edit().request { self.editEvent = $0 }
        remove = Remove().request { self.removeEvent = $0 }
        add = Add().request { self.addEvent = $0 }
    }
    
    enum Event : Identifiable, Equatable {
        var id: Int {
            switch self {
            case .meta(_):
                return 1
            case .rem(_):
                return 2
            case .track(_):
                return 3
            }
        }
        
        case meta(_ uuid:UUID)
        case rem(_ uuid:UUID)
        case track(_ uuid:UUID)
    }
    
    struct Edit : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Edit {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta(_ uuid: UUID) {
            request(.meta(uuid))
        }
        func rem(_ uuid: UUID) {
            request(.rem(uuid))
        }
        func track(_ uuid: UUID) {
            request(.track(uuid))
        }
    }
    struct Remove : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Remove {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta(_ uuid: UUID) {
            request(.meta(uuid))
        }
        func rem(_ uuid: UUID) {
            request(.rem(uuid))
        }
        func track(_ uuid: UUID) {
            request(.track(uuid))
        }
    }
    
    struct Add : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Add {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta(_ uuid: UUID) {
            request(.meta(uuid))
        }
        func rem(_ uuid: UUID) {
            request(.rem(uuid))
        }
        func track(_ uuid: UUID) {
            request(.track(uuid))
        }
    }
}
