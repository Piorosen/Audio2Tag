//
//  CueSheetView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import SwiftCueSheet

enum CueSheetList : Identifiable {
    var id: Int {
        switch self {
        case .metaAdd:
            return 0
        case .remAdd:
            return 1
        case .trackAdd:
            return 2
        case .metaEdit(_):
            return 3
        case .remEdit(_):
            return 4
        case .trackEdit(_):
            return 5
        case .trackRemAdd:
            return 6
        case .trackMetaAdd:
            return 7
        case .trackRemEdit(_):
            return 8
        case .trackMetaEdit(_):
            return 9
        case .indexChange(_):
            return 10
        case .file:
            return 11
        case .cueSheet:
            return 12
        }
        
        
    }
    
    case cueSheet
    
    case metaAdd, remAdd, trackAdd
    case metaEdit(UUID), remEdit(UUID), trackEdit(UUID)
    case file
    
    case trackRemAdd, trackMetaAdd
    case trackRemEdit(UUID), trackMetaEdit(UUID)
    case indexChange(UUID)
}

struct CueSheetView: View {
    @Binding var rem: [CueSheetRem]
    @Binding var meta: [CueSheetMeta]
    @Binding var track: [CueSheetTrack]
    @Binding var file: CueSheetFile
    @Binding var mode: CueSheetDocument
    
    
    @State var pickerText: String = String()
    
    var newEvent: ((CueSheetList) -> Void) = { _ in }
    var discardEvent: (() -> Void) = { }
    
    func onNew(_ action: @escaping (CueSheetList) -> Void) -> CueSheetView {
        var copy = self
        copy.newEvent = action
        return copy
    }
    
    var editEvent: (() -> Void) = { }
    func onEdit(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.editEvent = action
        return copy
    }
    
    func onDisacrd(_ action: @escaping () -> Void) -> CueSheetView {
        var copy = self
        copy.discardEvent = action
        return copy
    }
    
    var body: some View {
        Group {
            if let mode = mode, mode == .none {
                Section(header: Text("Cue Sheet")) {
                    Button(action: { newEvent(.cueSheet) }, label: {
                        Text("New File")
                    })
                    Button(action: editEvent, label: {
                        Text("Edit File")
                    })
                }
            }else {
                Section(header: Text("Meta")) {
                    ForEach(self.meta) { meta in
                        HStack {
                            Text(meta.key.caseName.uppercased())
                            Spacer()
                            Text(meta.value)
                        }
                    }.onDelete {
                        meta.remove(atOffsets: $0)
                    }
                    AddButton("New") {
                        newEvent(.metaAdd)
                    }
                }
                Section(header: Text("Rem")) {
                    ForEach(self.rem) { rem in
                        HStack {
                            Text(rem.key.caseName.uppercased())
                            Spacer()
                            Text(rem.value)
                        }
                    }.onDelete {
                        rem.remove(atOffsets: $0)
                    }
                    AddButton("New") {
                        newEvent(.remAdd)
                    }
                }
                Section(header: Button(action: {
                    newEvent(.file)
                }) {
                    HStack {
                        Text("Track : \(file.fileName)")
                        Spacer()
                        Text("Edit")
                    }
                }) {
                    ForEach(self.track) { track in
                        HStack {
                            Text(String(track.trackNum))
                            Spacer()
                            Text(track.title)
                        }
                    }.onDelete {
                        track.remove(atOffsets: $0)
                    }
                    AddButton("New") {
                        newEvent(.trackAdd)
                    }
                }
                
                
                Section(header: Text("File Manager")) {
                    Button(action: { }) {
                        Text("Save")
                    }
                    
                    Button(action: discardEvent) {
                        Text("Discard")
                    }
                }
            }
            
        }
    }
}
