//
//  CueSheetEditorAddRem.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

extension CSRemKey : CaseIterable {
    public static var allCases: [CSRemKey] = {
        [.comment, .composer, .date, .discId, .genre, .title]
    }()
}

struct CueSheetEditorAddRem: View {
    @Binding var cueRem:[CueSheetRem]
    @Binding var present: CueSelectMode?
    
    @State var key = String()
    @State var otherKey = String()
    @State var value = String()
    
    static let itemList = CSRemKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            GroupBox(label: Text("Rem Key")) {
                Picker("Key", selection: $key) {
                    ForEach (Self.itemList, id: \.self) { item in
                        Text(item)
                    }
                }
                .onAppear {
                    key = Self.itemList[0]
                }
                if key == "other" {
                    TextField("other key", text: $otherKey)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            GroupBox(label: Text("Rem Value")) {
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
                cueRem.append(.init(key: .init(otherKey), value: value))
            }else {
                cueRem.append(.init(key: .init(key), value: value))
            }
            present = nil
        }) {
            Text("Add")
        })
    }
}
