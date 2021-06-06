//
//  CueSheetEditorEditMeta.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetEditorEditMeta: View {
    @Binding var cueMeta:[CueSheetMeta]
    @Binding var present: CueSelectMode?
    
    let uuid: UUID
    
    var metaIndex: Int { cueMeta.firstIndex { $0.id == uuid } ?? 0 }
    var meta: CueSheetMeta { cueMeta[metaIndex] }
    
    @State var value = String()
    
    private static let itemList = CSMetaKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(meta.key.caseName)")
                    Spacer()
                }
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(value.isEmpty ? "Meta Value" : "Meta Value : \(meta.value)")
                    Spacer()
                }
                TextField(meta.value.isEmpty ? "Empty Data" : meta.value, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
        }.padding()
        .navigationTitle("Editting")
        .navigationBarItems(trailing: Button(action: {
            cueMeta[metaIndex].value = value
            
            present = nil
        }) {
            Text("Edit")
        })
    }
}
