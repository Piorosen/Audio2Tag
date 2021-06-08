//
//  CueSheetEditorEditRem.swift
//  Audio2Tag
//
//  Created by aoikazto on 2021/06/06.
//

import SwiftUI
import SwiftCueSheet

struct CueSheetEditorEditRem: View {
    @Binding var cueRem: [CueSheetRem]
    @Binding var present: CueSheetAlertList?
    
    let uuid: UUID
    
    var remIndex: Int { cueRem.firstIndex { $0.id == uuid } ?? 0 }
    var rem: CueSheetRem { cueRem[remIndex] }
    
    @State var value = String()
    
    private static let itemList = CSRemKey.allCases.map { $0.caseName } + ["other"]
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("Meta key : \(rem.key.caseName)")
                    Spacer()
                }
            }.padding([.top])
            
            VStack {
                HStack {
                    Text(value.isEmpty ? "Meta Value" : "Meta Value : \(rem.value)")
                    Spacer()
                }
                TextField(rem.value.isEmpty ? "Empty Data" : rem.value, text: $value)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }.padding()
        .navigationBarItems(trailing: Button(action: {
            cueRem[remIndex].value = value
            
            present = nil
        }) {
            Text("Edit")
        })
    }
}
