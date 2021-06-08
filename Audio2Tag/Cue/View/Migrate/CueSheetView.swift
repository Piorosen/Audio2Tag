//
//  CueSheetView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/05/28.
//

import SwiftUI
import SwiftCueSheet

enum CueSheetSheetList : Identifiable {
    var id: Int {
        switch self {
        case .metaAdd:
            return 0
        case .remAdd:
            return 1
        case .trackAdd:
            return 2
        case .trackRemAdd(_):
            return 3
        case .trackMetaAdd(_):
            return 4
        case .trackTimeEdit(_):
            return 5
        case .cueSheet:
            return 6
        }
    }
    
    case cueSheet
    
    case metaAdd, remAdd, trackAdd
    
    case trackRemAdd(UUID), trackMetaAdd(UUID)
    case trackTimeEdit(UUID)
}

enum CueSheetAlertList : Identifiable, Equatable {
    var id: Int {
        switch self {
        case .metaEdit(_):
            return 0
        case .remEdit(_):
            return 1
        case .trackRemEdit(_, _):
            return 2
        case .trackMetaEdit(_, _):
            return 3
        case .file:
            return 4
        }
    }
    
    case file
    case metaEdit(UUID), remEdit(UUID)
    case trackRemEdit(UUID, UUID), trackMetaEdit(UUID, UUID)
    
}

struct CueSheetView: View {
    @Binding var rem: [CueSheetRem]
    @Binding var meta: [CueSheetMeta]
    @Binding var track: [CueSheetTrack]
    @Binding var file: CueSheetFile
    @Binding var mode: CueSheetDocument
    
    
    var sheetEvent: ((CueSheetSheetList) -> Void) = { _ in }
    var discardEvent: (() -> Void) = { }
    
    func onSheet(_ action: @escaping (CueSheetSheetList) -> Void) -> CueSheetView {
        var copy = self
        copy.sheetEvent = action
        return copy
    }
    
    
    var newEvent: (() -> Void) = { }
    func onNew(_ action: @escaping () -> Void) -> CueSheetView {
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
    
    var alertEvent: ((CueSheetAlertList) -> Void) = { _ in }
    func onAlert(_ action: @escaping (CueSheetAlertList) -> Void) -> CueSheetView {
        var copy = self
        copy.alertEvent = action
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
                    Button(action: { newEvent() }, label: {
                        Text("New File")
                    })
                    Button(action: { editEvent() }, label: {
                        Text("Edit File")
                    })
                }
            }else {
                Section(header: Text("Meta")) {
                    ForEach(self.meta.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { meta in
                        Button(action: {
                            alertEvent(.metaEdit(meta.id))
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
                        sheetEvent(.metaAdd)
                    }
                }
                Section(header: Text("Rem")) {
                    ForEach(self.rem.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { rem in
                        Button(action: {
                            alertEvent(.remEdit(rem.id))
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
                        sheetEvent(.remAdd)
                    }
                }
                Section(header: Button(action: {
                    alertEvent(.file)
                }) {
                    HStack {
                        Text("Track : \(file.fileName)")
                        Spacer()
                        Text("Edit")
                    }
                }) {
                    ForEach(self.track.indices, id: \.self) { idx in
                        NavigationLink(destination: CueSheetTrackView(track: $track[idx])
                                        .onMetaAdd { sheetEvent(.trackMetaAdd($0)) }
                                        .onMetaEdit { alertEvent(.trackMetaEdit($0, $1)) }
                                        .onRemAdd { sheetEvent(.trackRemAdd($0)) }
                                        .onRemEdit { alertEvent(.trackRemEdit($0, $1)) }
                                        .onTimeEdit { sheetEvent(.trackTimeEdit($0)) }
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
                        sheetEvent(.trackAdd)
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
