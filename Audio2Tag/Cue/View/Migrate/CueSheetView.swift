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
        case .trackRemAdd(_):
            return 5
        case .trackMetaAdd(_):
            return 6
        case .trackRemEdit(_, _):
            return 7
        case .trackMetaEdit(_, _):
            return 8
        case .trackTimeEdit(_):
            return 9
        case .file:
            return 10
        case .cueSheet:
            return 11
        }
    }
    
    case cueSheet
    
    case metaAdd, remAdd, trackAdd
    case metaEdit(UUID), remEdit(UUID)
    case file
    
    case trackRemAdd(UUID), trackMetaAdd(UUID)
    case trackRemEdit(UUID, UUID), trackMetaEdit(UUID, UUID)
    case trackTimeEdit(UUID)
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
                    ForEach(self.meta.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { meta in
                        Button(action: {
                            newEvent(.metaEdit(meta.id))
                        }) {
                            HStack {
                                Text(meta.key.caseName.uppercased())
                                Spacer()
                                Text(meta.value)
                            }.foregroundColor(Color(UIColor.label))
                        }
                    }.onDelete {
                        meta.remove(atOffsets: $0)
                    }
                    AddButton("New") {
                        newEvent(.metaAdd)
                    }
                }
                Section(header: Text("Rem")) {
                    ForEach(self.rem.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { rem in
                        Button(action: {
                            newEvent(.remEdit(rem.id))
                        }) {
                            HStack {
                                Text(rem.key.caseName.uppercased())
                                Spacer()
                                Text(rem.value)
                            }.foregroundColor(Color(UIColor.label))
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
                    ForEach(self.track.indices, id: \.self) { idx in
                        NavigationLink(destination: CueSheetTrackView(track: $track[idx])
                                        .onMetaAdd { newEvent(.trackMetaAdd($0)) }
                                        .onMetaEdit { newEvent(.trackMetaEdit($0, $1)) }
                                        .onRemAdd { newEvent(.trackRemAdd($0)) }
                                        .onRemEdit { newEvent(.trackRemEdit($0, $1)) }
                                        .onTimeEdit { newEvent(.trackTimeEdit($0)) }
                        ) {
                            HStack {
                                Text(String(track[idx].trackNum))
                                Spacer()
                                Text(track[idx].title)
                            }.foregroundColor(Color(UIColor.label))
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
