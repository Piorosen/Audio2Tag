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
        self.hashValue
    }
    
    case audio
    case cueSheet
}

struct CueSelectView: View {
    @State var audio: AudioFilesModel? = nil
    @State var cueSheet: CueSheet? = nil
    @State var documentMode: CueSelectMode? = nil
    
    @State var cueSheetMode: CueSheetDocument = .none
    
    
    
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
                CueSheetView(cueSheet: $cueSheet, mode: $cueSheetMode)
                    .onNew {
                        cueSheetMode = .newCueSheet
                    }
                    .onEdit {
                        cueSheetMode = .editCueSheet
                        documentMode = .cueSheet
                    }
                    .onDisacrd {
                        cueSheet = nil
                        cueSheetMode = .none
                    }
            }.navigationTitle(Text("Cue Sheet"))
            .navigationBarItems(leading: HStack {
                Button(action: {  }) {
                    Image(systemName: "play")
                }
                Button(action: { }) {
                    Image(systemName: "doc.on.doc")
                }
            }).sheet(item: $documentMode) { mode in
                Group {
                    switch mode {
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
                            .onSelectFile { url in
                                do {
                                    cueSheet = try CueSheetParser().load(path: url)
                                }catch {
                                    
                                }
                            }
                    }
                }
            }
        }
    }
}
