//
//  CueSelectView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import SwiftCueSheet

enum CueSheetDocument {
    case none
    case editCueSheet
    case newCueSheet
}

enum CueSelectMode : Identifiable {
    var id: Int {
        switch self {
        case .audio:
            return 0
        case .cueSheet:
            return 1
        case .cueSheetEvent(_):
            return 2
        case .cueSheetSave(_):
            return 3
        case .saveDirectory(_, _):
            return 4
        }
    }
    
    case audio
    case cueSheet
    case cueSheetEvent(CueSheetSheetList)
    case cueSheetSave(CueSheet)
    case saveDirectory(URL, CueSheet)
}


class CueSelectViewModel : ObservableObject {
    var ok: () -> Void = { }
    var cancel: () -> Void = { }
}

enum CueSelectAlert : Identifiable {
    var id: Int {
        return self.hashValue
    }
    
    case emptyCueSheet
    case emptyAudio
    case errorAudio
    case errorCueSheet
    case notFoundTrack
    
    case saveSuccessCueSheet
    case saveFailCueSheet
}

struct CueSelectView: View {
    @ObservedObject var viewModel = CueSelectViewModel()
    
    @State var audio: AudioFilesModel? = nil
    
    @State var documentMode: CueSelectMode? = nil
    @State var cueSheetAlert: CueSheetAlertList? = nil
    @State var cueSheetMode: CueSheetDocument = .none
    
    @State var cueRem = [CueSheetRem]()
    @State var cueMeta = [CueSheetMeta]()
    @State var cueTrack = [CueSheetTrack]()
    @State var cueFile = CueSheetFile(fileName: String(), fileType: String())
    
    @State var actionSheetExecute = false
    @State var alertEvent: CueSelectAlert? = nil
    
    var execute: (URL, CueSheet, URL) -> Void = { _, _, _ in }
    func onExecute(_ callback: @escaping (URL, CueSheet, URL) -> Void) -> Self {
        var copy = self
        copy.execute = callback
        return copy
    }
    
    var preview: (URL, CueSheet) -> Void = { _, _ in }
    func onPreview(_ callback: @escaping (URL, CueSheet) -> Void) -> Self {
        var copy = self
        copy.preview = callback
        return copy
    }
    
    var status: () -> Void = { }
    func onStatus(_ callback: @escaping () -> Void) -> Self {
        var copy = self
        copy.status = callback
        return copy
    }
    
    
    func makeCueSheet() -> CueSheet {
        let m = cueMeta.reduce(CSMeta(), { r, n in
            var copy = r
            copy[n.key] = n.value
            return copy
        })
        let r = cueRem.reduce(CSRem(), { r, n in
            var copy = r
            copy[n.key] = n.value
            return copy
        })
        
        let trackS = cueTrack.map {
            CSTrack(trackNum: $0.trackNum,
                    trackType: $0.trackType,
                    index: [CSIndex](),
                    rem: $0.rem.reduce(CSRem(), { r, n in
                        var copy = r
                        copy[n.key] = n.value
                        return copy
                    }),
                    meta: $0.meta.reduce(CSMeta(), { r, n in
                        var copy = r
                        copy[n.key] = n.value
                        return copy
                    }))
        }
        let t = cueTrack.map { CSLengthOfAudio(startTime: $0.startTime, endTime: $0.endTime) }
        
        let mt = CueSheet.makeTrack(time: t, tracks: trackS)
        
        let f = CSFile(tracks: mt,
                       fileName: cueFile.fileName,
                       fileType: cueFile.fileType)
        
        
        
        return CueSheet(meta: m, rem: r, file: f)
    }
    
    var body: some View {
        NavigationView {
            Form {
                CueAudioView(audio: $audio)
                    .onLoad {
                        documentMode = .audio
                    }
                    .onDisacrd {
                        audio = nil
                    }
                    .alert(item: $alertEvent) { item in
                        switch item {
                        case .emptyAudio:
                            return Alert(title: Text("Empty Audio"))
                        case .emptyCueSheet:
                            return Alert(title: Text("Empty CueSheet"))
                        case .errorAudio:
                            return Alert(title: Text("Load Fail : Audio"))
                        case .errorCueSheet:
                            return Alert(title: Text("Load Fail : CueSheet"))
                        case .notFoundTrack:
                            return Alert(title: Text("Not Found : Track Data"))
                        case .saveSuccessCueSheet:
                            return Alert(title: Text("Save Success"))
                        case .saveFailCueSheet:
                            return Alert(title: Text("Save Fail"))
                        }
                        
                    }
                CueSheetView(rem: $cueRem, meta: $cueMeta, track: $cueTrack, file: $cueFile, mode: $cueSheetMode)
                    .onNew {
                        cueSheetMode = .newCueSheet
                    }
                    .onEdit {
                        documentMode = .cueSheet
                    }
                    .onSheet { e in
                        documentMode = .cueSheetEvent(e)
                    }
                    .onAlert { e in
                        cueSheetAlert = e
                    }
                    .onSave { cue in
                        documentMode = .cueSheetSave(cue)
                    }
                    .onDisacrd {
                        cueRem = [CueSheetRem]()
                        cueMeta = [CueSheetMeta]()
                        cueTrack = [CueSheetTrack]()
                        cueFile = CueSheetFile(fileName: String(), fileType: String())
                        
                        cueSheetMode = .none
                    }
            }
            .navigationTitle(Text("Cue Sheet"))
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: HStack {
                Button(action: {
                    if cueSheetMode == .none {
                        alertEvent = .emptyCueSheet
                        return
                    }
                    else if audio == nil {
                        alertEvent = .emptyAudio
                        return
                    }
                    self.actionSheetExecute.toggle()
                }) {
                    Image(systemName: "play")
                }.actionSheet(isPresented: $actionSheetExecute) {
                    ActionSheet(title: Text("Execute Type"), message: nil, buttons: [.default(Text("Execute"), action: {
                        if cueTrack.count == 0 {
                            alertEvent = .notFoundTrack
                        }else {
                            if let u = audio?.url {
                                documentMode = .saveDirectory(u, makeCueSheet())
                            }
                        }
                        
                    }), .default(Text("Preview"), action: {
                        if cueTrack.count == 0 {
                            alertEvent = .notFoundTrack
                        }else {
                            if let u = audio?.url {
                                preview(u, makeCueSheet())
                            }
                        }
                    }), .cancel(Text("Cancel"))])
                }
                Button(action: status) {
                    Image(systemName: "doc.on.doc")
                }
            }) 
            .sheet(item: $documentMode) { mode in
                Group {
                    switch mode {
                    case .saveDirectory(let u, let c):
                        DocumentPicker()
                            .setConfig(folderPicker: true)
                            .onSelectFile { url in
                                self.execute(u, c, url)
                            }
                    
                    case .cueSheetSave(let cue):
                        DocumentPicker()
                            .setConfig(folderPicker: true)
                            .onSelectFile { url in
                                let getName = String(cue.file.fileName.split(separator: ".")[0])
                                if let fileList = (try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])) {
                                    let list = fileList.filter { $0.pathExtension.lowercased() == "cue" }
                                        .map { $0.deletingPathExtension().lastPathComponent }
                                    
                                    if list.contains(getName) {
                                        var index = 1
                                        while true {
                                            if !list.contains("\(getName)_(\(index))") {
                                                if cue.save(url: url.appendingPathComponent("\(getName)_(\(index)).cue")) {
                                                    print("success")
                                                }else {
                                                    print("fail")
                                                }
                                                return
                                            }
                                            index += 1
                                        }
                                    }else {
                                        if cue.save(url: url.appendingPathComponent("\(getName).cue")) {
                                            print("success")
                                        }else {
                                            print("fail")
                                        }
                                        return
                                    }
                                    
                                }
//                                if cue.save(url: url.appendPathComponent("\(cue.file.fileName).cue")) {
//                                    print("success")
//                                }else {
//                                    print("fail!")
//                                }
                            }
                    
                    case .cueSheetEvent(let item):
                        CueSheetEditorView(item: item, cueRem: $cueRem, cueMeta: $cueMeta, cueTrack: $cueTrack, cueFile: $cueFile, present: $documentMode)
                        
                    case .audio:
                        DocumentPicker()
                            .setConfig(folderPicker: false, allowMultiple: false)
                            .setUTType(type: [.audio])
                            .onSelectFile { url in
                                if let model = AudioFilesModel(url: url) {
                                    audio = model
                                }else {
                                    alertEvent = .errorAudio
                                }
                            }
                        
                    case .cueSheet:
                        DocumentPicker()
                            .setConfig(folderPicker: false, allowMultiple: false)
                            .setUTType(type: [.cue])
                            .onCancel {
                                cueSheetMode = .none
                            }
                            .onSelectFile { url in
                                do {
                                    let sheet = try CueSheetParser().load(path: url)
                                    cueRem = sheet.rem.map { CueSheetRem(key: $0, value: $1 )}
                                    cueMeta = sheet.meta.map { CueSheetMeta(key: $0, value: $1 )}
                                    
                                    cueTrack = zip(sheet.file.tracks, sheet.calcTime()).map { (track, audio) in
                                        CueSheetTrack(meta: track.meta.map { CueSheetMeta(key: $0.key, value: $0.value) },
                                                      rem: track.rem.map { CueSheetRem(key: $0.key, value: $0.value) },
                                                      trackNum: track.trackNum,
                                                      trackType: track.trackType,
                                                      index: track.index,
                                                      startTime: audio.startTime,
                                                      endTime: audio.endTime)
                                        
                                    }
                                    cueFile = CueSheetFile(fileName: sheet.file.fileName, fileType: sheet.file.fileType)
                                    cueSheetMode = .editCueSheet
                                }catch {
                                    alertEvent = .errorCueSheet
                                }
                            }
                    }
                }
            }
        }.customAlertView(CustomAlertView(item: $cueSheetAlert, title: "Edit", yes: { viewModel.ok() }, no: { viewModel.cancel() }) { item in
            Group {
                CueSheetAlertView(item: item, cueRem: $cueRem, cueMeta: $cueMeta, cueTrack: $cueTrack, cueFile: $cueFile, present: $cueSheetAlert)
                    .getMe { own in
                    viewModel.ok = own.okCallEvent
                    viewModel.cancel = own.cancelCallEvent
                }
            }
        })
    }
}
