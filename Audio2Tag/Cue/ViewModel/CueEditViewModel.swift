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
    func meta()
    func rem()
    func track()
}


class CueEditViewModel : ObservableObject {
    var edit: Edit
    var remove: Remove
    var add: Add
    
    
    var requestExecute: (CueSheet, URL) -> Void = { _, _ in }
    var requestStatus: () -> Void = { }
    var requestSaveCueSheet: (CueSheet) -> Void = { _ in }
    
    
    @Published var sheetEvent: CueEditSheetEvent?
    @Published var rem = [CueSheetRem]()
    @Published var meta = [CueSheetMeta]()
    @Published var track = [CueSheetTrack]()
    @Published var file = CueSheetFile(fileName: "", fileType: "")
    @Published var audio = CueSheetAudio()
    
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
        
        do {
            var p = try CueSheetParser().load(path: cue[0])
            
            rem = p.rem.map { CueSheetRem(key: $0.key, value: $0.value) }.sorted(by: { $0.value < $1.value })
            meta = p.meta.map { CueSheetMeta(key: $0.key, value: $0.value) }.sorted(by: { $0.value < $1.value })
            track = p.file.tracks.map { CueSheetTrack(meta: $0.meta.map { CueSheetMeta(key: $0.key, value: $0.value) }.sorted(by: { $0.value < $1.value }),
                                                      rem: $0.rem.map { CueSheetRem(key: $0.key, value: $0.value) }.sorted(by: { $0.value < $1.value }),
                                                      trackNum: $0.trackNum,
                                                      trackType: $0.trackType,
                                                      index: $0.index )}
            file.fileName = p.file.fileName
            file.fileType = p.file.fileType
            
            if audio.count == 1 {
                self.audio = CueSheetAudio(audio: try p.getInfoOfAudio(music: audio[0]))
            }else {
                self.audio = CueSheetAudio(audio: nil)
            }
        }catch {
            
        }
    }
    
    func saveCueSheet(url: URL) -> Bool {
        return getCueSheet().save(url: url)
    }
    
    func splitCueSheet(url: URL) {
        
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
    
    
    // MARK: -
    
    
    public init() {
        sheetEvent = nil
        edit = Edit().request({ e in })
        remove = Remove().request({ e in })
        add = Add().request({ e in })
    }
    
    enum Event {
        case meta
        case rem
        case track
    }
    
    struct Edit : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Edit {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
    struct Remove : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Remove {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
    struct Add : ChangeEvent {
        private var request: (Event) -> Void = { _ in }
        func request(_ action: @escaping (Event) -> Void) -> Add {
            var copy = self
            copy.request = action
            return copy
        }
        
        func meta() {
            request(.meta)
        }
        func rem() {
            request(.rem)
        }
        func track() {
            request(.track)
        }
    }
}
