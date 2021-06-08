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
        }
    }
    
    case audio
    case cueSheet
    case cueSheetEvent(CueSheetList)
}

struct CueSelectView: View {
    @State var audio: AudioFilesModel? = nil
    @State var documentMode: CueSelectMode? = nil
    
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
                    .onNew { event in
                        switch event {
                        case .cueSheet:
                            cueSheetMode = .newCueSheet
                        default:
                            documentMode = .cueSheetEvent(event)
                        }
                    }
                    .onEdit {
                        documentMode = .cueSheet
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
        }
    }
}
