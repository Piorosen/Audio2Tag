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
        }
    }
    
    case audio
    case cueSheet
    case cueSheetEvent(CueSheetSheetList)
    case cueSheetSave(CueSheet)
}


class CueSelectViewModel : ObservableObject {
    var ok: () -> Void = { }
    var cancel: () -> Void = { }
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
                CueSheetView(rem: $cueRem, meta: $cueMeta, track: $cueTrack, file: $cueFile, mode: $cueSheetMode)
                    .onNew {
                        cueSheetMode = .newCueSheet
                    }.onEdit {
                        documentMode = .cueSheet
                    }.onSheet { e in
                        documentMode = .cueSheetEvent(e)
                    }.onAlert { e in
                        cueSheetAlert = e
                    }.onSave { cue in
                        documentMode = .cueSheetSave(cue)
                    }.onDisacrd {
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
                Button(action: {  }) {
                    Image(systemName: "play")
                }
                Button(action: { }) {
                    Image(systemName: "doc.on.doc")
                }
            }) 
            .sheet(item: $documentMode) { mode in
                Group {
                    switch mode {
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
                                audio = AudioFilesModel(url: url)
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
