//
//  CueSheetEditorTrackAddMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/08.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetEditorTrackAddMeta: View {
    @Binding var cueTrack:[CueSheetTrack]
    @Binding var present: CueSelectMode?
    
    let uuid: UUID
    
    var trackIndex: Int { cueTrack.firstIndex { $0.id == uuid } ?? 0 }
    
    @State var key = String()
    @State var otherKey = String()
    @State var value = String()
    
    private static let itemList = CSMetaKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            GroupBox(label: Text("Meta Key")) {
                Picker("Key", selection: $key) {
                    ForEach (Self.itemList, id: \.self) { item in
                        Text(item)
                    }
                }.onAppear {
                    key = Self.itemList[0]
                }
                if key == "other" {
                    TextField("other key", text: $otherKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            GroupBox(label: Text("Meta Value")) {
                TextField("value", text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
        }.padding()
        .navigationTitle("Appending")
        .navigationBarItems(trailing: Button(action: {
            if key == "other" {
                if otherKey == "" {
                    return
                }
                cueTrack[trackIndex].meta.append(.init(key: .init(otherKey), value: value))
            }else {
                cueTrack[trackIndex].meta.append(.init(key: .init(key), value: value))
            }
            present = nil
        }) {
            Text("Add")
        })
    }
}
