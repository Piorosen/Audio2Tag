//
//  CueSelectView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI

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
    @State var audio: URL? = nil
    @State var cueSheet: URL? = nil
    @State var documentMode: CueSelectMode? = nil
    
    @State var cueSheetMode: CueSheetDocument = .none
    
    
    
    var body: some View {
        NavigationView {
            List {
                CueAudioView(audio: $audio)
                    .onLoad {
                        documentMode = .audio
                    }
                CueSheetView(cueSheet: $cueSheet, mode: $cueSheetMode)
                    .onNew {
                        cueSheetMode = .newCueSheet
                    }
                    .onEdit {
                        cueSheetMode = .newCueSheet
                        documentMode = .cueSheet
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
                                audio = url
                            }
                    case .cueSheet:
                        DocumentPicker()
                            .setConfig(folderPicker: false, allowMultiple: false)
                            .setUTType(type: [.cue])
                            .onSelectFile { url in
                                cueSheet = url
                            }
                    }
                    
                }
                
            }
        }
        
        
    }
}
