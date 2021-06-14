//
//  CueSheetEditorAddMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

extension CSMetaKey : CaseIterable {
    public static var allCases: [CSMetaKey] = {
        [.isrc, .performer, .songWriter, .title]
    }()
}

struct CueSheetEditorAddMeta: View {
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var present: CueSelectMode?
    
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
                cueMeta.append(.init(key: .init(otherKey), value: value))
            }else {
                cueMeta.append(.init(key: .init(key), value: value))
            }
            present = nil
        }) {
            Text("Add")
        })
    }
}
