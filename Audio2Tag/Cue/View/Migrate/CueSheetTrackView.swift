//
//  CueSheetTrackView.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetTrackView: View {
    @Binding var track: CueSheetTrack
    
    var metaEdit: (UUID, UUID) -> Void = { _, _ in }
    var metaAdd: (UUID) -> Void = { _ in }
    var remEdit: (UUID, UUID) -> Void = { _, _ in }
    var remAdd: (UUID) -> Void = { _ in }
    
    func onMetaEdit(_ callback: @escaping (UUID, UUID) -> Void) -> Self {
        var copy = self
        copy.metaEdit = callback
        return copy
    }
    func onMetaAdd(_ callback: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.metaAdd = callback
        return copy
    }
    func onRemEdit(_ callback: @escaping (UUID, UUID) -> Void) -> Self {
        var copy = self
        copy.remEdit = callback
        return copy
    }
    func onRemAdd(_ callback: @escaping (UUID) -> Void) -> Self {
        var copy = self
        copy.remAdd = callback
        return copy
    }
    
    
    var body: some View {
        Form {
            Section(header: Text("Detail")) {
                HStack {
                    Text("Title")
                    Spacer()
                    Text(String(track.trackNum))
                }
                
                HStack {
                    Text("Track Number")
                    Spacer()
                    Text(String(track.trackNum))
                }
                HStack {
                    Text("Track Type")
                    Spacer()
                    Text(String(track.trackType))
                }
            }
            
            Section(header: Text("Meta")) {
                ForEach(self.track.meta.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { meta in
                    Button(action: {
                        metaEdit(track.id, meta.id)
                    }) {
                        HStack {
                            Text(meta.key.caseName.uppercased())
                            Spacer()
                            Text(meta.value)
                        }.foregroundColor(Color(UIColor.label))
                    }
                }
                AddButton("New") {
                    metaAdd(track.id)
                }
            }
            Section(header: Text("Rem")) {
                ForEach(self.track.rem.sorted { $0.key.caseName.uppercased() < $1.key.caseName.uppercased() }) { rem in
                    Button(action: {
                        remEdit(track.id, rem.id)
                    }) {
                        HStack {
                            Text(rem.key.caseName.uppercased())
                            Spacer()
                            Text(rem.value)
                        }.foregroundColor(Color(UIColor.label))
                    }
                }
                AddButton("New") {
                    remAdd(track.id)
                }
            }
            
            Section(header: Button(action: {
                
            }) {
                HStack {
                    Text("Time")
                    Spacer()
                    Text("Edit")
                }
            }) {
                HStack {
                    Text("Start")
                    Spacer()
                    Text(CSIndexTime(time: track.startTime).description)
                }
                HStack {
                    Text("End")
                    Spacer()
                    Text(CSIndexTime(time: track.endTime).description)
                }
                HStack {
                    Text("Duration")
                    Spacer()
                    if (track.endTime < track.startTime) {
                        Text("Error")
                    }else {
                        Text(CSIndexTime(time: track.endTime - track.startTime).description)
                    }
                    
                }
                
                
            }
            
        }.navigationTitle(track.title)
    }
}
